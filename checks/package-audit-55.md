# Package requirements for the 2026 edition

Audit date: 3 October 2026. Related issue: [#55](https://github.com/mpjashby/crimemappingbook/issues/55).

## Scope and method

Reviewed the current local working copy, including uncommitted chapter updates: all 16 chapters, setup, appendices, included material, chapter scripts in `R/`, and downloadable reports, examples and templates in `resources/`. Checked package-loading calls, namespace calls, inline R, unqualified functions and selected upstream optional dependencies. Also inspected the metapackage's utility function, because the student template calls `learncrimemapping::check_code()`.

Compared against the live [metapackage DESCRIPTION](https://github.com/mpjashby/learncrimemapping/blob/main/DESCRIPTION), blob `206df0d2a65d1239f0c4f84bc768b883d9c3a25f`, linked from issue #55. Dependency closure was checked against locally installed package metadata; upstream DESCRIPTION/source was checked for the important exceptions. This is a source audit, not a clean-install or complete execution test. Generated `_book/` and `_freeze/` outputs are not the source of truth. Lectures, specimen answers and walk-throughs were scanned separately and do not define the book's minimum student requirements.

## Recommended complete student installation manifest

Use the following as the explicit `Imports` list. R will also install their hard dependencies automatically; this is not an exhaustive list of every transitive package. Several entries deliberately state direct requirements already supplied by another package, so the manifest remains understandable and robust to upstream dependency changes.

```dcf
Imports:
    cli,
    colorblindr,
    conflicted,
    crsuggest,
    cyclocomp,
    dplyr,
    gganimate,
    ggauto,
    ggplot2,
    ggrepel,
    ggridges,
    ggspatial,
    ggthemes,
    gifski (>= 1.4.3),
    gt,
    here,
    htmltools,
    httr2,
    janitor,
    knitr,
    leaflet,
    lintr (>= 3.1.1),
    lubridate,
    osmdata,
    pacman,
    paletteer,
    patchwork,
    prettymapr,
    raster,
    RColorBrewer,
    readxl,
    remotes,
    reprex,
    rlang,
    rmarkdown,
    rnaturalearth (>= 1.2.0),
    scales,
    sf,
    sfhotspot,
    slider,
    stringr,
    tibble,
    tidygeocoder,
    tidyverse (>= 2.0.0),
    tinytex,
    usethis (>= 3.2.0),
    utils
Remotes:
    clauswilke/colorblindr
```

Keep this installation manifest separate conceptually from namespace imports: it does not require attaching all these packages or adding `import()` directives for every entry. Do not put mandatory student packages only in `Suggests`, because the existing default installation does not guarantee them.

### Changes and evidence

| Change relative to existing explicit Imports | Evidence / reason |
| --- | --- |
| Add `httr2` | Downloads throughout chapters and scripts, beginning in chapter 2. It is already reached indirectly in this machine's dependency closure, but should be an explicit requirement. |
| Add `ggauto` | Student Console examples in chapter 14 (`859`, `886`, `1349`, `1552`) and chapter 15 (`749`). Available on CRAN. |
| Add `paletteer` | Chapter 14 package-loading calls and final bar-chart script; also the Yarra example report. |
| Add `colorblindr` and its GitHub remote | Chapter 14 colour-vision checks at `1122` and `1198`. Currently students are told to install it part-way through the book. |
| Add `gifski` | Chapter 15 `animate()` / `anim_save()` produce animated GIFs. `gifski` is a suggested dependency of gganimate, not a guaranteed installation dependency. |
| Add `cyclocomp` | `check_code()` calls `lintr::cyclocomp_linter()`, which requires this suggested dependency. |
| Add `usethis (>= 3.2.0)` | Chapter 1 uses `use_air()`, introduced in 3.2.0. |
| Add `conflicted`, `ggplot2`, `lubridate`, `readxl`, `stringr` | Direct requirements currently supplied by tidyverse; conflicted is explicitly loaded in chapter 8, and stringr is also used directly by the metapackage's checker. |
| Add `rmarkdown`, `tinytex`, `remotes` | Report/reprex support, chapter 11 PDF setup and the setup installer respectively. Already installed indirectly with the current dependency graph. |
| Keep `cli`, `dplyr`, `knitr`, `lintr`, `reprex`, `rlang`, `utils` | The metapackage's utility function uses these; lack of chapter-level loading is not a reason to remove them. |
| Keep `prettymapr`, `raster` | ggspatial's tile-drawing code calls `prettymapr::makebbox()`; tile reprojection calls raster functions when the map CRS is not EPSG:3857. These optional upstream requirements matter for the book's local projected maps. |
| Remove explicit `ggimage` | Used by `make_cover_image.R`, not student examples. Retain in the author environment. |
| Remove explicit `terra`, `transformr` | No direct student calls found. They remain installed as hard dependencies of rnaturalearth/raster and gganimate respectively. Keeping their explicit entries would also be harmless. |

The proposed list otherwise retains the existing student-facing requirements. `MASS` is used in chapter 8's conflict demonstration and comes with a standard R installation as a recommended package. Base packages such as `stats`, `grid` and `grDevices` do not need separate installation entries.

### Requirements for executing the book's own source

For a single metapackage intended to support **both students and every currently evaluated book chunk**, also add these four packages to the above `Imports`:

```dcf
    crimemappingdata,
    ggforce,
    kableExtra,
    webexercises
```

Add `mpjashby/crimemappingdata` to `Remotes` as well. Its repository supplies the datasets used in hidden setup chunks in chapters 3, 4 and 16. `ggforce::geom_circle()` is called unqualified in chapter 6's illustration; merely installing it does not make that unqualified function available, so that chunk also needs an explicit namespace call or a load. `kableExtra` formats author-produced tables in chapter 10. `webexercises` builds the book's quizzes. These are not needed by the saved student analyses, so my preference is a separate author manifest, but the combined list is the safer choice if one installation must run the book source too.

Other author tooling includes `ggimage`, `hexSticker`, `showtext` for cover generation; `ragg` for the favicon; and `yaml`/`xml2` for `generate_llms.R`. The latter three are already supplied transitively by the proposed student manifest in the inspected environment.

### Things a text search might wrongly include

- `PrettyCols::Bright`, `MetBrewer::OKeeffe2` and `ggthemes::Green` inside palette strings are palette identifiers, not R namespace calls. paletteer stores its discrete palettes internally; PrettyCols and MetBrewer need not be installed for those strings to work. ggthemes is independently required for `theme_wsj()` in chapter 7.
- `crimedata` appears in a hidden, `eval: false` illustration in chapter 15. Include it only if restoring that illustration to the author build.
- `ggmap` is used in an old hidden, `eval: false` chapter-14 illustration. Installing it would not fix obsolete Stamen requests or the old input path. Prefer retiring or updating that chunk rather than expanding every student's installation.
- `readODS` is recommended in the data-reading appendix, but no analysis calls it. Add it if the installation promise covers all optional appendix formats as well as book examples.
- `styler` is recommended in the downloadable script template, while chapter 1 now uses Air. Either replace that template advice with Air, or add styler if retaining the recommendation. Current reprex defaults do not require it.
- `rnaturalearthdata` is not needed for the current scale-110 country calls with rnaturalearth 1.2.0: that dataset is now included in rnaturalearth itself. It would be needed for scale-50 countries or other relevant Natural Earth layers. Neither it nor `rnaturalearthhires` needs to be installed for the current examples when using that version.
- `ggtext` and `tsibble` occur in supplementary course material outside the book. If the same installer must cover those materials, declare them too (`ggtext` is already a hard dependency of ggauto).

## Workflow suggestions

1. **Maintain an edition-specific manifest and installer tag.** Tag a tested 2026 release of learncrimemapping and use that tag in the book's setup command. Pin the colorblindr remote to a tested commit for releases. A tag fixes the metapackage manifest, but not changing CRAN dependencies; keep a maintainer-side renv lockfile for exact reproduction of the tested build.
2. **Automate the source-to-manifest comparison.** Check `p_load()`/`library()` calls, real `::` expressions, inline R and included/downloadable code, with an explicit list for optional renderers and linters. Parse R expressions to avoid counting quoted palette identifiers, prose, quiz distractors or commented code as dependencies. Report differences in CI as chapters change.
3. **Test in a clean library on Windows and macOS.** Install the tagged package, then run representative student analyses, a projected basemap, a tiny GIF, a Quarto HTML report, a reprex and `check_code()`. Use `pacman::p_load(..., install = FALSE)` in validation so it cannot conceal missing dependencies by installing them during the test. Run report compilation without cached/frozen outputs where relevant.
4. **Add a friendly setup check.** Check that namespaces can load and required functions exist; report all problems together, with edition/R/package versions and a copyable repair command. Distinguish package installation from external tools such as Quarto, the Air integration and TeX. Package presence alone does not demonstrate a working setup.
5. **Align later instructions with installation at the beginning.** Remove the chapter-14 instruction to install colorblindr once the metapackage supplies it. Remove chapter 11's redundant tinytex-package installation, while retaining the separate TeX installation. Explain that `p_load()` is a fallback for another computer, rather than a substitute for the tested setup.
6. **Correct the Air explanation.** `usethis::use_air()` configures a workspace; it does not itself install Air. Configuration is per workspace, so the chapter's 'once' wording needs that distinction.

### An existing checker incompatibility to address alongside installation

The current [check_code source](https://github.com/mpjashby/learncrimemapping/blob/main/R/check_code.R) calls `lintr::unnecessary_nested_if_linter()`. That name is not exported by installed lintr 3.4.0. Update to the supported replacement (`unnecessary_nesting_linter()`, after checking its behaviour) and test the checker with the chosen supported lintr version. Adding packages alone will not fix this. Its Quarto guidance also still tells students to use RStudio; update it to Positron.

## Sources for indirect requirements and workflow recommendations

- [gganimate renderers](https://gganimate.com/reference/renderers.html) and [DESCRIPTION](https://github.com/thomasp85/gganimate/blob/main/DESCRIPTION).
- [ggspatial tile implementation](https://github.com/paleolimbot/ggspatial/blob/master/R/annotation-map-tile.R), plus installed ggspatial 1.1.11's `project_extent()` implementation.
- [lintr DESCRIPTION](https://github.com/cran/lintr/blob/master/DESCRIPTION), plus installed lintr 3.4.0's `cyclocomp_linter()` and namespace exports.
- [paletteer's discrete palette implementation](https://github.com/EmilHvitfeldt/paletteer/blob/main/R/paletteer_d.R).
- [usethis changelog](https://usethis.r-lib.org/news/index.html) and [use_air documentation](https://usethis.r-lib.org/reference/use_air.html).
- [tidyverse 2.0.0 DESCRIPTION](https://github.com/cran/tidyverse/blob/master/DESCRIPTION), [ggauto DESCRIPTION](https://github.com/cran/ggauto/blob/master/DESCRIPTION), and [rnaturalearth source](https://github.com/cran/rnaturalearth/blob/master/R/ne_countries.R).
- [remotes installation documentation](https://remotes.r-lib.org/reference/install_github.html), [R package dependency fields](https://r-pkgs.org/description.html), and [renv introduction](https://rstudio.github.io/renv/articles/renv.html).

No book content, metapackage source or GitHub issue was changed by this audit.
