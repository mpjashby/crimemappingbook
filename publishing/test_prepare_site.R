# Regression checks for edition boundaries and archive preparation.
# Run from the repository root: Rscript publishing/test_prepare_site.R
if (!requireNamespace("testthat", quietly = TRUE)) {
  stop('Install the test dependency with install.packages("testthat").', call. = FALSE)
}

publishing <- new.env(parent = globalenv())
sys.source("publishing/prepare_site.R", envir = publishing)
config <- publishing$load_manifest()
page <- paste0('<html><head></head><body><header id="quarto-header" class="fixed-top"></header>',
               '<main><p>Introduction</p><section id="who-is-this-book-for">Readers</section>',
               '<a href="https://books.lesscrime.info/learncrimemapping/07_map_context/">Context</a>',
               '<script>const literal = "<div>do not alter</div>";</script></main></body></html>')

# Make a small tar fixture directly in R, allowing unsafe names and link types
# that ordinary archive writers rightly refuse to create.
write_tar_fixture <- function(path, name, type = "0", link = "") {
  header <- rep(as.raw(0L), 512L)
  put <- function(offset, text) {
    bytes <- charToRaw(text)
    header[offset + seq_along(bytes) - 1L] <<- bytes
  }
  put(1L, name)
  put(101L, "0000644")
  put(109L, "0000000")
  put(117L, "0000000")
  put(125L, "00000000000")
  put(137L, "00000000000")
  put(149L, "        ")
  put(157L, type)
  if (nzchar(link)) put(158L, link)
  put(258L, "ustar")
  put(264L, "00")
  put(149L, sprintf("%06o", sum(as.integer(header))))
  header[155L] <- as.raw(0L)
  header[156L] <- charToRaw(" ")
  connection <- gzfile(path, "wb")
  on.exit(close(connection))
  writeBin(c(header, rep(as.raw(0L), 1024L)), connection)
}

make_current_fixture <- function(directory) {
  dir.create(directory)
  for (name in publishing$required_current_files()) {
    publishing$write_text("<p>fixture</p>", file.path(directory, name))
  }
  publishing$write_text(paste0("<p>Book editions ", config$base_url, config$current, "/</p>"),
                         file.path(directory, "index.html"))
}

testthat::test_that("repeat injection preserves edition boundaries and embedded scripts", {
  once <- publishing$archive_page(page, config, "2025", "index.html")
  twice <- publishing$archive_page(once, config, "2025", "index.html")
  testthat::expect_identical(once, twice)
  testthat::expect_length(gregexpr('id="book-archive-notice"', once, fixed = TRUE)[[1]], 1L)
  testthat::expect_length(gregexpr('id="book-editions"', once, fixed = TRUE)[[1]], 1L)
  testthat::expect_match(once, '2025/07_map_context/', fixed = TRUE)
  testthat::expect_match(once, paste0('href="', config$base_url, '">Read the current edition'), fixed = TRUE)
  testthat::expect_match(once, '2024/">2024 edition', fixed = TRUE)
  testthat::expect_match(once, 'const literal = "<div>do not alter</div>";', fixed = TRUE)
  testthat::expect_lt(regexpr('id="book-editions"', once, fixed = TRUE)[1],
                       regexpr('<section id="who-is-this-book-for"', once, fixed = TRUE)[1])
})

testthat::test_that("nested assets work and standalone reports are untouched", {
  nested <- publishing$archive_page(page, config, "2024", "chapter/index.html")
  testthat::expect_match(nested, 'href="../archive-notice.css"', fixed = TRUE)
  report <- sub('id="quarto-header"', 'id="report-header"', page, fixed = TRUE)
  testthat::expect_identical(report, publishing$archive_page(report, config, "2024", "resources/report.html"))
})

testthat::test_that("an annual switch updates yearless routing and edition links", {
  next_config <- config
  next_config$current <- "2027"
  next_config$editions[["2027"]] <- list()
  routes <- publishing$root_htaccess(next_config)
  testthat::expect_match(routes, "2027/$1 [R=302,END]", fixed = TRUE)
  testthat::expect_false(grepl("R=301", routes, fixed = TRUE))
  testthat::expect_match(routes, 'Cache-Control "no-store"', fixed = TRUE)
  testthat::expect_lt(regexpr("^[0-9]{4}", routes, fixed = TRUE)[1],
                       regexpr("^10_place_data", routes, fixed = TRUE)[1])
  testthat::expect_match(publishing$include_text(next_config), "2027 edition</a> (current)", fixed = TRUE)
})

testthat::test_that("unavailable downloads are removed", {
  fixture <- sub('</main>', '<a href="../learn_crime_mapping_with_r.epub" aria-label="Download ePub"><i></i></a></main>',
                 page, fixed = TRUE)
  result <- publishing$archive_page(fixture, config, "2024", "chapter/index.html")
  testthat::expect_false(grepl('href="../learn_crime_mapping_with_r.epub"', result, fixed = TRUE))
  testthat::expect_match(result, 'id="book-archive-notice"', fixed = TRUE)
})

testthat::test_that("archive extraction rejects traversal and link entries before writing", {
  temporary <- tempfile("edition-test-")
  dir.create(temporary)
  archive <- file.path(temporary, "snapshot.tar.gz")
  write_tar_fixture(archive, "repo/_book/../../escape.html")
  testthat::expect_error(publishing$extract_book(archive, file.path(temporary, "out")), "Unsafe archive path")
  testthat::expect_false(file.exists(file.path(temporary, "escape.html")))
  for (type in c("1", "2")) {
    write_tar_fixture(archive, "repo/_book/link", type, "../../outside")
    testthat::expect_error(publishing$extract_book(archive, file.path(temporary, "out")), "Unsupported archive entry")
  }
  testthat::expect_false(dir.exists(file.path(temporary, "out")))
  unlink(temporary, recursive = TRUE)
})

testthat::test_that("assembly refuses to overwrite an unrelated directory", {
  temporary <- tempfile("edition-test-")
  dir.create(temporary)
  book <- file.path(temporary, "book")
  make_current_fixture(book)
  output <- file.path(temporary, "unowned")
  dir.create(output)
  publishing$write_text("keep me", file.path(output, "existing.txt"))
  testthat::expect_error(publishing$assemble_site(config, book, output, file.path(temporary, "cache")), "unmarked")
  testthat::expect_identical(publishing$read_text(file.path(output, "existing.txt")), "keep me")
  unlink(temporary, recursive = TRUE)
})

testthat::test_that("a failed archive preparation preserves existing generated output", {
  temporary <- tempfile("edition-test-")
  dir.create(temporary)
  book <- file.path(temporary, "book")
  make_current_fixture(book)
  output <- file.path(temporary, "site")
  publishing$write_text("generated", file.path(output, ".edition-site"))
  publishing$write_text("keep me", file.path(output, "existing.txt"))
  cache <- file.path(temporary, "cache")
  commit <- config$editions[["2025"]]$commit
  publishing$write_text("corrupt snapshot", file.path(cache, paste0(commit, ".tar.gz")))
  publishing$write_text("incorrect checksum", file.path(cache, paste0(commit, ".tar.sha256")))
  testthat::expect_error(publishing$assemble_site(config, book, output, cache), "checksum mismatch")
  testthat::expect_identical(publishing$read_text(file.path(output, "existing.txt")), "keep me")
  testthat::expect_false(file.exists(paste0(output, ".previous")))
  testthat::expect_length(list.files(temporary, pattern = "^\\.edition-site-", all.files = TRUE), 0L)
  unlink(temporary, recursive = TRUE)
})

testthat::test_that("argument parsing rejects missing, unknown and repeated values", {
  testthat::expect_error(publishing$parse_publishing_args("--output", character(), "--output"), "Missing value")
  testthat::expect_error(publishing$parse_publishing_args("--unknown", character(), character()), "Unknown argument")
  testthat::expect_error(publishing$parse_publishing_args(c("--output=a", "--output=b"), character(), "--output"), "only once")
  testthat::expect_identical(publishing$parse_publishing_args(c("--output", "a b"), character(), "--output")$output, "a b")
})

testthat::test_that("partial render hooks do not run publication preparation", {
  hook <- new.env(parent = globalenv())
  sys.source("publishing/post_render.R", envir = hook)
  withr::local_envvar(c(QUARTO_PROJECT_RENDER_ALL = ""))
  hook$update_book_navigation <- function(output) invisible(NULL)
  testthat::expect_message(hook$post_render_main(), "Skipping publication")
})

testthat::test_that("pre-render hooks skip book-wide checks for partial renders", {
  hook <- new.env(parent = globalenv())
  sys.source("publishing/pre_render.R", envir = hook)
  withr::local_envvar(c(QUARTO_PROJECT_RENDER_ALL = ""))
  hook$system2 <- function(...) stop("Unexpected checker invocation")
  testthat::expect_message(hook$pre_render_main(), "Skipping book-wide")
})

testthat::test_that("full-render hooks run all source checks and stop on failure", {
  hook <- new.env(parent = globalenv())
  sys.source("publishing/pre_render.R", envir = hook)
  withr::local_envvar(c(QUARTO_PROJECT_RENDER_ALL = "1"))
  invoked <- character()
  hook$system2 <- function(command, args) { invoked <<- c(invoked, args); 0L }
  testthat::expect_message(hook$pre_render_main(), "Book-wide source checks passed")
  testthat::expect_length(invoked, 3L)
  testthat::expect_true(grepl("check_chapter_scripts.R", invoked[1L], fixed = TRUE))
  testthat::expect_true(grepl("check_book_labels.R", invoked[2L], fixed = TRUE))
  testthat::expect_true(grepl("check_code_library.R", invoked[3L], fixed = TRUE))
  invoked <- character()
  hook$system2 <- function(command, args) { invoked <<- c(invoked, args); 1L }
  testthat::expect_error(hook$pre_render_main(), "Source check failed")
  testthat::expect_length(invoked, 1L)
})

testthat::test_that("post-render hooks accept Quarto's absolute output paths", {
  hook <- new.env(parent = globalenv())
  sys.source("publishing/post_render.R", envir = hook)
  root <- tempfile("hook-project-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE))
  dir.create(file.path(root, "rendered book"))
  testthat::expect_identical(hook$post_render_output(file.path(root, "rendered book"), root), "rendered book")
  testthat::expect_identical(hook$post_render_output("rendered book", root), "rendered book")
  testthat::expect_error(hook$post_render_output(dirname(root), root), "inside the book project")
})

testthat::test_that("exercise publishing replaces stale output with the rendered mini-site", {
  hook <- new.env(parent = globalenv())
  sys.source("publishing/post_render.R", envir = hook)
  temporary <- tempfile("exercise-publishing-")
  dir.create(temporary)
  withr::local_dir(temporary)
  withr::defer(unlink(temporary, recursive = TRUE))
  publishing$write_text("exercise home", "exercises/_site/index.html")
  publishing$write_text("script", "exercises/_site/example/example.R")
  publishing$write_text("private download", "exercises/data/raw/private.csv")
  publishing$write_text("obsolete", "rendered book/exercises/obsolete.html")
  invoked <- NULL
  hook$Sys.which <- function(...) "quarto"
  hook$system2 <- function(command, args) { invoked <<- c(command, args); 0L }
  hook$publish_exercises("rendered book")
  testthat::expect_identical(invoked, c("quarto", "render", "exercises"))
  testthat::expect_identical(publishing$read_text("rendered book/exercises/index.html"), "exercise home")
  testthat::expect_true(file.exists("rendered book/exercises/example/example.R"))
  testthat::expect_false(file.exists("rendered book/exercises/obsolete.html"))
  testthat::expect_false(dir.exists("rendered book/exercises/data"))
  testthat::expect_true(dir.exists("exercises/output"))
  hook$system2 <- function(...) 1L
  testthat::expect_error(hook$publish_exercises("rendered book"), "Exercise render failed")
  testthat::expect_identical(publishing$read_text("rendered book/exercises/index.html"), "exercise home")
})

testthat::test_that("assembly refuses an edition missing an exercise download", {
  temporary <- tempfile("exercise-required-")
  dir.create(temporary)
  on.exit(unlink(temporary, recursive = TRUE), add = TRUE)
  book <- file.path(temporary, "book")
  make_current_fixture(book)
  download <- "exercises/new_york_shootings/new_york_shootings.R"
  testthat::expect_true(download %in% publishing$required_current_files())
  unlink(file.path(book, download))
  testthat::expect_error(
    publishing$assemble_site(config, book, file.path(temporary, "site"), file.path(temporary, "cache")),
    "new_york_shootings.R", fixed = TRUE
  )
})

testthat::test_that("exercise search targets and yearless setup links are checked", {
  checker <- new.env(parent = globalenv())
  sys.source("publishing/check_site.R", envir = checker)
  temporary <- tempfile("exercise-links-")
  dir.create(temporary)
  on.exit(unlink(temporary, recursive = TRUE), add = TRUE)
  current <- config
  current$editions <- config$editions[config$current]
  edition <- file.path(temporary, config$current)
  make_current_fixture(edition)
  publishing$write_text("[]", file.path(edition, "search.json"))
  publishing$write_text("[]", file.path(edition, "exercises/search.json"))
  publishing$write_text(paste0(config$base_url, config$current, "/"), file.path(edition, "llms.txt"))
  publishing$write_text(paste0('<a href="', config$base_url, 'setup.html">Setup</a>'),
                         file.path(edition, "exercises/index.html"))
  testthat::expect_length(checker$check_site_files(temporary, current), 0L)
  publishing$write_text('[{"href":"missing.html"}]', file.path(edition, "exercises/search.json"))
  testthat::expect_true(any(grepl("missing search target missing.html", checker$check_site_files(temporary, current), fixed = TRUE)))
})

testthat::test_that("Exercises is a top-level menu item after Appendices and repeated updates are stable", {
  fixture <- paste0('<html><head></head><body><nav id="quarto-sidebar">',
    '<div class="sidebar-menu-container"><ul>',
    '<li class="sidebar-item sidebar-item-section"><div><a><span class="menu-text">Appendices</span></a></div>',
    '<ul><li><a href="appendix.html">An appendix</a></li></ul></li>',
    '</ul></div><div class="quarto-sidebar-footer"><div class="sidebar-footer-item">',
    '<p><a href="old-exercises/">Exercises</a></p></div></div></nav>',
    '<main>Chapter content</main><script>const literal = "<div>keep this</div>";</script></body></html>')
  href <- paste0(config$base_url, config$current, "/exercises/")
  updated <- publishing$book_navigation_html(fixture, href)
  document <- xml2::read_html(updated)
  item <- xml2::xml_find_all(document,
    "//nav/div[@class='sidebar-menu-container']/ul/li[@id='book-exercises-link']")
  testthat::expect_length(item, 1L)
  testthat::expect_identical(xml2::xml_text(xml2::xml_find_first(item, "preceding-sibling::li[1]/div/a/span")), "Appendices")
  testthat::expect_identical(xml2::xml_attr(xml2::xml_find_first(item, ".//a"), "href"), href)
  testthat::expect_length(xml2::xml_find_all(document, "//nav//a[normalize-space(.)='Exercises']"), 1L)
  testthat::expect_length(xml2::xml_find_all(document, "//div[@class='quarto-sidebar-footer']"), 0L)
  testthat::expect_identical(publishing$book_navigation_html(updated, href), updated)
  testthat::expect_match(updated, '<script>const literal = "<div>keep this</div>";</script>', fixed = TRUE)
  testthat::expect_identical(publishing$book_navigation_html(page, href), page)
})

testthat::test_that("exercise navigation resolves locally at every book directory depth", {
  temporary <- tempfile("relative-navigation-")
  dir.create(temporary)
  on.exit(unlink(temporary, recursive = TRUE), add = TRUE)
  fixture <- paste0('<nav id="quarto-sidebar"><div class="sidebar-menu-container"><ul>',
    '<li><div><a><span>Appendices</span></a></div></li></ul></div></nav>')
  pages <- c("index.html", "chapter/index.html", "appendices/checklist.html", "deep/chapter/index.html")
  expected <- c("exercises/index.html", "../exercises/index.html", "../exercises/index.html", "../../exercises/index.html")
  for (page in pages) publishing$write_text(fixture, file.path(temporary, page))
  target <- file.path(temporary, "exercises/index.html")
  publishing$write_text("<p>Exercises</p>", target)
  publishing$update_book_navigation(temporary)
  for (i in seq_along(pages)) {
    page <- file.path(temporary, pages[i])
    document <- xml2::read_html(page)
    link <- xml2::xml_attr(xml2::xml_find_first(document, "//*[@id='book-exercises-link']//a"), "href")
    testthat::expect_identical(link, expected[i])
    testthat::expect_identical(normalizePath(file.path(dirname(page), link)), normalizePath(target))
  }
})
