# Run from the repository root: Rscript checks/test_checks.R
# Mutations use disposable copies; the book itself is never edited.
if (!requireNamespace("testthat", quietly = TRUE)) stop('Install testthat with install.packages("testthat").', call. = FALSE)
checks <- new.env(parent = globalenv())
for (script in c("check_book_labels.R", "check_chapter_scripts.R", "check_image_alternatives.R")) sys.source(file.path("checks", script), envir = checks)
manifest <- jsonlite::fromJSON("checks/chapter-scripts.json", simplifyVector = FALSE)

book_copy <- function() {
  root <- tempfile("book-check-")
  dir.create(root)
  for (path in c(names(manifest$scripts), Sys.glob("[0-9][0-9]_*/index.qmd"))) {
    dir.create(dirname(file.path(root, path)), recursive = TRUE, showWarnings = FALSE)
    file.copy(path, file.path(root, path))
  }
  root
}
change <- function(root, path, before, after) {
  text <- checks$check_read(file.path(root, path))
  stopifnot(grepl(before, text, fixed = TRUE))
  position <- regexpr(before, text, fixed = TRUE)[1L]
  writeLines(paste0(substr(text, 1L, position - 1L), after, substring(text, position + nchar(before))), file.path(root, path))
}
check_copy <- function(root, specification = manifest) checks$chapter_book(root, specification)$check()
contains <- function(errors, text) any(grepl(text, errors, fixed = TRUE))

testthat::test_that("current instructions and deliberately broken examples match", {
  root <- book_copy(); on.exit(unlink(root, recursive = TRUE))
  testthat::expect_identical(check_copy(root), character())
  for (name in c("chapter_08_error.R", "chapter_08_minimal.R", "chapter_08_minimal_reprex.R")) testthat::expect_true(grepl(" +\n", checks$check_read(file.path(root, "R", name)), fixed = TRUE))
})
testthat::test_that("code and comment drift are detected independently", {
  root <- book_copy(); on.exit(unlink(root, recursive = TRUE))
  change(root, "R/chapter_02a.R", "size = 4", "size = 5")
  change(root, "R/chapter_13a.R", "# Calculate bounding box", "# Bounding box")
  errors <- check_copy(root)
  testthat::expect_true(contains(errors, "R/chapter_02a.R: code differs"))
  testthat::expect_true(contains(errors, "R/chapter_13a.R: comments differs"))
  testthat::expect_false(contains(errors, "R/chapter_13a.R: code differs"))
})
testthat::test_that("chapter changes propagate through inheritance and checkpoints", {
  root <- book_copy(); on.exit(unlink(root, recursive = TRUE))
  path <- file.path(root, "03_data_wrangling/index.qmd")
  text <- checks$check_read(path)
  position <- regexpr("#| label: script-03a-packages", text, fixed = TRUE)[1L]
  writeLines(paste0(substr(text, 1L, position - 1L), sub("# Load packages", "# Load the packages", substring(text, position), fixed = TRUE)), path)
  errors <- check_copy(root)
  for (script in c("03a", "04a")) testthat::expect_true(contains(errors, paste0("R/chapter_", script, ".R: comments differs")))
  path <- file.path(root, "02_your_first_crime_map/index.qmd")
  text <- checks$check_read(path); position <- regexpr("#| label: script-02a-checkpoint", text, fixed = TRUE)[1L]
  writeLines(paste0(substr(text, 1L, position - 1L), sub('"EPSG:26967"', '"EPSG:4326"', substring(text, position), fixed = TRUE)), path)
  testthat::expect_true(contains(check_copy(root), "script-02a-checkpoint): code differs"))
})
testthat::test_that("intermediate examples and presentation markers do not change final scripts", {
  root <- book_copy(); on.exit(unlink(root, recursive = TRUE))
  change(root, "05_your_second_crime_map/index.qmd", "janitor::clean_names() # <3>", 'janitor::clean_names(case = "lower_camel") # <3>')
  change(root, "13_mapping_hotspots/index.qmd", "invisible() #<1>", "invisible() # <9>")
  change(root, "R/chapter_13c.R", "# LOAD DATA", "\n\n# LOAD DATA")
  testthat::expect_identical(check_copy(root), character())
})
testthat::test_that("coverage checks reject new unmapped scripts and saved chunks", {
  root <- book_copy(); on.exit(unlink(root, recursive = TRUE))
  writeLines("sqrt(4)", file.path(root, "R/chapter_99.R"))
  cat('\n```{r}\n#| filename: "chapter_02a.R"\nsqrt(4)\n```\n', file = file.path(root, "02_your_first_crime_map/index.qmd"), append = TRUE)
  errors <- check_copy(root)
  testthat::expect_true(contains(errors, "Unmapped script: R/chapter_99.R"))
  testthat::expect_true(contains(errors, "Unmapped saved-code chunk"))
})
testthat::test_that("scripts cannot validate themselves or cyclic inheritance", {
  root <- book_copy(); on.exit(unlink(root, recursive = TRUE))
  m <- manifest
  m$scripts[["R/chapter_07.R"]]$parts <- list(list(chapter = "07_map_context/index.qmd", chunk = "complete-script"))
  testthat::expect_error(check_copy(root, m), "instead of independent chapter code")
  m$scripts[["R/chapter_07.R"]]$parts <- list(list(script = "R/chapter_07.R"))
  testthat::expect_error(check_copy(root, m), "Cyclic script inheritance")
})
testthat::test_that("hashes and escapes inside strings remain executable code", {
  result <- checks$code_and_comments('colour = "#CC0000" # Set colour\n')
  testthat::expect_identical(result$code, 'colour = "#CC0000"')
  testthat::expect_identical(result$comments, list(list(line = 1L, text = "# Set colour")))
  root <- book_copy(); on.exit(unlink(root, recursive = TRUE))
  change(root, "R/chapter_10.R", '"#CC0000"', '"#000000"')
  testthat::expect_true(contains(check_copy(root), "R/chapter_10.R: code differs"))
  testthat::expect_identical(checks$chunk_code(c("# Keep comment ending in t", "# <1>", "x <- 1 #<<")), "# Keep comment ending in t\nx <- 1\n")
})
label_errors <- function(text, path = "02_your_first_crime_map/index.qmd") checks$check_sources(setNames(list(text), path))$errors

testthat::test_that("labels and visible listing metadata are required", {
  testthat::expect_true(contains(label_errors('```{r}\n#| echo: false\nplot(1:3)\n```'), "execution label"))
  testthat::expect_true(contains(label_errors('```{r}\n#| label: hidden-map\n#| echo: false\n#| lst-label: lst-hidden-map\n#| lst-cap: ""\nplot(1:3)\n```'), "hidden code"))
  for (expected in c("lst-label", "blank lst-cap", "fig-cap", "alternative text")) testthat::expect_true(contains(label_errors('```{r}\n#| label: fig-assaults\nplot(1:3)\n```'), expected))
  testthat::expect_true(contains(label_errors('### Loading data\n'), "level-3 heading"))
  testthat::expect_true(contains(label_errors('```{r}\n#| label: same\n#| include: false\n```\n```{r}\n#| label: same\n#| include: false\n```'), "duplicate execution label"))
})
testthat::test_that("document defaults, comments and literal examples preserve conventions", {
  examples <- c('---\nexecute:\n  include: false\n  echo: false\n---\n```{r}\n#| label: setup\nx <- 1\n```',
    '````markdown\n### Example heading\n```{r}\nx <- 1\n```\n````\n```{r}\n#| label: setup\n#| include: false\n### An R comment\n```',
    '<!--\n```{r}\n#| label: old-example\nx <- 1\n```\n-->')
  for (text in examples) testthat::expect_identical(label_errors(text), character())
  testthat::expect_identical(label_errors('```{r}\n#| label: fig-example\n#| fig-cap: "Existing caption"\nplot(1:3)\n```', "resources/reports/example.qmd"), character())
  testthat::expect_identical(label_errors('```{mermaid}\n%%| label: workflow\nflowchart TD\nA --> B\n```'), character())
  testthat::expect_true(contains(label_errors('```{mermaid}\nflowchart TD\nA --> B\n```'), "execution label"))
  result <- checks$check_sources(list("01_getting_started/index.qmd" = "### First {#sec-loading}", "02_your_first_crime_map/index.qmd" = "### Second {#sec-loading}"))
  testthat::expect_true(contains(result$errors, "Duplicate book"))
})
image_errors <- function(text, expected = character()) checks$check_image_source("chapter.qmd", text, expected)$errors

testthat::test_that("raw HTML and SVG images require alternatives or explicit decoration", {
  for (text in c('<img src="map.png">', '<img src="map.png" alt="">', '<svg role="img"></svg>', '<svg role="graphics-document document"></svg>')) testthat::expect_true(length(image_errors(text)) > 0L)
  for (text in c('<img src="art.png" alt="" role="presentation">', '<a aria-label="Visit the sf website"><img src="sf.png" alt=""></a>', '<svg role="img" aria-label="Analysis steps"></svg>')) testthat::expect_identical(image_errors(text), character())
})
testthat::test_that("Markdown alternatives override captions and named links permit decorative logos", {
  testthat::expect_true(length(image_errors('![Caption](map.png){fig-alt=""}')) > 0L)
  testthat::expect_identical(image_errors('![Caption](map.png){fig-alt="Dark northern cells."}'), character())
  testthat::expect_identical(image_errors('[![](logo.png){alt=""}](https://example.com){aria-label="Visit the package website"}\n'), character())
  result <- checks$check_image_source("chapter.qmd", '<!-- <img src="old.png"> -->\n````markdown\n![](example.png)\n```{r}\n#| label: fig-example\nplot(1)\n```\n````\n')
  testthat::expect_identical(result$errors, character())
  testthat::expect_length(result$counts, 0L)
})
testthat::test_that("generated visuals and inventories detect absent alternatives", {
  text <- '```{r}\n#| label: draw-map\n#| fig-alt: "Northern cells have higher density."\nmap\n```'
  testthat::expect_identical(image_errors(text, "draw-map"), character())
  testthat::expect_true(length(image_errors(sub('#\\| fig-alt:.*\n', '', text), "draw-map")) > 0L)
  testthat::expect_true(length(image_errors("", "draw-map")) > 0L)
  testthat::expect_true(length(image_errors('```{r}\n#| label: fig-new\nplot(1)\n```')) > 0L)
  text <- '```{r}\n#| label: fig-panels\n#| fig-alt: ["Grey background.", "White background."]\nplot(1)\nplot(2)\n```'
  testthat::expect_identical(image_errors(text), character())
  testthat::expect_true(length(image_errors(sub('"White background."', '""', text, fixed = TRUE))) > 0L)
})
testthat::test_that("workflow and Mermaid diagrams need native descriptions", {
  testthat::expect_true(length(image_errors('::::: {.process}\nDownload\n:::::')) > 0L)
  testthat::expect_identical(image_errors('::::: {.process role="img" aria-label="Download and load data."}\nDownload\n:::::'), character())
  text <- '```{mermaid}\n%%| label: workflow\n%%| fig-alt: "Load and map data."\nflowchart TD\nA --> B\n```'
  testthat::expect_true(length(image_errors(text)) > 0L)
  testthat::expect_identical(image_errors(sub('flowchart TD\n', 'flowchart TD\naccTitle: Workflow\naccDescr: Load and map data.\n', text, fixed = TRUE)), character())
})
