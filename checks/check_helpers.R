# Shared source-reading helpers. No student code is executed.
check_read <- function(path) paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
check_fail <- function(...) stop(..., call. = FALSE)
check_matches <- function(pattern, text) {
  hits <- gregexpr(pattern, text, perl = TRUE)
  regmatches(text, hits)[[1L]]
}
check_options <- function(lines, marker = "#") {
  result <- list()
  pattern <- paste0("^\\s*", marker, "\\|\\s*([\\w-]+):[ \\t]*(.*)$")
  for (line in lines) {
    match <- regmatches(line, regexec(pattern, line, perl = TRUE))[[1L]]
    if (length(match)) result[[match[2L]]] <- gsub("^[\"' ]+|[\"' ]+$", "", trimws(match[3L]))
  }
  result
}
check_default <- function(value, fallback = "") if (is.null(value)) fallback else value

# Respect longer fences enclosing literal teaching examples; retain line diagnostics.
source_blocks <- function(text) {
  lines <- strsplit(text, "\n", fixed = TRUE)[[1L]]
  blocks <- list()
  prose <- lines
  index <- 1L
  in_comment <- FALSE
  while (index <= length(lines)) {
    line <- lines[index]
    opening <- regmatches(line, regexec("^\\s*(`{3,}|~{3,})(.*)$", line, perl = TRUE))[[1L]]
    if (length(opening)) {
      fence <- opening[2L]
      info <- trimws(opening[3L])
      end <- index + 1L
      closing <- paste0("^\\s*", substr(fence, 1L, 1L), "{", nchar(fence), ",}\\s*$")
      while (end <= length(lines) && !grepl(closing, lines[end], perl = TRUE)) end <- end + 1L
      body <- if (end > index + 1L) lines[seq.int(index + 1L, min(end - 1L, length(lines)))] else character()
      prose[seq.int(index, min(end, length(lines)))] <- ""
      kind <- if (grepl("^\\{r(?:\\s|\\})", info, perl = TRUE)) "chunk" else if (info == "{mermaid}") "diagram" else ""
      if (nzchar(kind)) {
        options <- check_options(body, if (kind == "chunk") "#" else "%%")
        legacy <- regmatches(info, regexec("^\\{r\\s+([^,}\\s]+)", info, perl = TRUE))[[1L]]
        if (length(legacy) && is.null(options$label)) options$label <- legacy[2L]
        if (in_comment) options[["_commented"]] <- "true"
        blocks[[length(blocks) + 1L]] <- list(kind = kind, line = index, value = options, body = body)
      }
      index <- end + 1L
      next
    }
    if (grepl("<!--", line, fixed = TRUE)) in_comment <- TRUE
    if (grepl("-->", line, fixed = TRUE)) in_comment <- FALSE
    if (grepl("^###\\s+\\S", line, perl = TRUE)) {
      match <- regmatches(line, regexec("\\{[^}]*#([\\w-]+)[^}]*\\}", line, perl = TRUE))[[1L]]
      blocks[[length(blocks) + 1L]] <- list(kind = "heading", line = index,
        value = if (length(match)) match[2L] else NULL)
    }
    index <- index + 1L
  }
  attr(blocks, "prose") <- paste(prose, collapse = "\n")
  blocks
}

check_root <- function(args = commandArgs(trailingOnly = TRUE), script_name) {
  command <- commandArgs(FALSE)
  script <- sub("^--file=", "", command[startsWith(command, "--file=")])
  # Rscript encodes spaces in its --file argument on some platforms.
  script <- gsub("~+~", " ", script, fixed = TRUE)
  root <- if (length(script)) dirname(dirname(normalizePath(script[1L], mustWork = TRUE))) else getwd()
  if (length(args)) {
    if (length(args) == 2L && args[1L] == "--root") root <- args[2L]
    else if (length(args) == 1L && startsWith(args[1L], "--root=")) root <- substring(args[1L], 8L)
    else check_fail("Usage: Rscript ", script_name, " [--root DIR]")
  }
  normalizePath(root, winslash = "/", mustWork = TRUE)
}
