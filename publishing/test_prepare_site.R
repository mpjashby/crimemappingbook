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
    publishing$write_text("fixture", file.path(directory, name))
  }
  publishing$write_text(paste0("Book editions ", config$base_url, config$current, "/"),
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
  testthat::expect_message(hook$post_render_main(), "Skipping publication")
})

testthat::test_that("pre-render hooks skip book-wide checks for partial renders", {
  hook <- new.env(parent = globalenv())
  sys.source("publishing/pre_render.R", envir = hook)
  withr::local_envvar(c(QUARTO_PROJECT_RENDER_ALL = ""))
  hook$system2 <- function(...) stop("Unexpected checker invocation")
  testthat::expect_message(hook$pre_render_main(), "Skipping book-wide")
})

testthat::test_that("full-render hooks run both source checks and stop on failure", {
  hook <- new.env(parent = globalenv())
  sys.source("publishing/pre_render.R", envir = hook)
  withr::local_envvar(c(QUARTO_PROJECT_RENDER_ALL = "1"))
  invoked <- character()
  hook$system2 <- function(command, args) { invoked <<- c(invoked, args); 0L }
  testthat::expect_message(hook$pre_render_main(), "Book-wide source checks passed")
  testthat::expect_length(invoked, 2L)
  testthat::expect_true(grepl("check_chapter_scripts.R", invoked[1L], fixed = TRUE))
  testthat::expect_true(grepl("check_book_labels.R", invoked[2L], fixed = TRUE))
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
