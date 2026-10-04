# Prepare a book update for GitHub

Run these commands from the repository root (the folder containing `_quarto.yml`), using the Positron terminal. Choose the guide matching your update. Nothing is committed, pushed or uploaded automatically.

A complete `quarto render` now prepares the publishing output automatically:

- Before rendering, Quarto checks that generated edition metadata agrees with `publishing/editions.json`. For a full render, it also checks that chapter scripts match the instructions and that book labels and listing metadata are consistent. A failed check stops the render. Metadata generation remains an explicit step when the manifest changes.
- After rendering, Quarto generates the LLM files from the fresh HTML, assembles `_site/`, and checks the editions' links, assets, notices, search indexes and canonical URLs.
- Partial chapter renders and preview renders skip the post-render publishing steps. Run a complete render before preparing a GitHub update.

## Guide 1: Start a new annual edition

### 1. Finish and preserve the outgoing edition

Follow Guide 2 below to finish the outgoing edition, including its rendered `_book/` and LLM files. Commit and push that final version to GitHub before changing the edition year.

Record its full commit hash:

```sh
git rev-parse HEAD
```

If next year's work has already begun, identify the earlier final outgoing-edition commit instead. The chosen commit must contain the final rendered `_book/` and be available in the configured GitHub repository.

### 2. Update the edition manifest

Edit `publishing/editions.json`: give the outgoing edition the recorded `commit`, add an empty entry for the new year, and change `current`. For example, moving from 2026 to 2027 changes these entries:

```json
"current": "2027",
"editions": {
  "2027": {},
  "2026": {"commit": "FULL_HASH_OF_THE_FINAL_2026_COMMIT"}
}
```

Replace the placeholder with the full 40-character hash. Retain the existing 2025 and 2024 entries, including their repairs and unavailable-download settings.

Run:

```sh
Rscript publishing/prepare_site.R --metadata
```

This updates the edition subtitle and publication URL in `_quarto.yml`, the home-page callout in `include/_book-editions.qmd`, and the former Coding with style chapter's destination page, `code_with_style.html`.

### 3. Edit and render the new edition

Make the new year's source changes. If chapters or resources are renamed, review the compatibility mappings in `.htaccess` so yearless links reach the appropriate current page.

Run:

```sh
quarto render
```

Wait for rendering, LLM generation, website assembly and edition checks to finish successfully. The current render is in `_book/`; the combined website is in `_site/`.

Because the manifest changed, assembly refreshes all archived editions from their pinned rendered snapshots. It archives the outgoing edition and updates older editions' notices and home-page edition links to include the new current edition. Their historical teaching content is preserved. Historical R code is not executed.

Snapshots are downloaded once into `publishing/cache/`; later builds reuse and verify those downloads. You do not need to download archives manually.

### 4. Review the current and archived editions

Review the new edition's home page and changed chapters in a browser, including figures, quizzes, downloads, search and links at desktop and narrow widths. Review each archived home page and a sample archived chapter, checking the notice and links to the new current edition.

Run the publishing regression tests:

```sh
Rscript publishing/test_prepare_site.R
```

Resolve failures and repeat the full render after source changes. See the checking notes below for optional content and Apache checks.

### 5. Commit and prepare the GitHub update

Use the Positron Git panel to review, stage and commit the changed source files, manifest, generated edition metadata, relevant `_freeze/` updates and rendered `_book/` (including LLM files and file removals). Do not stage unrelated changes or force-add `_site/` or `publishing/cache/`: these are ignored generated files. The rendered `_book/` belongs in Git because its final snapshot will be archived in a later year.

After committing, run:

```sh
Rscript publishing/prepare_site.R
Rscript publishing/check_site.R
```

This records the new commit in `_site/edition-provenance.json` without rendering again. Then push using the Positron Git panel. Pushing does not publish the website.

When publishing the website, upload and verify the new year directory before activating the root `.htaccess`. Also upload the refreshed older edition directories so their notices and edition navigation point to the new edition. Upload the contents of `_site/`, including its hidden root `.htaccess`; do not upload `_book/` to the website root. Back up the live website first and preserve every archived year.

## Guide 2: Update the current annual edition

### 1. Finish the source changes

Save your changes to chapters, scripts, images and resources. Leave `current` and archive entries in `publishing/editions.json` unchanged for an ordinary update within the same annual edition. Do not change the selected edition simply because the calendar year changed.

If chapters or resources are renamed, update the relevant compatibility mappings in `.htaccess`.

### 2. Render and prepare the update

Run:

```sh
quarto render
```

This renders `_book/`, regenerates its `llms.txt` and page-specific `.llms.md` files, assembles `_site/`, and runs edition checks. You do not need to run the LLM generator or assembler separately.

With unchanged archive settings and publishing code, assembly copies the already prepared archived directories without rewriting their pages. Only the current edition and shared root files need publishing. If `_site/` is missing, archives are reconstructed automatically from cached snapshots (or downloaded if the cache is also missing). Changed archive preparation code or CSS also triggers reconstruction.

If the pre-render check reports stale metadata, run `Rscript publishing/prepare_site.R --metadata`, then render again. Review why the metadata changed before treating the update as a routine within-year update.

The book uses `freeze: auto`, so rendering can reuse computations from unchanged chapters. To refresh external data or results affected by changed R packages, temporarily set `execute.freeze` to `false`, run `quarto render --cache-refresh`, then restore `freeze: auto`. The post-render hook prepares the LLM files and website from the refreshed HTML.

### 3. Check the current edition

Review `_book/index.html` and changed chapters in a browser. Check figures, quizzes, downloads, search and links at desktop and narrow widths. Resolve render or publishing-check failures before continuing; repeat the complete render after changing source content.

Review missing-text-alternative messages from the LLM generator. For stricter validation, run:

```sh
Rscript generate_llms.R --skip-render --strict
```

If publishing scripts changed, also run `Rscript publishing/test_prepare_site.R`. See the checking notes below for optional checks.

### 4. Commit and prepare the GitHub update

Use the Positron Git panel to review, stage and commit the source changes, relevant `_freeze/` updates and rendered `_book/`, including its LLM files and generated removals. The rendered `_book/` belongs in Git so its final snapshot can become a future archive. Keep ignored `_site/` and `publishing/cache/` out of the commit and avoid staging unrelated work.

After committing, run:

```sh
Rscript publishing/prepare_site.R
Rscript publishing/check_site.R
```

This refreshes the deployment provenance with the new commit without rendering again. Push using the Positron Git panel.

Pushing does not publish the website. When ready, back up the live website and upload the current year directory and shared root files from `_site/`, including the hidden root `.htaccess`. Existing archived year directories do not need uploading for an ordinary current-edition content update. Do not upload `_book/` directly to the website root.

## Checking and recovery notes

Chapter-script and label checks run automatically before every complete book render. To run them independently while editing:

```sh
Rscript checks/check_chapter_scripts.R
Rscript checks/check_book_labels.R
```

The image-alternative checker is also written in R and can be run separately. After a fresh render, use:

```sh
Rscript checks/check_image_alternatives.R --rendered _book
```

For the source-checker regression tests, run `Rscript checks/test_checks.R`. See `checks/README.md` for the scope and limitations of these checks.

Quarto preview cannot test Apache redirects. If an Apache test server serves `_site/` at the book path, run the HTTP checks using its URL:

```sh
Rscript publishing/check_site.R --base-url http://127.0.0.1:8765/learncrimemapping/
```

Edition-switch links use published URLs, so a new edition will become reachable through them after uploading. Use year-specific URLs when assigning a particular edition; yearless URLs follow `current`.

To deliberately reconstruct all archives, for example after an accidental edit to generated archived files, run:

```sh
Rscript publishing/prepare_site.R --refresh-archives
Rscript publishing/check_site.R
```

To assemble from an alternative render directory, use `--current-book DIR`. The post-render hook automatically honours Quarto's output directory.

## Required R packages

The publishing scripts require `jsonlite`, `fs`, `httr2`, `digest` and `xml2`; the LLM generator also requires `yaml`; regression tests require `testthat`. Install missing packages once in the R Console:

```r
install.packages(c("jsonlite", "fs", "httr2", "digest", "xml2", "yaml", "testthat"))
```

Rendering also requires the R packages used in the book's executable chunks. Publishing scripts do not install packages automatically.
