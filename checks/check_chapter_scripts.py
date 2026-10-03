#!/usr/bin/env python3
"""Check student scripts against chapter instructions without executing R code.

Run from any directory: python3 /path/to/book/checks/check_chapter_scripts.py
The manifest records the final version of each saved section, including code
inherited from previous chapters. Complete-script file includes are never used
as independent evidence that earlier instructions produce the same script.
"""

import argparse
import difflib
import json
from pathlib import Path
import re
import sys

CHUNK = re.compile(r"^```\{r[^\n]*\}\n(.*?)^```[ \t]*$", re.MULTILINE | re.DOTALL)
OPTION = re.compile(r"^#\| ([\w-]+):[ \t]*(.*)$", re.MULTILINE)
ANNOTATION = re.compile(r"[ \t]*#(?:[ \t]*<\d+>|<<)[ \t]*$")


def chunk_code(body):
    """Remove Quarto options, numbered annotations and highlight markers only."""
    result = []
    for line in body.splitlines():
        if line.startswith("#|"):
            continue
        # A marker occupying an entire line should not leave an empty line
        # inside a call; genuine blank lines are otherwise preserved.
        if ANNOTATION.fullmatch(line):
            continue
        result.append(ANNOTATION.sub("", line).rstrip())
    return "\n".join(result).strip() + "\n"


def select(code, part):
    """Select a section using unique literal boundary lines, never line numbers."""
    lines = code.splitlines()
    for boundary in ("from", "before"):
        if boundary in part:
            hits = [i for i, line in enumerate(lines) if line == part[boundary]]
            if len(hits) != 1:
                raise ValueError(f"Expected one {boundary} boundary {part[boundary]!r}: {part}")
            lines = lines[hits[0]:] if boundary == "from" else lines[:hits[0]]
    return "\n".join(lines).strip() + "\n"


def code_and_comments(code):
    """Compare code and comments independently, preserving comment placement.

    Ignore indentation, blank lines and trailing spaces. Retain strings and
    internal whitespace exactly. Hash signs inside quoted strings are code,
    including hex colours and URLs. Comments are tied to their code-line index.
    """
    executable, comments = [], []
    quote = None
    escaped = False
    for line in code.splitlines():
        start = None
        for index, char in enumerate(line):
            if quote is not None:
                if escaped:
                    escaped = False
                elif char == "\\":
                    escaped = True
                elif char == quote:
                    quote = None
            elif char in ('"', "'", "`"):
                quote = char
            elif char == "#":
                start = index
                break
        code_line = (line if start is None else line[:start]).strip()
        if code_line:
            executable.append(code_line)
        if start is not None:
            comments.append((len(executable), line[start:].strip()))
        escaped = False
    return executable, comments


class Book:
    def __init__(self, root, manifest):
        self.root = root
        self.manifest = manifest
        self.chunks = {}
        self.all_chunks = []
        self.built = {}
        self.building = set()
        if manifest.get("version") != 1:
            raise ValueError("Unsupported chapter-script manifest version")
        for path in sorted(root.glob("[0-9][0-9]_*/index.qmd")):
            chapter = path.relative_to(root).as_posix()
            text = path.read_text()
            for match in CHUNK.finditer(text):
                options = {key: value.strip('"\' ') for key, value in OPTION.findall(match[1])}
                # Older chunks can put the label in the opening fence.
                fence = match[0].splitlines()[0]
                if "label" not in options and fence != "```{r}":
                    options["label"] = fence[len("```{r"):].rstrip("}").strip().split(",")[0]
                chunk = {"chapter": chapter, "line": text[:match.start()].count("\n") + 1,
                         "options": options, "code": chunk_code(match[1])}
                self.all_chunks.append(chunk)
                if "label" in options:
                    key = (chapter, options["label"])
                    if key in self.chunks:
                        raise ValueError(f"Duplicate chunk label: {key}")
                    self.chunks[key] = chunk

    def chapter_part(self, part):
        key = (part["chapter"], part["chunk"])
        if key not in self.chunks:
            raise ValueError(f"Missing chapter chunk: {key}")
        chunk = self.chunks[key]
        if "file" in chunk["options"]:
            raise ValueError(f"Source chunk {key} includes a script instead of independent chapter code")
        if not chunk["code"].strip():
            raise ValueError(f"Source chunk {key} is empty")
        return select(chunk["code"], part)

    def assemble(self, parts):
        sections = []
        for part in parts:
            if "script" in part:
                code = select(self.build(part["script"]), part)
            else:
                code = self.chapter_part(part)
            sections.append(code.strip())
        return "\n\n".join(section for section in sections if section) + "\n"

    def build(self, script):
        if script in self.built:
            return self.built[script]
        if script in self.building:
            raise ValueError(f"Cyclic script inheritance: {script}")
        if script not in self.manifest["scripts"]:
            raise ValueError(f"Unmapped inherited script: {script}")
        self.building.add(script)
        specification = self.manifest["scripts"][script]
        code = specification.get("prefix", "") + self.assemble(specification["parts"])
        self.building.remove(script)
        self.built[script] = code
        return code

    def coverage_errors(self):
        errors = []
        actual = {path.relative_to(self.root).as_posix() for path in (self.root / "R").glob("chapter_*.R")}
        mapped = set(self.manifest["scripts"])
        for script in sorted(actual - mapped):
            errors.append(f"Unmapped script: {script}")
        for script in sorted(mapped - actual):
            errors.append(f"Missing script: {script}")
        handled = set()
        for specification in self.manifest["scripts"].values():
            handled.update((p["chapter"], p["chunk"]) for p in specification["parts"] if "chapter" in p)
        for checkpoint in self.manifest.get("checkpoints", []):
            handled.add((checkpoint["chapter"], checkpoint["chunk"]))
            handled.update((p["chapter"], p["chunk"]) for p in checkpoint["parts"] if "chapter" in p)
        for intermediate in self.manifest.get("intermediate_chunks", []):
            if not intermediate.get("note"):
                errors.append(f"Intermediate chunk needs a reason: {intermediate}")
            self.chapter_part(intermediate)  # Detect renamed or deleted exceptions.
            handled.add((intermediate["chapter"], intermediate["chunk"]))
        for chunk in self.all_chunks:
            options = chunk["options"]
            filename = options.get("filename", "")
            if not re.fullmatch(r"chapter_\d+[a-z]?\.R", filename):
                continue
            if options.get("echo") == "false" or options.get("include") == "false":
                continue  # Rendering infrastructure is not student instruction.
            if "file" in options:
                path = (self.root / chunk["chapter"]).parent / options["file"]
                included = path.resolve().relative_to(self.root.resolve()).as_posix()
                if included not in mapped:
                    errors.append(f"Unmapped complete-script include: {included}")
                continue
            key = (chunk["chapter"], options.get("label"))
            if key not in handled:
                errors.append(f"Unmapped saved-code chunk: {chunk['chapter']}:{chunk['line']} ({filename})")
        return errors

    def check(self):
        errors = self.coverage_errors()
        for script in self.manifest["scripts"]:
            if (self.root / script).is_file():
                errors.extend(compare(script, self.build(script), (self.root / script).read_text()))
        for checkpoint in self.manifest.get("checkpoints", []):
            name = f"{checkpoint['chapter']} ({checkpoint['chunk']})"
            errors.extend(compare(name, self.assemble(checkpoint["parts"]), self.chapter_part(checkpoint)))
        return errors


def compare(name, expected, actual):
    errors = []
    expected_code, expected_comments = code_and_comments(expected)
    actual_code, actual_comments = code_and_comments(actual)
    for category, left, right in (("code", expected_code, actual_code),
                                  ("comments", expected_comments, actual_comments)):
        if left != right:
            diff = "\n".join(difflib.unified_diff([str(item) for item in left],
                            [str(item) for item in right], fromfile="chapter instructions",
                            tofile=name, lineterm=""))
            errors.append(f"{name}: {category} differs\n{diff}")
    return errors


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1],
                        help="Book root (defaults to this checker's repository)")
    arguments = parser.parse_args()
    root = arguments.root.resolve()
    try:
        manifest = json.loads((root / "checks/chapter-scripts.json").read_text())
        book = Book(root, manifest)
        errors = book.check()
    except (ValueError, KeyError, OSError) as error:
        print(f"Consistency check failed: {error}", file=sys.stderr)
        return 1
    if errors:
        print("\n\n".join(errors), file=sys.stderr)
        return 1
    print(f"All {len(manifest['scripts'])} chapter scripts and "
          f"{len(manifest.get('checkpoints', []))} checkpoints match the chapter instructions.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
