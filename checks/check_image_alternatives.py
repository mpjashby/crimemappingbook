#!/usr/bin/env python3
"""Check image alternatives in source and, optionally, rendered HTML.

This checks coverage, not descriptive quality. Run the HTML check after a fresh
render: source metadata alone cannot verify generated plots or SVG diagrams.
"""
import argparse
from collections import Counter
from html.parser import HTMLParser
import json
from pathlib import Path
import re
import sys

from check_book_labels import source_blocks

ROOT = Path(__file__).resolve().parents[1]


def source_paths(root=ROOT):
    """Published book sources and the standalone reports/examples it distributes."""
    return sorted({
        *(root / path for path in re.findall(
            r'^\s*-\s+([^\s#\"]+\.qmd)(?:\s|$)',
            (root / '_quarto.yml').read_text(), re.M)),
        *(root.glob('include/*.qmd')),
        *(root.glob('resources/reports/*.qmd')),
        *(root.glob('resources/examples/*.qmd')),
    })


def prose_only(text):
    """Mask comments and fenced code, retaining positions for line diagnostics."""
    text = re.sub(r'<!--.*?-->', lambda m: re.sub(r'[^\n]', ' ', m[0]), text, flags=re.S)
    lines = text.splitlines(keepends=True)
    fence = None
    for i, line in enumerate(lines):
        opening = re.match(r'^\s*(`{3,}|~{3,})', line)
        if fence:
            lines[i] = re.sub(r'[^\n]', ' ', line)
            if re.match(r'^\s*' + re.escape(fence[0]) + '{' + str(len(fence)) + r',}\s*$', line):
                fence = None
        elif opening:
            fence = opening[1]
            lines[i] = re.sub(r'[^\n]', ' ', line)
    return ''.join(lines)


class ImageParser(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.errors = []
        self.counts = Counter()
        self.links = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == 'a':
            self.links.append(attrs.get('aria-label', '').strip())
        if tag == 'img':
            self.counts['images'] += 1
            if 'alt' not in attrs:
                self.errors.append((self.getpos()[0], 'image lacks an alt attribute'))
            elif not attrs['alt'].strip():
                self.counts['empty alternatives'] += 1
                # Empty alt is valid for decoration. Authors must explicitly mark
                # standalone decoration; logos in named links are redundant.
                if not (any(self.links) or attrs.get('role') == 'presentation'
                        or attrs.get('aria-hidden') == 'true'):
                    self.errors.append((self.getpos()[0], 'empty alt needs documented decorative markup or a named link'))
        if tag != 'img' and (attrs.get('role') == 'img'
                            or (tag == 'svg' and 'graphics-document' in attrs.get('role', '').split())):
            self.counts['named graphics'] += 1
            if not (attrs.get('aria-label', '').strip() or attrs.get('aria-labelledby', '').strip()):
                self.errors.append((self.getpos()[0], 'graphic with role img lacks an accessible name'))

    def handle_endtag(self, tag):
        if tag == 'a' and self.links:
            self.links.pop()

    def handle_startendtag(self, tag, attrs):
        self.handle_starttag(tag, attrs)
        self.handle_endtag(tag)


def check_source(path, text, expected=()):
    errors = []
    counts = Counter()
    prose = prose_only(text)
    parser = ImageParser()
    parser.feed(prose)
    errors.extend(f'{path}:{line}: {message}' for line, message in parser.errors)
    counts.update(parser.counts)
    # Markdown alt and Quarto fig-alt are distinct from figure captions.
    for match in re.finditer(r'!\[([^\]]*)\]\(([^\n)]*)\)(\{[^\n}]*\})?', prose):
        caption, target, attributes = match.groups()
        counts['Markdown images'] += 1
        alternative = re.search(r'(?:fig-alt|alt)\s*=\s*([\"\'])(.*?)\1', attributes or '')
        if alternative and alternative[2].strip():
            continue
        if not alternative and caption.strip():
            continue
        # The named paletteer link uses an explicitly empty alternative.
        line = prose[prose.rfind('\n', 0, match.start()) + 1:prose.find('\n', match.end())]
        if re.search(r'aria-label\s*=\s*[\"\'][^\"\']+', line):
            continue
        number = prose.count('\n', 0, match.start()) + 1
        errors.append(f'{path}:{number}: Markdown image needs meaningful alt text or a named decorative link ({target})')
    for match in re.finditer(r'^:{3,}\s+\{\.(?:process|hierarchy)\b[^}]*\}', prose, re.M):
        counts['workflow diagrams'] += 1
        if not re.search(r'aria-label\s*=\s*[\"\'][^\"\']+', match[0]):
            number = prose.count('\n', 0, match.start()) + 1
            errors.append(f'{path}:{number}: workflow diagram needs an accessible description')
    chunks = {}
    for kind, line, options in source_blocks(text):
        if kind not in ('chunk', 'diagram') or options.get('_commented'):
            continue
        label = options.get('label', '')
        chunks[label] = options
        if label in expected or (label.startswith('fig-') and options.get('include') != 'false') or kind == 'diagram':
            counts['generated visuals'] += 1
            alternative = options.get('fig-alt', '').strip()
            if not alternative:
                errors.append(f'{path}:{line}: generated visual {label!r} needs fig-alt')
            elif alternative.startswith('['):
                # Inline JSON is also valid YAML, used for per-output alternatives.
                try:
                    values = json.loads(alternative)
                except ValueError:
                    values = None
                if values is not None and (not values or not all(isinstance(value, str) and value.strip() for value in values)):
                    errors.append(f'{path}:{line}: every generated panel needs a non-empty alternative')
            if kind == 'diagram':
                body = text.splitlines()[line:]
                end = next((i for i, value in enumerate(body) if re.match(r'^\s*`{3,}\s*$', value)), len(body))
                diagram = '\n'.join(body[:end])
                if not (re.search(r'^\s*accTitle:\s*\S', diagram, re.M)
                        and re.search(r'^\s*accDescr(?::\s*\S|\s*\{)', diagram, re.M)):
                    errors.append(f'{path}:{line}: Mermaid SVG needs accTitle and accDescr')
    for label in expected:
        if label not in chunks:
            errors.append(f'{path}: inventoried output chunk {label!r} is absent; review image-outputs.json')
    return errors, counts


def main():
    arguments = argparse.ArgumentParser(description=__doc__)
    arguments.add_argument('--rendered', type=Path, help='freshly rendered book directory, usually _book')
    args = arguments.parse_args()
    inventory = json.loads((ROOT / 'checks/image-outputs.json').read_text())
    errors, counts = [], Counter()
    for source in source_paths():
        if not source.exists():
            errors.append(f'{source}: expected source is absent')
            continue
        relative = str(source.relative_to(ROOT))
        found, seen = check_source(relative, source.read_text(), inventory.get(relative, []))
        errors.extend(found)
        counts.update(seen)
        if args.rendered and 'include/' not in relative:
            output = args.rendered / Path(relative).with_suffix('.html')
            # Yarra is a PDF-only example; its HTML can be checked separately
            # when explicitly rendered with --to html for accessibility QA.
            if not output.exists() and relative == 'resources/reports/yarra_waste_dumping.qmd':
                continue
            if not output.exists():
                errors.append(f'{output}: rendered page is absent')
                continue
            parser = ImageParser()
            parser.feed(output.read_text())
            errors.extend(f'{output}:{line}: {message}' for line, message in parser.errors)
            counts.update({'rendered ' + name: value for name, value in parser.counts.items()})
    for error in errors:
        print(error, file=sys.stderr)
    print(', '.join(f'{value} {name}' for name, value in sorted(counts.items())))
    return bool(errors)


if __name__ == '__main__':
    sys.exit(main())
