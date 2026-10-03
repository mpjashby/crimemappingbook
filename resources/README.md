# Student resources

The student-facing index is `appendices/resources.qmd`. Keep it up to date when
adding or removing a download.

- `reports/`: complete example reports, with source and finished output together.
- `examples/`: short examples demonstrating a particular feature.
- `templates/`: starting points students can adapt for their own work.

Use descriptive lowercase filenames with underscores and no chapter numbers.
Use the same basename for a report's source and finished output. R scripts use
the `.R` extension. Data belongs in the workspace's `data/raw/` directory, not
alongside published reports. Do not publish caches or temporary build files.

## Rendering

`_quarto.yml` makes this directory a separate, ordinary Quarto project so these
files render as standalone documents rather than book chapters. From the
repository root, render individual reports, for example:

```sh
quarto render resources/reports/medellin_homicides_map.qmd --execute-dir .
quarto render resources/reports/medellin_homicides_table.qmd --execute-dir . --cache-refresh
quarto render resources/examples/quarto_show_code.qmd --execute-dir .
quarto render resources/examples/quarto_hide_code.qmd --execute-dir .
```

Keep finished HTML/PDF outputs with their sources, so publishing the book does
not require rendering all the standalone examples. HTML reports should embed
their supporting resources. Re-render outputs whenever their sources change.
The `--execute-dir .` option runs the R code from the repository root so
`here()` uses the repository workspace for data paths. Use the same option when
rendering the additional reports from the repository root. The templates contain
placeholders and are not complete reports to render.

The Edmonton example requires a manually downloaded dataset of about 300 MB at
`data/raw/Fire_Response__Current_and_Historical_20250309.csv`, as explained in
its source. The Yarra example requires access to its external data services and
a PDF rendering installation. Its boundary-data URL could not be loaded during
the 2026 update, so its original finished PDF is retained; reproducing the source
may require a replacement boundary dataset. Both are additional examples rather than prerequisites
for working through the book.

Git ignores the other local files in the top level of this directory, including
the assessment-specific template and old render caches. They are not published.
The book's resource declarations explicitly include only reports, examples and
general-purpose templates. Review new resources before placing them there.

The `.htaccess` rules preserve previous public resource URLs after renaming.
