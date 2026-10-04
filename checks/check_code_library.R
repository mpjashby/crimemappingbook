# Check the library covers completed scripts and publishes their exact sources.
check_code_library_main <- function() {
  manifest <- jsonlite::fromJSON("checks/chapter-scripts.json", simplifyVector = FALSE)
  # These teaching examples intentionally retain errors; they are not templates.
  excluded <- paste0("R/", c("chapter_08_error.R", "chapter_08_minimal.R", "chapter_08_minimal_reprex.R"))
  expected <- c(setdiff(names(manifest$scripts), excluded),
                "resources/reports/medellin_homicides_map.qmd")
  library <- readLines("appendices/chapter_code.qmd", warn = FALSE)
  rows <- library[startsWith(library, "| @sec-")]
  links <- regmatches(rows, regexpr("(?<=\\]\\()\\.\\./[^)]+", rows, perl = TRUE))
  actual <- sub("^\\.\\./", "", links)
  if (!setequal(actual, expected) || anyDuplicated(actual)) {
    stop("Code library must link each completed chapter file exactly once, excluding deliberate errors.", call. = FALSE)
  }
  if (!all(file.exists(actual))) stop("Missing code-library source file.", call. = FALSE)
  if (!all(grepl("\\(@sec-[^)]+\\)", rows))) stop("Each code-library description needs section references in parentheses.", call. = FALSE)
  config <- yaml::read_yaml("_quarto.yml")
  if (!all(expected %in% unlist(lapply(config$format$html$resources, Sys.glob)))) {
    stop("Code-library sources must be declared as published resources.", call. = FALSE)
  }
  message("Code library covers all ", length(expected), " completed chapter files; deliberate errors are excluded.")
}
if (sys.nframe() == 0L) check_code_library_main()
