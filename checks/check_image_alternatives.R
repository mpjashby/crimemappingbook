# Check alternative-text coverage, not descriptive quality, in sources and rendered HTML.
helper_dir <- if (file.exists("checks/check_helpers.R")) "checks" else dirname(gsub("~+~", " ", sub("^--file=", "", commandArgs(FALSE)[startsWith(commandArgs(FALSE), "--file=")][1L]), fixed = TRUE))
source(file.path(helper_dir, "check_helpers.R"), local = TRUE)

prose_only <- function(text) {
  comments <- gregexpr("<!--.*?-->", text, perl = TRUE)[[1L]]
  if (comments[1L] != -1L) {
    lengths <- attr(comments, "match.length")
    for (i in rev(seq_along(comments))) {
      start <- comments[i]; end <- start + lengths[i] - 1L
      text <- paste0(substr(text, 1L, start - 1L), gsub("[^\n]", " ", substr(text, start, end)), substring(text, end + 1L))
    }
  }
  attr(source_blocks(text), "prose")
}
image_html <- function(text) {
  if (!requireNamespace("xml2", quietly = TRUE)) check_fail('Install xml2 with install.packages("xml2").')
  document <- xml2::read_html(paste0("<!doctype html><html><body>", text, "</body></html>"), options = c("RECOVER", "NOERROR", "NOWARNING", "HUGE"))
  errors <- character()
  counts <- c(images = 0L, "empty alternatives" = 0L, "named graphics" = 0L)
  attribute <- function(node, name) { value <- xml2::xml_attr(node, name); if (is.na(value)) "" else trimws(value) }
  nodes <- xml2::xml_find_all(document, "//img | //*[@role='img'] | //svg[contains(concat(' ',normalize-space(@role),' '),' graphics-document ')]")
  for (node in nodes) {
    where <- xml2::xml_path(node)
    if (xml2::xml_name(node) == "img") {
      counts["images"] <- counts["images"] + 1L
      alt <- xml2::xml_attr(node, "alt")
      if (is.na(alt)) errors <- c(errors, paste0(where, ": image lacks an alt attribute"))
      else if (!nzchar(trimws(alt))) {
        counts["empty alternatives"] <- counts["empty alternatives"] + 1L
        named_links <- xml2::xml_find_all(node, "ancestor::a[string-length(normalize-space(@aria-label)) > 0]")
        if (!length(named_links) && attribute(node, "role") != "presentation" && attribute(node, "aria-hidden") != "true") errors <- c(errors, paste0(where, ": empty alt needs documented decorative markup or a named link"))
      }
    } else {
      counts["named graphics"] <- counts["named graphics"] + 1L
      if (!nzchar(attribute(node, "aria-label")) && !nzchar(attribute(node, "aria-labelledby"))) errors <- c(errors, paste0(where, ": graphic with role img lacks an accessible name"))
    }
  }
  list(errors = errors, counts = counts[counts > 0L])
}
check_image_source <- function(path, text, expected = character()) {
  prose <- prose_only(text)
  html <- image_html(prose)
  errors <- if (length(html$errors)) paste0(path, ":", html$errors) else character()
  counts <- html$counts
  count <- function(name) { if (!name %in% names(counts)) counts[name] <<- 0L; counts[name] <<- counts[name] + 1L }
  line_at <- function(match) {
    # Literal match positions suffice for diagnostics, including repeated image forms.
    position <- regexpr(match, prose, fixed = TRUE)[1L]
    lengths(regmatches(substr(prose, 1L, position - 1L), gregexpr("\n", substr(prose, 1L, position - 1L), fixed = TRUE))) + 1L
  }
  named <- function(text) grepl("aria-label\\s*=\\s*[\"'][^\"']+", text, perl = TRUE)
  for (match in check_matches("!\\[([^\\]]*)\\]\\(([^\n)]*)\\)(\\{[^\n}]*\\})?", prose)) {
    count("Markdown images")
    fields <- regmatches(match, regexec("!\\[([^\\]]*)\\]\\(([^\n)]*)\\)(\\{[^\n}]*\\})?", match, perl = TRUE))[[1L]]
    alternative <- regmatches(fields[4L], regexec("(?:fig-alt|alt)\\s*=\\s*([\"'])(.*?)\\1", fields[4L], perl = TRUE))[[1L]]
    if (length(alternative) && nzchar(trimws(alternative[3L]))) next
    if (!length(alternative) && nzchar(trimws(fields[2L]))) next
    line <- strsplit(prose, "\n", fixed = TRUE)[[1L]][line_at(match)]
    if (named(line)) next
    errors <- c(errors, paste0(path, ":", line_at(match), ": Markdown image needs meaningful alt text or a named decorative link (", fields[3L], ")"))
  }
  for (match in check_matches("(?m)^:{3,}\\s+\\{\\.(?:process|hierarchy)\\b[^}]*\\}", prose)) {
    count("workflow diagrams")
    if (!named(match)) errors <- c(errors, paste0(path, ":", line_at(match), ": workflow diagram needs an accessible description"))
  }
  chunks <- character()
  for (block in source_blocks(text)) {
    if (!block$kind %in% c("chunk", "diagram") || check_default(block$value[["_commented"]]) == "true") next
    options <- block$value
    label <- check_default(options$label)
    chunks <- c(chunks, label)
    if (label %in% expected || (startsWith(label, "fig-") && check_default(options$include) != "false") || block$kind == "diagram") {
      count("generated visuals")
      alternative <- trimws(check_default(options[["fig-alt"]]))
      where <- paste0(path, ":", block$line)
      if (!nzchar(alternative)) errors <- c(errors, paste0(where, ": generated visual ", label, " needs fig-alt"))
      else if (startsWith(alternative, "[")) {
        values <- tryCatch(jsonlite::fromJSON(alternative, simplifyVector = FALSE), error = function(e) NULL)
        if (!is.null(values) && (!length(values) || !all(vapply(values, function(value) is.character(value) && length(value) == 1L && nzchar(trimws(value)), logical(1L))))) errors <- c(errors, paste0(where, ": every generated panel needs a non-empty alternative"))
      }
      if (block$kind == "diagram") {
        diagram <- paste(block$body, collapse = "\n")
        if (!grepl("(?m)^\\s*accTitle:\\s*\\S", diagram, perl = TRUE) || !grepl("(?m)^\\s*accDescr(?::\\s*\\S|\\s*\\{)", diagram, perl = TRUE)) errors <- c(errors, paste0(where, ": Mermaid SVG needs accTitle and accDescr"))
      }
    }
  }
  for (label in setdiff(expected, chunks)) errors <- c(errors, paste0(path, ": inventoried output chunk ", label, " is absent; review image-outputs.json"))
  list(errors = errors, counts = counts)
}
check_image_alternatives_main <- function(args = commandArgs(trailingOnly = TRUE)) {
  rendered <- NULL
  index <- match("--rendered", args)
  if (!is.na(index)) {
    if (index == length(args)) check_fail("Missing directory for --rendered")
    rendered <- args[index + 1L]; args <- args[-c(index, index + 1L)]
  }
  root <- check_root(args, "checks/check_image_alternatives.R")
  if (!is.null(rendered) && !grepl("^(/|[A-Za-z]:)", rendered)) rendered <- file.path(root, rendered)
  inventory <- jsonlite::fromJSON(file.path(root, "checks/image-outputs.json"), simplifyVector = FALSE)
  entries <- check_matches('(?m)^\\s*-\\s+([^\\s#"]+\\.qmd)(?:\\s|$)', check_read(file.path(root, "_quarto.yml")))
  paths <- sub('^\\s*-\\s+([^\\s#"]+\\.qmd).*$', "\\1", entries, perl = TRUE)
  paths <- trimws(paths)
  extra <- unlist(lapply(c("include/*.qmd", "resources/reports/*.qmd", "resources/examples/*.qmd"), function(pattern) Sys.glob(file.path(root, pattern))))
  paths <- sort(unique(c(paths, substring(extra, nchar(root) + 2L))))
  errors <- character(); counts <- numeric()
  add_counts <- function(seen) { for (name in names(seen)) { if (!name %in% names(counts)) counts[name] <<- 0; counts[name] <<- counts[name] + seen[name] } }
  for (path in paths) {
    source <- file.path(root, path)
    if (!file.exists(source)) { errors <- c(errors, paste0(path, ": expected source is absent")); next }
    result <- check_image_source(path, check_read(source), unlist(inventory[[path]]))
    errors <- c(errors, result$errors); add_counts(result$counts)
    if (!is.null(rendered) && !startsWith(path, "include/")) {
      output <- file.path(rendered, sub("\\.qmd$", ".html", path))
      if (!file.exists(output) && path == "resources/reports/yarra_waste_dumping.qmd") next
      if (!file.exists(output)) { errors <- c(errors, paste0(output, ": rendered page is absent")); next }
      result <- image_html(check_read(output))
      if (length(result$errors)) errors <- c(errors, paste0(output, ":", result$errors))
      if (length(result$counts)) names(result$counts) <- paste0("rendered ", names(result$counts))
      add_counts(result$counts)
    }
  }
  message(paste(paste(counts, names(counts)), collapse = ", "))
  if (length(errors)) check_fail(paste(errors, collapse = "\n"))
  invisible(list(errors = errors, counts = counts))
}
if (sys.nframe() == 0L) check_image_alternatives_main()
