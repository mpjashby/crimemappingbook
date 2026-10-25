# Add the exercise home page as a peer of the book's Appendices section.
# Rewrite only the sidebar so embedded scripts and the chapter body keep their bytes.
book_navigation_html <- function(text, href) {
  pattern <- '(?s)<nav\\b[^>]*\\bid="quarto-sidebar"[^>]*>.*?</nav>'
  position <- regexpr(pattern, text, perl = TRUE)
  if (position[1L] < 0L) return(text)
  sidebar <- regmatches(text, position)
  document <- xml2::read_html(sidebar)
  nav <- xml2::xml_find_first(document, "//nav")
  appendices <- xml2::xml_find_all(nav,
    ".//div[contains(@class, 'sidebar-menu-container')]/ul/li[div/a/span[normalize-space(.)='Appendices']]")
  if (length(appendices) != 1L) stop("Cannot locate the Appendices sidebar section.", call. = FALSE)
  existing <- xml2::xml_find_all(nav, ".//*[@id='book-exercises-link']")
  # Migrate the previous footer link without removing other footer content.
  old <- xml2::xml_find_all(nav,
    ".//div[contains(@class, 'sidebar-footer-item')][count(.//a)=1][.//a[normalize-space(.)='Exercises']]")
  if (length(existing) == 1L && !length(old) &&
      identical(xml2::xml_attr(xml2::xml_find_first(existing, ".//a"), "href"), href) &&
      identical(xml2::xml_path(xml2::xml_find_first(existing, "preceding-sibling::*[1]")),
                xml2::xml_path(appendices))) return(text)
  xml2::xml_remove(existing)
  xml2::xml_remove(old)
  empty <- xml2::xml_find_all(nav,
    ".//div[contains(@class, 'quarto-sidebar-footer')][not(*)][normalize-space(.)='']")
  xml2::xml_remove(empty)
  item <- xml2::read_xml(paste0(
    '<li id="book-exercises-link" class="sidebar-item">',
    '<div class="sidebar-item-container">',
    '<a class="sidebar-item-text sidebar-link" href="">',
    '<span class="menu-text">Exercises</span></a></div></li>'
  ))
  xml2::xml_set_attr(xml2::xml_find_first(item, "//a"), "href", href)
  xml2::xml_add_sibling(appendices, item, .where = "after")
  replacement <- as.character(nav)
  end <- position[1L] + attr(position, "match.length")
  paste0(substr(text, 1L, position[1L] - 1L), replacement, substring(text, end))
}

update_book_navigation <- function(output) {
  for (package in c("xml2", "fs")) {
    if (!requireNamespace(package, quietly = TRUE)) stop("Install the ", package, " package before publishing.", call. = FALSE)
  }
  for (page in list.files(output, pattern = "\\.html$", recursive = TRUE, full.names = TRUE)) {
    href <- as.character(fs::path_rel(file.path(output, "exercises", "index.html"), start = dirname(page)))
    text <- rawToChar(readBin(page, "raw", n = file.info(page)$size))
    Encoding(text) <- "UTF-8"
    updated <- book_navigation_html(text, href)
    if (!identical(text, updated)) writeBin(charToRaw(enc2utf8(updated)), page)
  }
}
