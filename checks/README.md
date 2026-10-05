# Checking chapter scripts

The chapter-script and book-label checks run automatically before a full `quarto render`. Failures stop the render; partial and preview renders skip these book-wide checks. To run a check independently, use the commands below from the repository root:

```sh
Rscript checks/check_chapter_scripts.R
```

This uses R with the `jsonlite` package. It reads chapter sources and compares the scripts students should produce with `R/chapter_*.R`. It checks executable code and comments separately, ignoring indentation, blank lines, Quarto chunk options, numbered code annotations and line-highlight markers. Internal whitespace and strings remain significant. It does not run R, download data or change files.

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
Rscript checks/test_checks.R
```

The tests mutate disposable copies to verify detection of code and comment drift, changed checkpoints, inherited changes and new unmapped instructions. They also check that intermediate examples remain separate and that a script cannot be verified against an include of itself.

## Checking book labels

```sh
Rscript checks/check_book_labels.R
```

This checks tracked or new non-ignored book Quarto sources for missing or duplicate execution labels
and missing level-3 heading identifiers. It also checks that visible executable R
code in the textbook has a `lst-` identifier and a blank listing caption, hidden
code stays out of listing numbering, and numbered chart chunks have captions and
alternative text. The scope includes numbered chapter sources, front matter,
appendices and included book content. Lecture slides, supporting reports,
templates, test fixtures and generated output are excluded.
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

## Checking image alternatives

```sh
Rscript checks/check_image_alternatives.R
quarto render --execute --cache-refresh
Rscript checks/check_image_alternatives.R --rendered _book
```

The source check covers published chapters, setup pages, appendices, shared
includes and distributed report/example sources. It excludes commented-out
content and literal code examples. It checks HTML images, Markdown images,
workflow diagrams, numbered figures and the generated output chunks inventoried in
`checks/image-outputs.json`. Update that inventory when adding, removing or
renaming an output chunk. The rendered check catches actual generated images
that a source search cannot identify, including unnumbered plot outputs.
It checks image alternatives and named SVGs/diagram containers; it does not prove WCAG conformance
or assess whether a description is accurate or useful.

Run standalone report renders before the book render so the copied downloads
contain their new alternatives (see `resources/README.md`). The Yarra source
normally produces PDF; render it with `--to html` when possible to inspect its
alternatives with the HTML checker. A missing Yarra HTML output is excluded
from the book HTML check because the distributed output is PDF. PDF tagging
and screen-reader behaviour need separate manual verification.

### Writing and reviewing descriptions

Use the four resources linked in [issue #72](https://github.com/mpjashby/crimemappingbook/issues/72):
[Harvard](https://accessibility.huit.harvard.edu/describe-content-images),
[Routledge](https://www.routledge.com/our-customers/authors/publishing-guidelines/accessible-content/how-to-write-alt-text-and-long-descriptions),
[Esri](https://www.esri.com/arcgis-blog/products/arcgis-storymaps/constituent-engagement/using-alternative-text-for-equitable-storytelling)
and [4 Syllables](https://4syllables.com.au/articles/text-alternatives-maps/).

Read the surrounding lesson and inspect the actual visual before describing it.
Explain its purpose and essential information in plain, objective language.
Usually a few sentences are enough; aim to stay below 100 words and move
necessary extra detail to an adjacent, clearly titled expandable description.
Do not impose a 125-character limit, repeat a caption or add findings that
are not visible in the image. End descriptions with a full stop.

For charts, identify the variables, units, relevant period and important patterns
or exceptions. For maps, identify the subject, geographic extent, relevant period,
meaning of shading/symbols and spatial relationships. Distinguish counts, rates,
density and statistically significant hotspots. Describe the specific difference
in each intermediate teaching example. For panels, give their order and say
whether scales are shared. For animations, explain the time sequence and the
changing pattern; provide a static description so readers need not watch the
animation. For screenshots and cartoons, include relevant text and relationships.

Use HTML `alt` for raw images and Quarto `fig-alt` for Markdown images and
executable output chunks, including `knitr::include_graphics()`. Assign separate
alternatives to distinct output images when a chunk emits more than one plot.
Descriptions belong at the point an image is displayed, not merely where
`ggsave()` writes its file. Keep alternatives near the plotting code and review
them whenever its data or appearance changes. Do not edit generated `_book` or
`_freeze` files as the source of an alternative.

Empty alternatives are intentional for package logos inside links that already
have meaningful `aria-label` values. For other genuinely decorative images,
use explicit `alt="" role="presentation"` in HTML and document the decision.
Do not classify a teaching map, chart or informative cartoon as decorative merely
because the prose discusses it. Leaflet widgets also need a named enclosing
group: chunk `fig-alt` alone does not give an interactive map an accessible name.
Provide accessible tables when readers need values otherwise available only
through pointer-operated map labels. Extra descriptions should remain ordinary
readable text, with a useful title and keyboard-accessible disclosure control.

After rendering, inspect descriptions against the final output, check keyboard
access to expandable descriptions/tables, and review reading order with a screen
reader. Automated accessibility checks detect omissions, but cannot detect a
reversed colour scale or an invented spatial pattern.

Workflow diagrams produced by the diagrams extension use a named `role="img"` container, so their alternative includes the order and relationships represented by arrows or branches. The shared `include/transcripts.html` script makes the image-description and map-data callouts keyboard accessible, as it does for transcripts. Keep the descriptive title prefixes above when adding such callouts.

The sequential-palette grids, Chapter 9 murder maps and Chapter 15 animation
keep their full descriptions in their alternatives rather than separate callouts.
The palette and animation alternatives can exceed the usual length recommendation.
The Chapter 9 maps illustrate how to create interactive maps, so their alternatives
summarise statewide patterns and interactive features rather than listing every
district value. Keep their `fig-alt` and enclosing group’s `aria-label` consistent.

For Mermaid diagrams, also supply `accTitle` and `accDescr` inside the diagram.
Quarto chunk `fig-alt` alone does not name the browser-rendered Mermaid SVG.

The image-alternative checker additionally requires `xml2`; regression tests require `testthat`. The image check remains a separate review step and is not run by the Quarto hooks. Raw HTML diagnostics identify the affected element by its HTML path.

## Chapter code library

`Rscript checks/check_code_library.R` checks that the appendix links every completed chapter script in `chapter-scripts.json`, plus the Chapter 11 Quarto report, exactly once. It explicitly excludes the three deliberately broken Chapter 8 examples, requires section references in descriptions, and checks that all download sources exist and are declared as published resources. It uses `jsonlite` and `yaml` and runs before a full book render.
