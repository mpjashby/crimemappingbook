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
