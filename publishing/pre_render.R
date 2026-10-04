# Validate edition metadata for every render and chapter sources for full renders.
pre_render_main <- function() {
  source("publishing/prepare_site.R", local = TRUE)
  prepare_metadata(load_manifest(), check = TRUE)
  if (Sys.getenv("QUARTO_PROJECT_RENDER_ALL") != "1") {
    message("Skipping book-wide source checks for a partial or preview render.")
    return(invisible(NULL))
  }
  # Separate processes keep checker globals and CLI arguments isolated.
  for (script in c("checks/check_chapter_scripts.R", "checks/check_book_labels.R", "checks/check_code_library.R")) {
    status <- system2(file.path(R.home("bin"), "Rscript"), shQuote(script))
    if (status != 0L) stop("Source check failed: ", script, call. = FALSE)
  }
  message("Book-wide source checks passed.")
}
if (sys.nframe() == 0L) pre_render_main()
