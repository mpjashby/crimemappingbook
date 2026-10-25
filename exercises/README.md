# Companion exercise website

To preview, first change from the repository root into the exercise project:

```sh
cd exercises
quarto preview
```

Quarto previews the project in the current directory; the preview argument is
for a document rather than a project directory.

To render without previewing, run `quarto render` inside `exercises/`, or run
`quarto render exercises` from the repository root.

Output is written to `exercises/_site/`. A complete book render also renders
this project, copies its output to `_book/exercises/`, and includes it in
`_site/2026/exercises/` when assembling the edition website. The existing
GitHub Actions FTP workflow deploys that committed output with the book.
Partial book renders and previews do not update the publishing website.

Commit the exercise source files and the generated `_book/exercises/` and
`_site/2026/exercises/` directories. Local downloads, analytical output,
execution caches and `exercises/_site/` remain ignored. See
`../publishing/README.md` for the complete publishing workflow.

For each new exercise, create a directory named `{place_crimetype}`
(for example, `new_york_shootings`). Use the same descriptive name for the
runnable specimen file, and append `_answer` for its answer page. The task page
is `index.qmd`. Keep these names stable when adding or reordering exercises.

In `_quarto.yml`, add the pages to `project.render`, the downloadable file to
`project.resources`, and the task page to `listing.contents`. Keep both page
lists in prerequisite order, from the fewest completed chapters to the most.
The catalogue uses `sort: false` to preserve the configured order. Include
`listing: false` in task and answer front matter so only the home page displays
the inherited catalogue. Prerequisite metadata belongs on each task page.

For Quarto exercises, render specimen reports separately rather than adding
them to website navigation.

Keep displayed R specimens included from the downloadable script. Verify each
specimen in a fresh student workspace, including downloads and basemaps, before
publication. Check links, narrow-screen layout and keyboard accessibility.
