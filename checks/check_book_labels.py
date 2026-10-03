#!/usr/bin/env python3
"""Check stable chunk, listing and section identifiers without rendering the book.

Tracked and new non-ignored Quarto sources are checked. Generated books, caches
and ignored local teaching materials are not authoritative sources. Markdown examples
inside longer fences and R comments are deliberately not treated as headings/cells.
"""
from collections import Counter
from pathlib import Path
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
IDENTIFIER = re.compile(r"^[a-z][a-z0-9]*(?:-[a-z0-9]+)*$")


def source_blocks(text):
    """Yield actual executable R cells and H3 headings, respecting fence lengths."""
    lines = text.splitlines()
    index = 0
    in_comment = False
    while index < len(lines):
        line = lines[index]
        opening = re.match(r"^\s*(`{3,}|~{3,})(.*)$", line)
        if opening:
            fence, info = opening.groups()
            end = index + 1
            closing = re.compile(r"^\s*" + re.escape(fence[0]) + r"{" + str(len(fence)) + r",}\s*$")
            while end < len(lines) and not closing.match(lines[end]):
                end += 1
            if re.match(r"\{r(?:\s|\})", info.strip()):
                body = "\n".join(lines[index + 1:end])
                options = dict(re.findall(r"^\s*#\|\s*([\w-]+):[ \t]*([^\n]*)", body, re.MULTILINE))
                options = {key: value.strip().strip('\"\'') for key, value in options.items()}
                legacy = re.match(r"\{r\s+([^,}\s]+)", info.strip())
                if legacy and "label" not in options:
                    options["label"] = legacy[1]
                if in_comment:
                    options["_commented"] = "true"
                yield "chunk", index + 1, options
            if info.strip() == "{mermaid}":
                body = "\n".join(lines[index + 1:end])
                options = dict(re.findall(r"^\s*%%\|\s*([\w-]+):[ \t]*([^\n]*)", body, re.MULTILINE))
                options = {key: value.strip().strip('\"\'') for key, value in options.items()}
                yield "diagram", index + 1, options
            index = end + 1
            continue
        if "<!--" in line:
            in_comment = True
        if "-->" in line:
            in_comment = False
        if re.match(r"^###\s+\S", line):
            identifier = re.search(r"\{[^}]*#([\w-]+)[^}]*\}", line)
            yield "heading", index + 1, identifier[1] if identifier else None
        index += 1


def book_source(path):
    return bool(re.match(r"\d\d_[^/]+/index\.qmd$", path)) or path.startswith(("appendices/", "include/")) or path in ("index.qmd", "contents.qmd", "setup.qmd")


def document_defaults(text):
    if not text.startswith("---\n"):
        return {}
    front = text.split("---", 2)[1]
    execute = re.search(r"^execute:\s*\n((?:[ \t]+[^\n]*\n)*)", front, re.MULTILINE)
    return dict(re.findall(r"^\s+(echo|include):\s*(\w+)", execute[1], re.MULTILINE)) if execute else {}


def check_sources(sources):
    errors, anchors = [], []
    counts = Counter()
    for path, text in sources.items():
        labels = []
        defaults = document_defaults(text)
        for kind, line, value in source_blocks(text):
            where = f"{path}:{line}"
            if kind == "heading":
                counts["headings"] += 1
                if not value:
                    errors.append(f"{where}: level-3 heading needs an identifier")
                elif not IDENTIFIER.fullmatch(value):
                    errors.append(f"{where}: invalid section identifier {value!r}")
                continue
            counts["diagrams" if kind == "diagram" else "chunks"] += 1
            label = value.get("label")
            if not label:
                errors.append(f"{where}: chunk needs an execution label")
            elif not IDENTIFIER.fullmatch(label):
                errors.append(f"{where}: invalid execution label {label!r}")
            else:
                labels.append(label)
            if kind == "diagram" or not book_source(path):
                continue
            visible = value.get("echo", defaults.get("echo", "true")) != "false" and value.get("include", defaults.get("include", "true")) != "false"
            visible = visible and value.get("_commented") != "true"
            listing = value.get("lst-label")
            if visible:
                counts["listings"] += 1
                if not listing or not listing.startswith("lst-") or not IDENTIFIER.fullmatch(listing):
                    errors.append(f"{where}: visible code needs a semantic lst-label")
                if value.get("lst-cap") != "":
                    errors.append(f"{where}: visible code needs a blank lst-cap")
            elif listing or "lst-cap" in value:
                errors.append(f"{where}: hidden code must not enter listing numbering")
            if listing:
                anchors.append(listing)
            if label and label.startswith("fig-"):
                anchors.append(label)
                if "fig-cap" not in value:
                    errors.append(f"{where}: numbered chart needs fig-cap")
                if not value.get("fig-alt"):
                    errors.append(f"{where}: numbered chart needs alternative text")
        for label, count in Counter(labels).items():
            if count > 1:
                errors.append(f"{path}: duplicate execution label {label!r}")
        if book_source(path):
            # Source attributes are outside executable examples after masking fences.
            masked = re.sub(r"(?ms)^(`{3,}|~{3,}).*?^\1\s*$", "", text)
            anchors.extend(re.findall(r"\{[^}\n]*#((?:sec|map|fig|lst)-[\w-]+)", masked))
    for anchor, count in Counter(anchors).items():
        if not IDENTIFIER.fullmatch(anchor):
            errors.append(f"Invalid book cross-reference identifier: {anchor}")
        if count > 1:
            errors.append(f"Duplicate book cross-reference identifier: {anchor}")
    return errors, counts


def main():
    paths = subprocess.check_output(["git", "ls-files", "--cached", "--others", "--exclude-standard", "*.qmd"], cwd=ROOT, text=True).splitlines()
    sources = {path: (ROOT / path).read_text() for path in paths if not path.startswith("_book/")}
    errors, counts = check_sources(sources)
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    print(f"Checked {counts['chunks']} labelled R chunks, {counts['diagrams']} labelled diagrams, {counts['listings']} visible listings and {counts['headings']} labelled level-3 headings.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
