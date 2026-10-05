# Check chunk, listing and section identifiers without rendering.
helper_dir <- if (file.exists("checks/check_helpers.R")) "checks" else dirname(gsub("~+~", " ", sub("^--file=", "", commandArgs(FALSE)[startsWith(commandArgs(FALSE), "--file=")][1L]), fixed = TRUE))
source(file.path(helper_dir, "check_helpers.R"), local = TRUE)

book_source <- function(path) grepl("^[0-9]{2}_[^/]+/index\\.qmd$", path) ||
  startsWith(path, "appendices/") || startsWith(path, "include/") || path %in% c("index.qmd", "contents.qmd", "setup.qmd")
valid_identifier <- function(value) !is.null(value) && grepl("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", value)
document_defaults <- function(text) {
  if (!startsWith(text, "---\n")) return(list())
  front <- strsplit(text, "---", fixed = TRUE)[[1L]][2L]
  execute <- regmatches(front, regexec("(?m)^execute:\\s*\n((?:[ \\t]+[^\n]*\n)*)", front, perl = TRUE))[[1L]]
  if (!length(execute)) return(list())
  result <- list()
  for (line in strsplit(execute[2L], "\n", fixed = TRUE)[[1L]]) {
    m <- regmatches(line, regexec("^\\s+(echo|include):\\s*(\\w+)", line, perl = TRUE))[[1L]]
    if (length(m)) result[[m[2L]]] <- m[3L]
  }
  result
}
check_sources <- function(sources) {
  errors <- anchors <- character()
  counts <- c(chunks = 0L, diagrams = 0L, listings = 0L, headings = 0L)
  for (path in names(sources)) {
    if (!book_source(path)) next
    text <- sources[[path]]
    defaults <- document_defaults(text)
    labels <- character()
    blocks <- source_blocks(text)
    for (block in blocks) {
      where <- paste0(path, ":", block$line)
      value <- block$value
      if (block$kind == "heading") {
        counts["headings"] <- counts["headings"] + 1L
        if (is.null(value)) errors <- c(errors, paste0(where, ": level-3 heading needs an identifier"))
        else if (!valid_identifier(value)) errors <- c(errors, paste0(where, ": invalid section identifier ", value))
        next
      }
      category <- if (block$kind == "diagram") "diagrams" else "chunks"
      counts[category] <- counts[category] + 1L
      label <- value$label
      if (is.null(label) || !nzchar(label)) errors <- c(errors, paste0(where, ": chunk needs an execution label"))
      else if (!valid_identifier(label)) errors <- c(errors, paste0(where, ": invalid execution label ", label))
      else labels <- c(labels, label)
      if (block$kind == "diagram" || !book_source(path)) next
      visible <- check_default(value$echo, check_default(defaults$echo, "true")) != "false" &&
        check_default(value$include, check_default(defaults$include, "true")) != "false" &&
        check_default(value[["_commented"]]) != "true"
      listing <- value[["lst-label"]]
      if (visible) {
        counts["listings"] <- counts["listings"] + 1L
        if (!valid_identifier(listing) || !startsWith(listing, "lst-")) errors <- c(errors, paste0(where, ": visible code needs a semantic lst-label"))
        if (!identical(value[["lst-cap"]], "")) errors <- c(errors, paste0(where, ": visible code needs a blank lst-cap"))
      } else if (!is.null(listing) || "lst-cap" %in% names(value)) errors <- c(errors, paste0(where, ": hidden code must not enter listing numbering"))
      if (!is.null(listing) && nzchar(listing)) anchors <- c(anchors, listing)
      if (!is.null(label) && startsWith(label, "fig-")) {
        anchors <- c(anchors, label)
        if (!"fig-cap" %in% names(value)) errors <- c(errors, paste0(where, ": numbered chart needs fig-cap"))
        if (!nzchar(check_default(value[["fig-alt"]]))) errors <- c(errors, paste0(where, ": numbered chart needs alternative text"))
      }
    }
    for (label in unique(labels[duplicated(labels)])) errors <- c(errors, paste0(path, ": duplicate execution label ", label))
    if (book_source(path)) {
      found <- check_matches("\\{[^}\n]*#((?:sec|map|fig|lst)-[\\w-]+)", attr(blocks, "prose"))
      anchors <- c(anchors, sub(".*#", "", found))
    }
  }
  for (anchor in unique(anchors)) {
    if (!valid_identifier(anchor)) errors <- c(errors, paste0("Invalid book cross-reference identifier: ", anchor))
    if (sum(anchors == anchor) > 1L) errors <- c(errors, paste0("Duplicate book cross-reference identifier: ", anchor))
  }
  list(errors = errors, counts = counts)
}
check_book_labels_main <- function(args = commandArgs(trailingOnly = TRUE)) {
  root <- check_root(args, "checks/check_book_labels.R")
  old <- setwd(root)
  on.exit(setwd(old), add = TRUE)
  paths <- system2("git", c("ls-files", "--cached", "--others", "--exclude-standard", shQuote("*.qmd")), stdout = TRUE)
  if (!is.null(attr(paths, "status"))) check_fail("Cannot list Quarto sources with Git")
  paths <- unique(paths[vapply(paths, book_source, logical(1L)) & file.exists(paths)])
  result <- check_sources(setNames(lapply(paths, check_read), paths))
  if (length(result$errors)) check_fail(paste(result$errors, collapse = "\n"))
  message("Checked ", result$counts["chunks"], " labelled R chunks, ", result$counts["diagrams"],
    " labelled diagrams, ", result$counts["listings"], " visible listings and ", result$counts["headings"], " labelled level-3 headings.")
  invisible(result)
}
if (sys.nframe() == 0L) check_book_labels_main()
