# Compare saved student scripts with independent chapter instructions, without execution.
helper_dir <- if (file.exists("checks/check_helpers.R")) "checks" else dirname(gsub("~+~", " ", sub("^--file=", "", commandArgs(FALSE)[startsWith(commandArgs(FALSE), "--file=")][1L]), fixed = TRUE))
source(file.path(helper_dir, "check_helpers.R"), local = TRUE)

chunk_code <- function(body) {
  lines <- if (length(body) == 1L) strsplit(body, "\n", fixed = TRUE)[[1L]] else body
  annotation <- "[ \\t]*#(?:[ \\t]*<[0-9]+>|<<)[ \\t]*$"
  lines <- lines[!startsWith(lines, "#|") & !grepl(paste0("^", annotation), lines, perl = TRUE)]
  lines <- sub(annotation, "", lines, perl = TRUE)
  paste0(trimws(paste(sub("[ \\t]+$", "", lines, perl = TRUE), collapse = "\n")), "\n")
}
select_section <- function(code, part) {
  lines <- strsplit(code, "\n", fixed = TRUE)[[1L]]
  for (boundary in c("from", "before")) {
    if (is.null(part[[boundary]])) next
    hits <- which(lines == part[[boundary]])
    if (length(hits) != 1L) check_fail("Expected one ", boundary, " boundary: ", part[[boundary]])
    lines <- if (boundary == "from") lines[seq.int(hits, length(lines))] else head(lines, hits - 1L)
  }
  paste0(trimws(paste(lines, collapse = "\n")), "\n")
}
code_and_comments <- function(code) {
  executable <- character()
  comments <- list()
  quote <- ""
  escaped <- FALSE
  for (line in strsplit(code, "\n", fixed = TRUE)[[1L]]) {
    chars <- strsplit(line, "", fixed = TRUE)[[1L]]
    start <- NA_integer_
    for (index in seq_along(chars)) {
      char <- chars[index]
      if (nzchar(quote)) {
        if (escaped) escaped <- FALSE
        else if (char == "\\") escaped <- TRUE
        else if (char == quote) quote <- ""
      } else if (char %in% c('"', "'", "`")) quote <- char
      else if (char == "#") { start <- index; break }
    }
    code_line <- trimws(if (is.na(start)) line else substr(line, 1L, start - 1L))
    if (nzchar(code_line)) executable <- c(executable, code_line)
    if (!is.na(start)) comments[[length(comments) + 1L]] <- list(line = length(executable), text = trimws(substring(line, start)))
    escaped <- FALSE
  }
  list(code = executable, comments = comments)
}
compare_script <- function(name, expected, actual) {
  left <- code_and_comments(expected)
  right <- code_and_comments(actual)
  errors <- character()
  for (category in c("code", "comments")) {
    if (identical(left[[category]], right[[category]])) next
    display <- function(items) {
      if (category == "code") items else vapply(items, function(x) paste0("after code line ", x$line, ": ", x$text), character(1L))
    }
    a <- display(left[[category]])
    b <- display(right[[category]])
    differences <- character()
    for (i in seq_len(max(length(a), length(b)))) {
      expected_line <- if (i <= length(a)) a[i] else "<absent>"
      actual_line <- if (i <= length(b)) b[i] else "<absent>"
      if (expected_line != actual_line) differences <- c(differences,
        paste0("  ", i, " chapter instructions: ", expected_line, "\n    saved script: ", actual_line))
    }
    errors <- c(errors, paste0(name, ": ", category, " differs\n", paste(differences, collapse = "\n")))
  }
  errors
}
chapter_book <- function(root, manifest) {
  root <- normalizePath(root, winslash = "/", mustWork = TRUE)
  if (!identical(manifest$version, 1L) && !identical(manifest$version, 1)) check_fail("Unsupported chapter-script manifest version")
  chunks <- new.env(parent = emptyenv())
  built <- new.env(parent = emptyenv())
  building <- character()
  all_chunks <- list()
  key <- function(part) paste(part$chapter, part$chunk, sep = "::")
  paths <- sort(Sys.glob(file.path(root, "[0-9][0-9]_*/index.qmd")))
  for (path in paths) {
    chapter <- substring(path, nchar(root) + 2L)
    for (block in source_blocks(check_read(path))) {
      if (block$kind != "chunk") next
      chunk <- list(chapter = chapter, line = block$line, options = block$value, code = chunk_code(block$body))
      all_chunks[[length(all_chunks) + 1L]] <- chunk
      if (!is.null(block$value$label)) {
        id <- key(list(chapter = chapter, chunk = block$value$label))
        if (exists(id, chunks, inherits = FALSE)) check_fail("Duplicate chunk label: ", id)
        assign(id, chunk, chunks)
      }
    }
  }
  chapter_part <- function(part) {
    id <- key(part)
    if (!exists(id, chunks, inherits = FALSE)) check_fail("Missing chapter chunk: ", id)
    chunk <- get(id, chunks, inherits = FALSE)
    if (!is.null(chunk$options[["file"]])) check_fail("Source chunk ", id, " includes a script instead of independent chapter code")
    if (!nzchar(trimws(chunk$code))) check_fail("Source chunk ", id, " is empty")
    select_section(chunk$code, part)
  }
  assemble <- function(parts) {
    sections <- vapply(parts, function(part) trimws(if (!is.null(part$script)) select_section(build(part$script), part) else chapter_part(part)), character(1L))
    paste0(paste(sections[nzchar(sections)], collapse = "\n\n"), "\n")
  }
  build <- function(script) {
    if (exists(script, built, inherits = FALSE)) return(get(script, built))
    if (script %in% building) check_fail("Cyclic script inheritance: ", script)
    if (!script %in% names(manifest$scripts)) check_fail("Unmapped inherited script: ", script)
    building <<- c(building, script)
    specification <- manifest$scripts[[script]]
    code <- paste0(check_default(specification$prefix), assemble(specification$parts))
    building <<- setdiff(building, script)
    assign(script, code, built)
    code
  }
  check <- function() {
    actual <- paste0("R/", basename(Sys.glob(file.path(root, "R/chapter_*.R"))))
    mapped <- names(manifest$scripts)
    errors <- c(vapply(setdiff(actual, mapped), function(x) paste0("Unmapped script: ", x), character(1L)),
                vapply(setdiff(mapped, actual), function(x) paste0("Missing script: ", x), character(1L)))
    handled <- character()
    record_parts <- function(parts) {
      for (part in parts) if (!is.null(part$chapter)) handled <<- c(handled, key(part))
    }
    for (specification in manifest$scripts) record_parts(specification$parts)
    for (checkpoint in manifest$checkpoints) { handled <- c(handled, key(checkpoint)); record_parts(checkpoint$parts) }
    for (intermediate in manifest$intermediate_chunks) {
      if (!nzchar(check_default(intermediate$note))) errors <- c(errors, "Intermediate chunk needs a reason")
      chapter_part(intermediate)
      handled <- c(handled, key(intermediate))
    }
    for (chunk in all_chunks) {
      options <- chunk$options
      filename <- check_default(options[["filename"]])
      if (!grepl("^chapter_[0-9]+[a-z]?\\.R$", filename)) next
      if (check_default(options$echo) == "false" || check_default(options$include) == "false") next
      if (!is.null(options[["file"]])) {
        included <- normalizePath(file.path(root, dirname(chunk$chapter), options[["file"]]), winslash = "/", mustWork = TRUE)
        if (!startsWith(included, paste0(root, "/"))) check_fail("Complete-script include escapes book root: ", included)
        included <- substring(included, nchar(root) + 2L)
        if (!included %in% mapped) errors <- c(errors, paste0("Unmapped complete-script include: ", included))
        next
      }
      id <- key(list(chapter = chunk$chapter, chunk = check_default(options$label)))
      if (!id %in% handled) errors <- c(errors, paste0("Unmapped saved-code chunk: ", chunk$chapter, ":", chunk$line, " (", filename, ")"))
    }
    for (script in mapped) if (file.exists(file.path(root, script))) errors <- c(errors, compare_script(script, build(script), check_read(file.path(root, script))))
    for (checkpoint in manifest$checkpoints) errors <- c(errors, compare_script(paste0(checkpoint$chapter, " (", checkpoint$chunk, ")"), assemble(checkpoint$parts), chapter_part(checkpoint)))
    unname(errors)
  }
  list(check = check, build = build, chapter_part = chapter_part, assemble = assemble)
}
check_chapter_scripts_main <- function(args = commandArgs(trailingOnly = TRUE)) {
  root <- check_root(args, "checks/check_chapter_scripts.R")
  if (!requireNamespace("jsonlite", quietly = TRUE)) check_fail('Install jsonlite with install.packages("jsonlite").')
  manifest <- jsonlite::fromJSON(file.path(root, "checks/chapter-scripts.json"), simplifyVector = FALSE)
  errors <- chapter_book(root, manifest)$check()
  if (length(errors)) check_fail(paste(errors, collapse = "\n\n"))
  message("All ", length(manifest$scripts), " chapter scripts and ", length(manifest$checkpoints), " checkpoints match the chapter instructions.")
  invisible(errors)
}
if (sys.nframe() == 0L) check_chapter_scripts_main()
