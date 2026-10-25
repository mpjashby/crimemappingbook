# Quarto calls this hook after rendering; partial renders leave the publishing site alone.
source("publishing/book_navigation.R", local = TRUE)
# Quarto can supply an absolute output directory; the LLM CLI uses relative paths.
post_render_output <- function(output, root = getwd()) {
  root <- normalizePath(root, winslash = "/", mustWork = TRUE)
  path <- if (grepl("^(/|[A-Za-z]:)", output)) output else file.path(root, output)
  path <- normalizePath(path, winslash = "/", mustWork = TRUE)
  if (!startsWith(path, paste0(root, "/"))) {
    stop("Publishing output must be inside the book project.", call. = FALSE)
  }
  substring(path, nchar(root) + 2L)
}

# Render the separate Quarto project and publish only its student-facing output.
publish_exercises <- function(output) {
  if (!requireNamespace("fs", quietly = TRUE)) stop("Install the fs package before publishing.", call. = FALSE)
  quarto <- Sys.which("quarto")
  if (!nzchar(quarto)) stop("Quarto is required to render the exercises.", call. = FALSE)
  # These local working directories are deliberately absent from a Git checkout.
  dir.create(file.path("exercises", "data", "raw"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path("exercises", "output"), showWarnings = FALSE)
  status <- system2(quarto, c("render", "exercises"))
  if (status != 0L) stop("Exercise render failed; publication preparation stopped.", call. = FALSE)
  source <- file.path("exercises", "_site")
  if (!file.exists(file.path(source, "index.html"))) {
    stop("Exercise render produced no home page.", call. = FALSE)
  }
  destination <- file.path(output, "exercises")
  if (dir.exists(destination)) unlink(destination, recursive = TRUE)
  fs::dir_copy(source, destination)
}

post_render_main <- function() {
  output <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR", unset = "_book")
  if (!nzchar(output)) output <- "_book"
  output <- post_render_output(output)
  update_book_navigation(output)
  if (Sys.getenv("QUARTO_PROJECT_RENDER_ALL") != "1") {
    message("Skipping publication preparation for a partial or preview render.")
    return(invisible(NULL))
  }
  publish_exercises(output)
  # Run the generator in another R process to isolate its globals and CLI arguments.
  status <- system2(file.path(R.home("bin"), "Rscript"),
    c("generate_llms.R", "--skip-render", shQuote(paste0("--output-dir=", output))))
  if (status != 0L) stop("LLM generation failed; publication preparation stopped.", call. = FALSE)
  source("publishing/check_site.R", local = TRUE)
  config <- load_manifest()
  assemble_site(config, output, "_site", "publishing/cache")
  problems <- check_site_files("_site", config)
  if (length(problems)) publishing_fail(paste(problems, collapse = "\n"))
  message("Publication preparation and edition checks passed.")
}

if (sys.nframe() == 0L) post_render_main()
