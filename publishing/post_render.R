# Quarto calls this hook after rendering; partial renders leave the publishing site alone.
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

post_render_main <- function() {
  if (Sys.getenv("QUARTO_PROJECT_RENDER_ALL") != "1") {
    message("Skipping publication preparation for a partial or preview render.")
    return(invisible(NULL))
  }
  output <- Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR", unset = "_book")
  if (!nzchar(output)) output <- "_book"
  output <- post_render_output(output)
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
