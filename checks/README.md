# Checking chapter scripts

Run from the repository root:

```sh
python3 checks/check_chapter_scripts.py
```

This uses only Python's standard library. It reads chapter sources and compares the scripts students should produce with `R/chapter_*.R`. It checks executable code and comments separately, ignoring indentation, blank lines, Quarto chunk options, numbered code annotations and line-highlight markers. Internal whitespace and strings remain significant. It does not run R, download data or change files.

## Reconciliation rules

- Use the code that the chapter tells students to save when executable code differs.
- Preserve organising section comments from the script and show them in the relevant saved-code chunk. When students develop a pipeline in the Console, put the section header in the complete saved pipeline only.
- Use the more detailed ordinary comment in both the chapter and script, checking that it accurately describes the retained code.

## Maintaining the mapping

`chapter-scripts.json` records the final version of each section in script order. Each `parts` entry identifies a chapter and a stable Quarto chunk label. Add a `#| label:` to a new saved-code chunk and add its reference to the appropriate script. Labels are metadata and are not copied into student scripts.

A part can use `from` (inclusive) and `before` (exclusive) to select a section between unique, literal lines. For example, Chapter 5's initial download chunk also contains an early data-loading expression. Only its download remains in the completed script; a later chunk supplies the final loading pipeline.

A `script` part inherits the expected code reconstructed from another script's chapter instructions, rather than reading that script from disk. This handles chapters that ask students to copy earlier work. The Chapter 6 recipe separately inserts the new boundary download and loading code into the inherited Chapter 5 preparation code.

`checkpoints` compares partial-script examples with the instructions students have followed at that point. Chapter 4's model answers also check their inherited Chapter 3 code. Its second new pipeline is an exercise solution, so that solution supplies the code for the exercise rather than an earlier worked example.

`intermediate_chunks` records earlier saved versions that are deliberately replaced later, with a reason for each. Console examples and hidden rendering infrastructure do not belong in the finished script. Complete-script examples using `#| file:` display the checked script, but cannot independently establish that the earlier instructions produce that script. Where a chapter gives a complete script directly, the chapter contains its code explicitly.

The Chapter 8 error and minimal-example scripts deliberately retain the `+` operator that causes the teaching example's error. The corrected script uses `|>`. The generated reprex variant has an explicit document-header exception; its R code inherits the same minimal example.

When changing a pipeline, check the surrounding instructions as well as the mapping: students need to know whether to append, insert, replace or remove code, including any organising comments. The check reports unmapped chapter scripts and visible chunks labelled with a chapter script filename. Instructions expressed only in prose and exercises without worked code still need human review.

## Testing the checker

```sh
python3 -m unittest discover -s checks -p 'test_*.py'
```

The tests mutate disposable copies to verify detection of code and comment drift, changed checkpoints, inherited changes and new unmapped instructions. They also check that intermediate examples remain separate and that a script cannot be verified against an include of itself.

## Checking book labels

```sh
python3 checks/check_book_labels.py
```

This checks every tracked or new non-ignored Quarto source for missing or duplicate execution labels
and missing level-3 heading identifiers. It also checks that visible executable R
code in the textbook has a `lst-` identifier and a blank listing caption, hidden
code stays out of listing numbering, and numbered chart chunks have captions and
alternative text. Supporting reports retain their own numbering conventions.
Fenced teaching examples and R comments are excluded from heading checks. Chunks
in commented-out teaching sections retain execution labels but do not need visible
listing metadata.

Use descriptive lower-case identifiers with hyphens. Execution labels are unique
within each document; `sec-`, `lst-`, `map-` and `fig-` anchors are unique across the
book. Retain existing captions; use blank captions for newly numbered outputs.
For generated Maps, wrap the output cell in a `::: {#map-description}` div. Do not
add a final caption paragraph unless preserving an existing caption.

`filters/numbered-outputs.lua` runs at `pre-ast`. It converts blank listing captions
to equivalent listing divs, avoiding a Quarto 1.10.18 error on undecorated code
blocks, and moves visible Code listings outside Map floats so Quarto does not
number them as subfigures. It also reunites source blocks that knitr splits around console output, so a
single chunk receives one listing number and anchor. Results follow the complete
listing. The analytical code still executes only once. Verify
these behaviours when upgrading Quarto, including filename headers, code copying,
interactive widgets, animated maps and multi-panel outputs.

After source checks, render the book and check for unresolved cross-references,
chapter numbering, blank captions, retained alternative text, and generated image
paths containing `unnamed-chunk-`. A full render must execute changed chapters;
`--no-execute` or stale frozen results cannot verify their new labels.
Use `--cache-refresh` when renaming labels in chapters with cached chunks, since
knitr can otherwise retain the previous listing identifiers in cached output.

For a compact rendering regression check, render
`checks/fixtures/numbered-outputs.qmd`. Its local `_quarto.yml` makes this a
standalone document rather than a book chapter. It exercises visible and hidden static Maps, a Leaflet widget, a saved
animated GIF, a multi-panel Map, blank Figure captions and an existing caption.
Expect Code 1–5, Map 1–5 and Figure 1–3, with no subfloat letters, `example.R` and
`R Console` filename headers intact, and "An existing caption" retained on Figure 2. The final listing tests interleaved console output; it must
have one Code label and anchor, with both results retained. The paired-chart example tests a stable parent Figure
anchor for multiple output images, using blank subcaptions.
