# Generate the book's LLM-friendly Markdown after a full Quarto render.
# Run from the project root: Rscript generate_llms.R
# Or run in the R Console: source("generate_llms.R")
# Dependencies: install.packages(c("yaml", "xml2"))
# Options: --skip-render (use existing HTML), --strict (fail on missing alt text),
#          --help. No packages are installed automatically.
# This compatibility generator can be retired after native Quarto book output
# passes the same content, image-description and link checks. Keep llms-txt: true.

# Define helpers and run generation in a private environment, keeping the
# student's or author's R workspace free of temporary functions and objects.
local({

# Join message fragments and stop with a concise error, omitting the R call stack.
fail <- function(...) stop(paste0(...), call. = FALSE)
# Collapse repeated whitespace and trim its ends; vector inputs stay vectorised.
compact_text <- function(x) trimws(gsub("[[:space:]]+", " ", x))
# Accept only one non-missing, non-blank string; && stops before testing invalid values.
present <- function(x) length(x) == 1L && !is.na(x) && nzchar(trimws(x))

# Write character lines as UTF-8 bytes with a final newline for consistent output.
write_utf8 <- function(text, path) {
  # Create any missing parent directories; an existing directory is harmless.
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  # Open a binary connection so the platform does not translate newline characters.
  con <- file(path, open = "wb")
  # Close the connection even if writing raises an error.
  on.exit(close(con))
  # Join lines, append one newline, encode as UTF-8 and write the resulting bytes.
  writeBin(charToRaw(enc2utf8(paste0(paste(text, collapse = "\n"), "\n"))), con)
}

# Run Quarto with an argument vector; return captured diagnostics or stop on failure.
run_quarto <- function(args) {
  # Locate Quarto and shell-quote each argument, including paths containing spaces.
  output <- suppressWarnings(system2(Sys.which("quarto"), shQuote(args),
                                    # Capture both normal output and errors for a useful failure report.
                                    stdout = TRUE, stderr = TRUE))
  # system2 attaches a status attribute when the command exits unsuccessfully.
  status <- attr(output, "status")
  # A missing status means success; a non-zero status means the build failed.
  if (!is.null(status) && status != 0L) {
    # Include the exit code and captured Quarto diagnostics in the error.
    fail("Quarto failed (", status, "):\n", paste(output, collapse = "\n"))
  }
  # Return diagnostics for callers without printing successful command output.
  invisible(output)
}

# Lexically normalise URL/project paths, without requiring files to exist.
# Resolve . and .. in a relative path using strings, without consulting the filesystem.
normal_path <- function(path) {
  # Convert Windows separators to URL separators, then split the path into components.
  parts <- strsplit(gsub("\\\\", "/", path), "/", fixed = TRUE)[[1]]
  # Start a stack of the path components retained so far.
  result <- character()
  # Process components from left to right so parent-directory steps have the right effect.
  for (part in parts) {
    # Ignore repeated separators and current-directory components.
    if (part %in% c("", ".")) next
    # A parent-directory component removes the most recent retained component.
    if (part == "..") {
      # Reject attempts to climb above the project or published site root.
      if (!length(result)) fail("Path escapes the project/site: ", path)
      # Remove the final component from the accumulated path.
      result <- head(result, -1L)
    # Append ordinary directory names and filenames to the accumulated path.
    } else result <- c(result, part)
  }
  # Return the normalised relative path with forward slashes.
  paste(result, collapse = "/")
}

# Return one row per configured page, in book order, including its group and output routes.
read_manifest <- function(config) {
  # Reject other project types because their page-discovery rules differ from books.
  if (!identical(config$project$type, "book")) fail("Expected a Quarto book project.")
  # Collect rows in a list while traversing nested book parts.
  rows <- list()
  # Traverse a sequence of pages or parts; group supplies the llms.txt section name.
  walk <- function(items, group) {
    # Allow an omitted section, such as a book with no appendices.
    if (is.null(items)) return(invisible(NULL))
    # yaml simplifies a sequence of bare filenames to a character vector.
    # Use a common list representation for both plain and mixed YAML sequences.
    if (is.character(items)) items <- as.list(items)
    # Visit entries in their configured order rather than discovering files on disk.
    for (item in items) {
      # Recognise the simplest manifest entry: a single source filename.
      if (is.character(item) && length(item) == 1L) {
        # Retain the source filename from a bare-string page entry.
        source <- item
      # Recognise a named part containing a nested sequence of chapters.
      } else if (is.list(item) && !is.null(item$chapters)) {
        # Read the part name to use as the group for its child pages.
        part <- item$part
        # Require a single text part title rather than silently guessing a section name.
        if (!is.character(part) || length(part) != 1L) {
          # Explain which manifest shape must be corrected.
          fail("Each book part must have a text name.")
        }
        # Recursively append the pages inside this part under its name.
        walk(item$chapters, part)
        # The part container is not itself a page; move to the next manifest entry.
        next
      # Also accept Quarto page entries with a file field.
      } else if (is.list(item) && present(item$file)) {
        # Read the filename from a mapping-style page entry.
        source <- item$file
      # Fail on unrecognised entries instead of silently leaving pages out.
      } else fail("Unsupported entry in book chapters/appendices.")
      # Reject absolute filesystem paths and URLs as book source filenames.
      if (grepl("^(/|[A-Za-z]:|[a-z]+://)", source)) fail("Source must be project-relative: ", source)
      # Resolve relative path components before checking source files and duplicate routes.
      source <- normal_path(source)
      # Accept the source extensions this generator knows how to map to HTML.
      if (!grepl("\\.(qmd|md|ipynb)$", source)) fail("Unsupported book source: ", source)
      # Fail before rendering if a configured source file cannot be found.
      if (!file.exists(source)) fail("Configured source is missing: ", source)
      # Replace the source extension with the expected rendered HTML extension.
      route <- sub("\\.[^.]+$", ".html", source)
      # Append to the enclosing rows list; <<- updates it from inside the recursive helper.
      rows[[length(rows) + 1L]] <<- data.frame(
        # Record both the input source and its corresponding published HTML route.
        source = source, html = route,
        # Place each .llms.md file alongside its HTML page and retain its index group.
        markdown = sub("\\.html$", ".llms.md", route), group = group,
        # Keep filenames and group names as strings rather than categorical factors.
        stringsAsFactors = FALSE
      )
    }
  }
  # Traverse front matter and chapters; named parts override the initial group.
  walk(config$book$chapters, "Front matter")
  # Append configured appendices after the chapters.
  walk(config$book$appendices, "Appendices")
  # An empty manifest cannot produce a meaningful book index.
  if (!length(rows)) fail("The book manifest is empty.")
  # Combine collected rows into a single data frame.
  pages <- do.call(rbind, rows)
  # Reject repeated output routes so one page cannot overwrite another.
  if (anyDuplicated(pages$html)) fail("Duplicate book route: ", pages$html[duplicated(pages$html)][1])
  # Return the completed manifest to the caller.
  pages
}

# Express a target route relative to the directory containing the current page.
relative_route <- function(target, current) {
  # Split the current page directory into its path components.
  base <- strsplit(dirname(current), "/", fixed = TRUE)[[1]]
  # At the site root, dirname returns . rather than a real path component.
  if (identical(base, ".")) base <- character()
  # Split the target filename and its directories into components.
  dest <- strsplit(target, "/", fixed = TRUE)[[1]]
  # Discard their common directory prefix before constructing the relative route.
  while (length(base) && length(dest) && base[1] == dest[1]) {
    # Remove one matching component from each side.
    base <- base[-1]; dest <- dest[-1]
  }
  # Climb out of the remaining current directories, then descend to the target.
  paste(c(rep("..", length(base)), dest), collapse = "/")
}

# Build an HTML-route lookup, including aliases for directory index pages.
make_routes <- function(pages) {
  # Use HTML paths as lookup names and Markdown paths as replacement values.
  routes <- setNames(pages$markdown, pages$html)
  # Process every manifest page in order; seq_len also handles zero rows safely.
  for (i in seq_len(nrow(pages))) {
    # Directory-style URLs are aliases only for pages actually named index.html.
    if (grepl("(^|/)index\\.html$", pages$html[i])) {
      # Remove index.html to obtain the containing directory route.
      alias <- sub("index\\.html$", "", pages$html[i])
      # Recognise a directory URL with a trailing slash.
      routes[alias] <- pages$markdown[i]
      # Also recognise the same directory URL without its trailing slash.
      routes[sub("/$", "", alias)] <- pages$markdown[i]
    }
  }
  # Return the named lookup vector.
  routes
}

# Rewrite known book-page links, keeping query strings and fragment identifiers intact.
rewrite_link <- function(href, current, site_url, routes) {
  # Leave empty links and same-page fragment links unchanged.
  if (!present(href) || startsWith(href, "#")) return(href)
  # Save everything from the first query or fragment delimiter onward.
  suffix <- regmatches(href, regexpr("[?#].*$", href))
  # Represent the absence of a query or fragment with an empty string.
  if (!length(suffix)) suffix <- ""
  # Separate the destination filename from its query and fragment.
  path <- sub("[?#].*$", "", href)
  # A query-only URL refers to the current page and needs no route replacement.
  if (!nzchar(path)) return(href)
  # Extract the published book path from its absolute site URL.
  site_path <- sub("^https?://[^/]+", "", site_url)
  # An absolute URL under this book belongs to the internal route lookup.
  if (startsWith(path, site_url)) {
    # Remove the site URL prefix to obtain a book-relative path.
    route <- substring(path, nchar(site_url) + 1L)
  # Recognise other absolute schemes and protocol-relative URLs.
  } else if (grepl("^([A-Za-z][A-Za-z0-9+.-]*:|//)", path)) {
    # Keep links outside the recognised book routes unchanged.
    return(href)
  # Resolve paths beginning at the web server root against the book site path.
  } else if (startsWith(path, "/")) {
    # A server-root link outside the published book should not be rewritten.
    if (!startsWith(path, site_path)) return(href)
    # Remove the book path prefix from a server-root link.
    route <- substring(path, nchar(site_path) + 1L)
  } else {
    # Resolve a relative link against the directory of the current HTML page.
    route <- paste(dirname(current), path, sep = "/")
  }
  # Decode URL escapes and resolve directory steps before looking up the route.
  route <- normal_path(utils::URLdecode(route))
  # Look up the Markdown equivalent of the resolved HTML or directory route.
  replacement <- routes[route]
  # Preserve links to supporting files or any other routes absent from the manifest.
  if (length(replacement) != 1L || is.na(replacement)) return(href)
  # Write a page-relative Markdown route and restore the untouched suffix.
  paste0(relative_route(unname(replacement), current), suffix)
}

# Replace an HTML node with safely escaped text in a new paragraph or inline span.
replace_text <- function(node, text, tag = "p") {
  # Create a new node of the requested HTML element type.
  replacement <- xml2::xml_new_root(tag)
  # Set literal text through xml2 so special characters are escaped correctly.
  xml2::xml_set_text(replacement, text)
  # Keep an identifier on the replaced element so authored links still resolve.
  identifier <- xml2::xml_attr(node, "id")
  if (present(identifier)) {
    # Pandoc paragraphs have no identifier field. Use a div for identified block
    # replacements so the Lua filter can preserve their cross-reference anchors.
    if (identical(tag, "p")) xml2::xml_set_name(replacement, "div")
    xml2::xml_set_attr(replacement, "id", identifier)
  }
  # Substitute the new node in the parsed document tree.
  xml2::xml_replace(node, replacement)
}

# Find an authored accessible description; return an empty string when none is supplied.
text_alternative <- function(node) {
  # Prefer explicit alt text, then the ARIA accessible label.
  for (attribute in c("alt", "aria-label")) {
    # Read the candidate text attribute; absent attributes return NA.
    value <- xml2::xml_attr(node, attribute)
    # Return the first usable description with normalised whitespace.
    if (present(value)) return(compact_text(value))
  }
  # Read any IDs naming elements that supply the accessible label.
  labelled <- xml2::xml_attr(node, "aria-labelledby")
  # Resolve referenced labels only when aria-labelledby is supplied.
  if (present(labelled)) {
    # Separate the space-delimited label-element IDs.
    ids <- strsplit(labelled, "[[:space:]]+")[[1]]
    # Search the document tree for elements with IDs.
    all <- xml2::xml_find_all(xml2::xml_root(node), "//*[@id]")
    # Combine text from matching label elements in document order.
    value <- paste(xml2::xml_text(all[xml2::xml_attr(all, "id") %in% ids]), collapse = " ")
    # Return the first usable description with normalised whitespace.
    if (present(value)) return(compact_text(value))
  }
  # As a final fallback, combine directly supplied SVG title and description text.
  value <- paste(xml2::xml_text(xml2::xml_find_all(node,
    # Match SVG children by local name so XML namespaces do not prevent discovery.
    "./*[local-name()='title' or local-name()='desc']")), collapse = " ")
  # Return the supplied description, or an empty string for the caller to report.
  if (present(value)) compact_text(value) else ""
}

# This filter writes explicit HTML anchors, which remain usable in Markdown
# without relying on a reader's automatic heading-slug rules. It removes Quarto
# presentation attributes while retaining code language classes and link targets.
# Store a Lua program as R strings; it is written to staging when generation runs.
anchor_filter <- c(
  # Lua helper: convert an element identifier into an explicit block or inline anchor.
  "local function anchor(el, inline)",
  # Save the original identifier before clearing presentation attributes.
  "  local id = el.identifier",
  # Avoid emitting the same identifier twice after adding the explicit anchor.
  "  el.identifier = ''",
  # Discard HTML layout and other presentation attributes from this element.
  "  el.attributes = {}",
  # Retain code language classes so Markdown code fences still identify their language.
  "  if el.t ~= 'CodeBlock' then el.classes = {} end",
  # Skip empty IDs, automatic code-line IDs and random quiz-control IDs.
  "  if id == '' or id:match('^cb%d') or id:match('^radio_') then return nil end",
  # Escape HTML-sensitive characters before interpolating the ID into an anchor.
  "  id = id:gsub('&', '&amp;'):gsub('\"', '&quot;'):gsub('<', '&lt;')",
  # Construct an empty anchor at the original cross-reference target.
  "  local html = '<a id=\"' .. id .. '\"></a>'",
  # Use an inline anchor for spans and links within paragraphs.
  "  if inline then return pandoc.RawInline('html', html) end",
  # Use a block anchor for headings, listings, tables and containers.
  "  return pandoc.RawBlock('html', html)",
  "end",
  # Keep a heading and place its explicit anchor immediately before it.
  "function Header(el) local a = anchor(el); if a then return {a, el} end; return el end",
  # Keep the code block and prepend its listing anchor if one exists.
  "function CodeBlock(el) local a = anchor(el); if a then return {a, el} end; return el end",
  # Keep the table and prepend its explicit anchor if one exists.
  "function Table(el) local a = anchor(el); if a then return {a, el} end; return el end",
  # Keep figure content and prepend its explicit anchor if one exists.
  "function Figure(el) local a = anchor(el); if a then return {a, el} end; return el end",
  # Keep a link and preserve any identifier attached to it as an inline anchor.
  "function Link(el) local a = anchor(el, true); if a then return {a, el} end; return el end",
  # Flatten a div container while retaining its content and identifier.
  "function Div(el)",
  # Prepare the div anchor and keep its child blocks.
  "  local a = anchor(el); local blocks = el.content",
  # Prepend the anchor when present, then return the unwrapped blocks.
  "  if a then blocks:insert(1, a) end; return blocks",
  "end",
  # Flatten an inline span while retaining its text and identifier.
  "function Span(el)",
  # Prepare an inline anchor and keep the span contents.
  "  local a = anchor(el, true); local inlines = el.content",
  # Prepend the anchor when present, then return the unwrapped inline content.
  "  if a then inlines:insert(1, a) end; return inlines",
  "end",
  # Abort if a parsed image reaches Pandoc; HTML cleaning should have replaced it.
  "function Image(el) error('An image survived HTML cleaning: ' .. el.src) end"
)

# Clean one rendered page, stage its Markdown and return metadata and validation details.
convert_page <- function(page, output_dir, site_url, routes, staging, lua) {
  # Locate this manifest page in the rendered output directory.
  path <- file.path(output_dir, page$html)
  # Stop rather than generating an incomplete index when an HTML page is missing.
  if (!file.exists(path)) fail("Rendered page is missing: ", path)
  # Parse rendered HTML as UTF-8 so transformations operate on elements, not regex matches.
  document <- xml2::read_html(path, encoding = "UTF-8")
  # Select Quarto's main content element, excluding the surrounding website navigation.
  main <- xml2::xml_find_all(document, "//main[@id='quarto-document-content']")
  # Require exactly one content root so extraction is unambiguous.
  if (length(main) != 1L) fail("Expected one main content element: ", path)
  # Extract the rendered H1, retaining the book numbering already resolved by Quarto.
  title <- compact_text(xml2::xml_text(xml2::xml_find_first(main, ".//h1")))
  # Every index entry must have a usable page title.
  if (!present(title)) fail("Missing page title: ", path)
  # Match the abstract class as a complete class token rather than a partial string.
  abstract <- xml2::xml_find_first(main, ".//*[contains(concat(' ', normalize-space(@class), ' '), ' abstract ')]")
  # Prefer the rendered abstract as the index description.
  description <- compact_text(xml2::xml_text(abstract))
  # Use introductory prose when the page has no usable abstract.
  if (!present(description)) {
    # Find candidate prose paragraphs inside the main content.
    paragraphs <- xml2::xml_find_all(main,
      # Exclude figure captions, title metadata, code containers and image paragraphs.
      ".//p[not(ancestor::figure) and not(ancestor::header) and not(ancestor::pre) and not(.//img)]")
    # Extract and normalise all candidate paragraph texts.
    texts <- compact_text(xml2::xml_text(paragraphs))
    # Discard missing and empty paragraph texts.
    texts <- texts[!is.na(texts) & nzchar(texts)]
    # Select the first remaining paragraph, or an empty string if none remain.
    description <- if (length(texts)) texts[1] else ""
  }
  # Fail clearly rather than publishing an index entry with no description.
  if (!present(description)) fail("Missing page description: ", path)

  # Collect missing-description diagnostics for this page without inventing descriptions.
  missing <- character()
  # Record the page and element context, then return a visible placeholder.
  report_missing <- function(node, kind) {
    # Prefer a source URL or filename because it helps locate the affected visual.
    context <- xml2::xml_attr(node, "src")
    # Use the element's XPath when there is no source attribute.
    if (!present(context)) context <- xml2::xml_path(node)
    # Append to the enclosing page-level diagnostic vector from inside this helper.
    missing <<- c(missing, paste0(page$html, ": ", kind, " ", context))
    # Return an explicit placeholder to keep the omission visible in non-strict output.
    paste0("[Missing text alternative for ", kind, ": ", context, "]")
  }
  # Widgets require authored descriptions: their JavaScript payload is not prose.
  # Find interactive htmlwidgets before removing their JavaScript payloads.
  widgets <- xml2::xml_find_all(main,
    # Use a whitespace-delimited class test to match the intended HTML component.
    ".//*[contains(concat(' ', normalize-space(@class), ' '), ' html-widget ')]")
  # Replace each interactive widget with its supplied accessible description.
  for (node in widgets) {
    # Read an authored description using the shared accessibility lookup.
    alt <- text_alternative(node)
    # Quarto places accessible map descriptions on the surrounding figure group,
    # rather than on the empty div that Leaflet populates with JavaScript.
    if (!present(alt)) {
      labelled_parent <- xml2::xml_find_first(node,
        "ancestor::*[@aria-label or @aria-labelledby][1]")
      if (!inherits(labelled_parent, "xml_missing")) {
        alt <- text_alternative(labelled_parent)
      }
    }
    # Report an undescribed widget and use a visible placeholder.
    if (!present(alt)) alt <- report_missing(node, "interactive content")
    # Keep a textual record of the widget without its executable payload.
    replace_text(node, paste0("Interactive content: ", alt))
  }
  # Find images, SVGs, canvases and other embedded visual elements.
  visuals <- xml2::xml_find_all(main, ".//img | .//*[local-name()='svg'] | .//canvas | .//object | .//embed")
  # Only outer visuals: nested SVG elements disappear with their containing SVG.
  # Filter the node list before mutating the document to avoid revisiting SVG descendants.
  visuals <- visuals[!vapply(visuals, function(n) length(xml2::xml_find_all(n,
    # Exclude nodes nested inside an SVG that will be replaced as a whole.
    "ancestor::*[local-name()='svg']")) > 0L, logical(1))]
  # Process each retained visual separately, including composite-figure images.
  for (node in visuals) {
    # An explicitly empty alt attribute marks an image as decorative.
    decorative <- identical(xml2::xml_attr(node, "alt"), "") ||
      # Also omit visuals explicitly hidden from accessibility APIs.
      identical(xml2::xml_attr(node, "aria-hidden"), "true") ||
      # Presentation and none roles likewise identify decorative content.
      xml2::xml_attr(node, "role") %in% c("presentation", "none")
    # Remove decorative visuals without adding descriptions or warnings.
    if (decorative) { xml2::xml_remove(node); next }
    # Read an authored description using the shared accessibility lookup.
    alt <- text_alternative(node)
    # Report figures without authored alternatives so their source can be fixed.
    if (!present(alt)) alt <- report_missing(node, "figure")
    # Replace the visual inline; leave any separate caption in its original container.
    replace_text(node, paste0("Figure: ", alt), "span")
  }
  # Convert embedded video, audio and frame players into readable descriptions and links.
  for (node in xml2::xml_find_all(main, ".//iframe | .//video | .//audio")) {
    # Prefer the media element's accessible label.
    label <- text_alternative(node)
    # Use the media title when no accessible description is supplied.
    if (!present(label)) label <- xml2::xml_attr(node, "title")
    # Report an undescribed media player rather than guessing its subject.
    if (!present(label)) label <- report_missing(node, "media")
    # Read the player's direct source URL if present.
    src <- xml2::xml_attr(node, "src")
    # For video/audio elements, fall back to the first nested source element.
    if (!present(src)) src <- xml2::xml_attr(xml2::xml_find_first(node, ".//source"), "src")
    # Create a paragraph to replace the player.
    replacement <- xml2::xml_new_root("p")
    # Write the supplied media description into the replacement paragraph.
    xml2::xml_set_text(replacement, paste0("Media: ", label))
    # Add a usable media link only when a source URL exists.
    if (present(src)) {
      # Append an anchor with the media source as its destination.
      link <- xml2::xml_add_child(replacement, "a", href = src)
      # Give the media link descriptive visible text.
      xml2::xml_set_text(link, " (open media)")
    }
    # Substitute the new node in the parsed document tree.
    xml2::xml_replace(node, replacement)
  }

  # Preserve quiz choices and explicitly encoded answers before discarding inputs.
  # Find each radio-button quiz so its choices can be retained as text.
  for (group in xml2::xml_find_all(main,
    # Use a whitespace-delimited class test to match the intended HTML component.
    ".//*[contains(concat(' ', normalize-space(@class), ' '), ' webex-radiogroup ')]")) {
    # Create an unordered HTML list in place of the interactive radio group.
    list <- xml2::xml_new_root("ul")
    # Read the choices in the same order as the published quiz.
    for (label in xml2::xml_find_all(group, ".//label")) {
      # Read the explicit correctness marker stored on this choice's input.
      answer <- xml2::xml_attr(xml2::xml_find_first(label, ".//input"), "value")
      # Append one list item for the current quiz choice.
      item <- xml2::xml_add_child(list, "li")
      # Retain the choice text while dropping its interactive input control.
      xml2::xml_set_text(item, paste0(compact_text(xml2::xml_text(label)),
        # Label a solution only when the HTML explicitly marks it as the correct answer.
        if (identical(answer, "answer")) " (Correct answer)" else ""))
    }
    # Replace the whole radio group with its readable choice list.
    xml2::xml_replace(group, list)
  }
  # Convert dropdown quizzes before removing their form controls.
  for (node in xml2::xml_find_all(main, ".//select")) {
    # Read every dropdown option in its original order.
    choices <- xml2::xml_find_all(node, ".//option")
    # Build one textual option list, labelling only encoded correct answers.
    text <- paste(vapply(choices, function(choice) paste0(
      # Normalise each option's displayed text.
      compact_text(xml2::xml_text(choice)),
      # Identify solutions using the same explicit marker as radio quizzes.
      if (identical(xml2::xml_attr(choice, "value"), "answer")) " (Correct answer)" else ""
    # Require one string per option and join the choices with semicolons.
    ), character(1)), collapse = "; ")
    # Substitute an inline textual choice list for the dropdown.
    replace_text(node, paste0("Choices: ", text), "span")
  }
  # Handle any remaining fill-in-the-blank quiz inputs.
  for (node in xml2::xml_find_all(main, ".//input")) {
    # Read the answer exactly as encoded in data-answer; do not infer one.
    answer <- xml2::xml_attr(node, "data-answer")
    # Retain an encoded answer or insert a blank placeholder if no answer is supplied.
    replace_text(node, if (present(answer)) paste0("[Answer: ", answer, "]") else "[blank]", "span")
  }
  # Remove matched website controls and scaffolding from the content tree.
  xml2::xml_remove(xml2::xml_find_all(main,
    # Discard scripts, styles, controls, comments, heading-link icons and callout icons.
    ".//script | .//style | .//nav | .//footer | .//button | .//noscript | .//comment() | .//a[contains(concat(' ', normalize-space(@class), ' '), ' anchorjs-link ')] | .//*[contains(concat(' ', normalize-space(@class), ' '), ' callout-icon-container ')]"))
  # Remove code-line self-links for both ordinary and annotated code blocks.
  # Pandoc keeps their code text but discards the nested span IDs; retaining the
  # line-number controls would therefore create links with no Markdown target.
  xml2::xml_remove(xml2::xml_find_all(main,
    ".//pre//a[starts-with(@href, '#cb') or starts-with(@href, '#annotated-cell-')]"))
  # Collect internal links whose destination pages and anchors must be checked later.
  links <- list()
  # Visit each retained content link after the cleaning transformations.
  for (node in xml2::xml_find_all(main, ".//a[@href]")) {
    # Read the original link destination.
    href <- xml2::xml_attr(node, "href")
    # Resolve and rewrite a known book-page link using the manifest lookup.
    rewritten <- rewrite_link(href, page$html, site_url, routes)
    # Store the rewritten destination in the HTML before Markdown conversion.
    xml2::xml_set_attr(node, "href", rewritten)
    # Pandoc rebuilds footnotes and their backlinks using its own numbering.
    # Identify footnote references/backlinks that Pandoc will rebuild itself.
    footnote <- xml2::xml_attr(node, "role") %in% c("doc-noteref", "doc-backlink")
    # Record same-page anchors and Markdown destinations, excluding rebuilt footnotes.
    if (!footnote && (startsWith(rewritten, "#") || grepl("\\.llms\\.md([?#]|$)", rewritten))) {
      # Append this destination to the page's later validation inputs.
      links[[length(links) + 1L]] <- rewritten
    }
  }
  # Reuse one temporary fragment path because pages are converted sequentially.
  html <- file.path(staging, "fragment.html")
  # Serialise only the cleaned main element for Pandoc to read.
  write_utf8(as.character(main[[1]]), html)
  # Choose the staged Markdown path matching this page's manifest route.
  destination <- file.path(staging, page$markdown)
  # Create staged chapter/appendix directories as needed.
  dir.create(dirname(destination), recursive = TRUE, showWarnings = FALSE)
  # Use Quarto's bundled Pandoc to convert HTML to Markdown, allowing explicit anchors.
  run_quarto(c("pandoc", html, "--from=html", "--to=markdown+raw_html",
               # Use ATX headings, disable forced line wrapping and apply the anchor-preservation filter.
               "--markdown-headings=atx", "--wrap=none", paste0("--lua-filter=", lua),
               # Write Pandoc's converted document to its staging file.
               "--output", destination))
  # Read the staged Markdown for content checks and later anchor validation.
  markdown <- readLines(destination, warn = FALSE, encoding = "UTF-8")
  # Validate parsed images with the Lua filter; literal image syntax inside R
  # teaching code is allowed and must not be changed by a regex replacement.
  # Check for residual visual, player or script HTML that conversion should have removed.
  if (any(grepl("<(img|svg|canvas|iframe|script)([ >])", markdown, ignore.case = TRUE))) {
    # Reject leftover HTML rather than publishing partially cleaned content.
    fail("Unconverted HTML content remains: ", page$html)
  }
  # Prepend the canonical HTML source URL so readers and agents can cite the original.
  write_utf8(c(paste0("Source: ", site_url, page$html), "", markdown), destination)
  # Return metadata, omissions and converted content for whole-book validation and indexing.
  list(title = title, description = description, missing = missing,
       # Flatten recorded links while retaining Markdown lines for anchor checks.
       links = unlist(links), markdown = markdown)
}

# Check recorded internal destinations against all converted pages before publishing any files.
validate_links <- function(pages, results) {
  # Process every manifest page in order; seq_len also handles zero rows safely.
  for (i in seq_len(nrow(pages))) {
    # Validate every recorded internal link for this source page.
    for (link in results[[i]]$links) {
      # Separate the destination filename from its query and fragment.
      path <- sub("[?#].*$", "", link)
      # A fragment-only link targets the current Markdown page.
      target <- if (!nzchar(path)) pages$markdown[i] else
        # Otherwise resolve the destination relative to the source page directory.
        normal_path(paste(dirname(pages$markdown[i]), utils::URLdecode(path), sep = "/"))
      # Find the destination page in the authoritative manifest.
      j <- match(target, pages$markdown)
      # Reject Markdown destinations with no corresponding configured book page.
      if (is.na(j)) fail("Unknown Markdown target in ", pages$html[i], ": ", link)
      # Check an anchor target only when the URL contains a fragment.
      if (grepl("#", link, fixed = TRUE)) {
        # Decode the fragment identifier without altering the query string.
        fragment <- utils::URLdecode(sub("^[^#]*#", "", link))
        # Escape ampersands exactly as the Lua anchor writer does.
        escaped <- gsub("&", "&amp;", fragment, fixed = TRUE)
        # Escape quotes to match the generated HTML identifier attribute.
        escaped <- gsub('"', "&quot;", escaped, fixed = TRUE)
        # Escape less-than signs to match the generated HTML anchor.
        escaped <- gsub("<", "&lt;", escaped, fixed = TRUE)
        # Require a literal matching explicit anchor in the destination Markdown.
        if (nzchar(fragment) && !any(grepl(paste0('<a id="', escaped, '"></a>'),
                                          # Search the target page, using fixed matching rather than treating the ID as a regex.
                                          results[[j]]$markdown, fixed = TRUE))) {
          # Report the originating page and broken destination for diagnosis.
          fail("Missing anchor target in ", pages$html[i], ": ", link)
        }
      }
    }
  }
}

# Coordinate dependency checks, rendering, conversion, validation, indexing and publication.
generate_llms <- function(args = commandArgs(trailingOnly = TRUE)) {
  # Show usage information without rendering, loading dependencies or writing output.
  if ("--help" %in% args) {
    # Print the supported command-line invocation and flags.
    cat("Usage: Rscript generate_llms.R [--skip-render] [--strict]\n",
        # Explain the required working directory and dependencies.
        "Run from the book root. Requires yaml, xml2 and Quarto.\n",
        # State that normal invocation renders the whole book before conversion.
        "Default: render the entire book, then generate LLM files in its output directory.\n",
        # Make the freshness limitation of using existing HTML explicit.
        "--skip-render assumes existing HTML is current; it does not verify freshness.\n",
        # Explain strict mode's missing-description failure policy.
        "--strict fails if figures or interactive media lack text alternatives.\n", sep = "")
    # Stop processing after printing help, with no generation side effects.
    return(invisible(NULL))
  }
  # Identify any command-line arguments outside the supported flag set.
  unknown <- setdiff(args, c("--skip-render", "--strict"))
  # Reject misspelled flags instead of silently choosing unexpected behaviour.
  if (length(unknown)) fail("Unknown arguments: ", paste(unknown, collapse = " "))
  # Check each required R package without attaching it or installing anything.
  for (package in c("yaml", "xml2")) {
    # Detect a missing dependency before rendering or opening output files.
    if (!requireNamespace(package, quietly = TRUE)) {
      # Give a copyable package-installation command in the error.
      fail("Missing R package '", package, "'. Install with install.packages(\"", package, "\").")
    }
  }
  # Require a Quarto executable accessible to this R process.
  if (!nzchar(Sys.which("quarto"))) fail("Quarto is not available on PATH.")
  # Require invocation from the project root rather than guessing another directory.
  if (!file.exists("_quarto.yml")) fail("Run this command from the book project root.")
  # Parse project configuration while disabling YAML expression evaluation.
  config <- yaml::read_yaml("_quarto.yml", eval.expr = FALSE)
  # Validate the configured page list before invoking the render.
  pages <- read_manifest(config)
  # Honour an explicitly configured Quarto output directory.
  output_dir <- config$project[["output-dir"]]
  # Use Quarto's book default when the configuration does not override it.
  if (is.null(output_dir)) output_dir <- "_book"
  # Require a usable relative output directory for this project.
  if (!present(output_dir) || grepl("^(/|[A-Za-z]:)", output_dir)) fail("Output directory must be project-relative.")
  # Normalise directory steps before creating or locating generated output.
  output_dir <- normal_path(output_dir)
  # Keep generation out of the source root itself.
  if (!nzchar(output_dir)) fail("Output directory must not be the project root.")
  # Use the configured publication URL rather than hard-coding the production host.
  site_url <- config$book[["site-url"]]
  # Require an absolute HTTP(S) URL that can safely be extended with page routes.
  if (!present(site_url) || !grepl("^https?://[^/?#]+(/[^?#]*)?$", site_url)) {
    # Explain how the publication URL must be configured.
    fail("book.site-url must be an absolute HTTP(S) URL without query or fragment.")
  }
  # Ensure exactly one trailing slash before appending relative routes.
  site_url <- paste0(sub("/+$", "", site_url), "/")
  # Require the title and summary used in the root llms.txt index.
  if (!present(config$book$title) || !present(config$book$description)) fail("Book title and description are required.")
  # Prepare the lookup used for rewriting all internal book links.
  routes <- make_routes(pages)
  # Render unless the user explicitly elects to use existing HTML.
  if (!"--skip-render" %in% args) {
    # Report the full-book render and its destination.
    message("Rendering the full book into ", output_dir, " ...")
    # Run one project render so book-wide numbering and references remain consistent.
    run_quarto(c("render", ".", "--output-dir", output_dir))
  # Warn that skip-render does not establish whether HTML matches the current sources.
  } else message("Using existing HTML; source freshness has not been checked.")
  # Require rendered output before creating conversion staging files.
  if (!dir.exists(output_dir)) fail("Output directory is missing: ", output_dir)
  # Choose a unique staging directory on the same filesystem as final output.
  staging <- tempfile(".llms-staging-", tmpdir = output_dir)
  # Create the temporary staging directory before writing any fragments.
  dir.create(staging)
  # Remove staging files whether generation succeeds or fails.
  on.exit(unlink(staging, recursive = TRUE), add = TRUE)
  # Choose the temporary file containing the embedded Pandoc Lua filter.
  lua <- file.path(staging, "anchors.lua")
  # Write the filter text only when actual generation is requested.
  write_utf8(anchor_filter, lua)
  # Convert manifest pages sequentially and collect their metadata and diagnostics.
  results <- lapply(seq_len(nrow(pages)), function(i) {
    # Report the page currently being converted.
    message("Converting ", pages$html[i])
    # Stage this page's Markdown without replacing its published LLM file yet.
    convert_page(pages[i, ], output_dir, site_url, routes, staging, lua)
  })
  # Combine missing-description diagnostics from every converted page.
  missing <- unlist(lapply(results, `[[`, "missing"))
  # Make any accessibility omissions visible in the command output.
  if (length(missing)) {
    # List the affected pages and visuals so their authored descriptions can be repaired.
    message("Missing text alternatives:\n", paste(missing, collapse = "\n"))
    # In strict mode, stop before publishing any newly converted LLM files.
    if ("--strict" %in% args) fail("Strict validation failed; LLM outputs have not been replaced.")
  }
  # Validate internal destinations only after all target pages have been converted.
  validate_links(pages, results)
  # Read author metadata from the same configuration as the page manifest.
  author <- config$book$author
  # Support author mappings and sequences as well as a single author string.
  if (is.list(author)) author <- unlist(lapply(author, function(a) if (is.list(a)) a$name else a))
  # Build optional author information without adding absent fields.
  metadata <- c(if (length(author)) paste0("Author: ", paste(author, collapse = ", ")),
                # Use the configured subtitle as the edition information.
                if (present(config$book$subtitle)) paste0("Edition: ", config$book$subtitle),
                # Include the licence value as supplied by the book configuration.
                if (present(config$book$license)) paste0("Licence: ", config$book$license))
  # Start llms.txt with the book H1 title and a separating blank line.
  index <- c(paste0("# ", compact_text(config$book$title)), "",
             # Add the book description as a blockquote, followed by available metadata.
             paste0("> ", compact_text(config$book$description)), "", metadata, "")
  # Remember the previous manifest group to avoid repeating adjacent section headings.
  last_group <- NULL
  # Process every manifest page in order; seq_len also handles zero rows safely.
  for (i in seq_len(nrow(pages))) {
    # Start a new index section whenever the configured group changes.
    if (!identical(last_group, pages$group[i])) {
      # Append the front-matter, part or appendix heading and its blank line.
      index <- c(index, paste0("## ", pages$group[i]), "")
      # Remember the group just emitted for the next page.
      last_group <- pages$group[i]
    }
    # Escape Markdown-sensitive brackets and backslashes in the rendered page title.
    label <- gsub("([\\[\\]\\\\])", "\\\\\\1", results[[i]]$title, perl = TRUE)
    # Add an ordered page entry using an absolute Markdown URL and extracted description.
    index <- c(index, paste0("- [", label, "](", site_url, pages$markdown[i], "): ",
                            # Use the normalised page description after the link.
                            results[[i]]$description))
  }
  # Stage the complete llms.txt only after its page metadata has been collected.
  write_utf8(index, file.path(staging, "llms.txt"))
  # List the generated LLM files this run owns; unrelated Markdown is never included.
  owned <- c(pages$markdown, "llms.txt")
  # Name the hidden ownership record used to recognise stale generated files.
  record <- ".llms-generated-files.txt"
  # Locate any ownership record left by an earlier successful generation.
  old_record <- file.path(output_dir, record)
  # Read previous owned paths, or treat the first run as having no stale files.
  previous <- if (file.exists(old_record)) readLines(old_record, warn = FALSE) else character()
  # Validate ownership records before using them for stale-output deletion.
  # Check every recorded path before allowing it to influence stale-file cleanup.
  for (path in previous) {
    # Reject unnormalised or absolute entries in the ownership record.
    if (!identical(path, normal_path(path)) || startsWith(path, "/") ||
        # Restrict cleanup candidates to the index or the generator's Markdown suffix.
        !(identical(path, "llms.txt") || grepl("\\.llms\\.md$", path))) {
      # Stop if the record contains an unexpected path instead of attempting deletion.
      fail("Unsafe path in generator ownership record: ", path)
    }
  }
  # Stage the updated ownership record alongside the new LLM files.
  write_utf8(owned, file.path(staging, record))
  # Same-filesystem rename is atomic per file on macOS/Linux. Validation finishes
  # before publication; a deployment must run only after this command succeeds.
  # Publish each validated output and then the ownership record.
  for (path in c(owned, record)) {
    # Resolve the recorded relative output path inside the book output directory.
    target <- file.path(output_dir, path)
    # Create target chapter/appendix directories before the rename.
    dir.create(dirname(target), recursive = TRUE, showWarnings = FALSE)
    # Replace this file using a same-filesystem rename, failing if it cannot be written.
    if (!file.rename(file.path(staging, path), target)) fail("Cannot replace output: ", target)
  }
  # Find files owned by the previous run but absent from the current manifest.
  for (path in setdiff(previous, owned)) {
    # Resolve the recorded relative output path inside the book output directory.
    target <- file.path(output_dir, path)
    # Delete only a stale owned file, and report a failed deletion.
    if (file.exists(target) && unlink(target) != 0L) fail("Cannot remove stale output: ", target)
  }
  # Report the number of converted pages and the output directory after publication.
  message("Generated ", nrow(pages), " Markdown pages and llms.txt in ", output_dir,
          # Include an omission count in the completion message for non-strict runs.
          if (length(missing)) paste0(" (", length(missing), " missing text alternatives).") else ".")
  # Return the manifest for programmatic callers without printing a data frame.
  invisible(pages)
}

# Console execution uses the default options, rather than arguments supplied
# when Positron started R. Rscript execution accepts the documented CLI flags.
args <- if (interactive()) character() else commandArgs(trailingOnly = TRUE)
# Start generation for both source() and Rscript. Allow errors to propagate:
# Rscript exits unsuccessfully, while an interactive R session remains open.
generate_llms(args)

# End the private environment used for this script's helpers and working data.
})
