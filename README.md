# Learn Crime Mapping with R

This repo contains the text of the online book [Learn Crime Mapping with R](http://books.lesscrime.info/learncrimemapping/).

## Chapter scripts

Full book renders automatically check that scripts match the instructions students follow and that labels are consistent. To check chapter scripts separately while editing:

```sh
Rscript checks/check_chapter_scripts.R
```

The check compares code and comments, including scripts copied from earlier chapters and partial-script checkpoints. It does not execute R or contact data services. See [checks/README.md](checks/README.md) for how to maintain the mapping when adding or replacing code chunks.

## Shared chapter text

Repeated chapter instructions live in underscore-prefixed `.qmd` files in `include/`:

- `_before-you-start.qmd`: the startup callout in Chapters 2–16.
- `_revision-instructions.qmd`: the introductory instructions for written revision questions.
- `_check-reproducibility.qmd`: the reminder to restart R and run a complete script.

Edit these files to update the instructions everywhere they appear. Include them with a project-root path, for example:

```markdown
{{< include /include/_before-you-start.qmd >}}
```

Leave a blank line before and after an include shortcode. Keep chapter-specific filenames, questions and prerequisites in the chapter itself. Shared files should have no YAML metadata or chapter-specific identifiers; use project-root paths for any links or images because relative paths resolve from the chapter that includes the file.

## Publishing annual editions

See [publishing/README.md](publishing/README.md) for building the combined website, preserving historical editions and activating yearless redirects. Commit the assembled `_site/` directory alongside `_book/`; GitHub Actions uploads its contents to the book website root when pushed to `main`. See the publishing guide for the required FTP password secret.
