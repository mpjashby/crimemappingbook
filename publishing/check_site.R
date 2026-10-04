# Check edition assets and optionally exercise a running Apache website.
# Run from the repository root: Rscript publishing/check_site.R --help
source("publishing/prepare_site.R", local = TRUE)

# Resolve existing symlinks, and normalise missing paths without requiring them to exist.
normal_file_path <- function(path) {
  if (file.exists(path)) as.character(fs::path_real(path)) else as.character(fs::path_norm(fs::path_abs(path)))
}

path_inside <- function(path, directory) {
  path <- normal_file_path(path)
  directory <- normal_file_path(directory)
  path == directory || startsWith(path, paste0(directory, "/"))
}

check_site_files <- function(output, config) {
  require_publishing_packages(c("fs", "jsonlite", "xml2"))
  problems <- character()
  base <- config$base_url
  site_path <- sub("^https://[^/]+", "", base)
  for (year in names(config$editions)) {
    edition <- file.path(output, year)
    if (!dir.exists(edition)) {
      problems <- c(problems, paste0(year, ": no edition directory"))
      next
    }
    pages <- fs::dir_ls(edition, recurse = TRUE, glob = "*.html")
    if (!length(pages)) problems <- c(problems, paste0(year, ": no HTML pages"))
    for (page in pages) {
      text <- read_text(page)
      if (grepl('id="quarto-header"', text, fixed = TRUE)) {
        matches <- gregexpr('id="book-archive-notice"', text, fixed = TRUE)[[1]]
        count <- if (matches[1L] < 0L) 0L else length(matches)
        expected <- if (year == config$current) 0L else 1L
        if (count != expected) problems <- c(problems, paste0(page, ": incorrect archive notice count"))
        canonical <- paste0(base, year, "/", fs::path_rel(page, edition))
        if (!grepl(paste0('<link rel="canonical" href="', canonical, '">'), text, fixed = TRUE)) {
          problems <- c(problems, paste0(page, ": missing year-specific canonical URL"))
        }
      }
      document <- xml2::read_html(text, options = c("RECOVER", "NOERROR", "NOWARNING", "HUGE"))
      references <- xml2::xml_find_all(document,
        "//*[self::a or self::link or self::img or self::script or self::iframe or self::source]/@href | //*[self::a or self::link or self::img or self::script or self::iframe or self::source]/@src")
      for (reference in xml2::xml_text(references)) {
        path <- sub("[?#].*$", "", reference)
        if (startsWith(reference, base)) {
          target <- file.path(output, utils::URLdecode(substring(path, nchar(base) + 1L)))
        } else if (!nzchar(path) || grepl("^[A-Za-z][A-Za-z0-9+.-]*:|^//", path)) {
          next
        } else if (startsWith(path, "/")) {
          if (!startsWith(path, site_path)) next
          target <- file.path(output, utils::URLdecode(substring(path, nchar(site_path) + 1L)))
        } else {
          target <- file.path(dirname(page), utils::URLdecode(path))
          if (!path_inside(target, edition)) {
            problems <- c(problems, paste0(fs::path_rel(page, output), ": link escapes edition: ", reference))
            next
          }
        }
        if (dir.exists(target)) target <- file.path(target, "index.html")
        # The website root redirects, so it needs no physical index.html.
        if (normal_file_path(target) == normal_file_path(file.path(output, "index.html"))) next
        if (!file.exists(target)) {
          problems <- c(problems, paste0(fs::path_rel(page, output), ": missing ", reference))
        }
      }
    }
    home <- file.path(edition, "index.html")
    if (!file.exists(home) || !grepl("Book editions", read_text(home), fixed = TRUE)) {
      problems <- c(problems, paste0(year, ": home-page edition links missing"))
    }
    search <- file.path(edition, "search.json")
    if (!file.exists(search)) {
      problems <- c(problems, paste0(year, ": missing search index"))
    } else {
      results <- jsonlite::fromJSON(search, simplifyVector = FALSE)
      for (result in results) {
        href <- result$href
        if (!is.null(href) && nzchar(href)) {
          path <- utils::URLdecode(sub("[?#].*$", "", href))
          if (!path_inside(file.path(edition, path), edition) || !file.exists(file.path(edition, path))) {
            problems <- c(problems, paste0(year, ": missing search target ", href))
          }
        }
      }
    }
    message(year, ": checked ", length(pages), " HTML pages and search index")
  }
  llms <- file.path(output, config$current, "llms.txt")
  if (!file.exists(llms)) {
    problems <- c(problems, "Current edition is missing llms.txt; run Rscript generate_llms.R")
  } else if (!grepl(paste0(base, config$current, "/"), read_text(llms), fixed = TRUE)) {
    problems <- c(problems, "llms.txt lacks year-specific URLs")
  }
  problems
}

http_cases <- function(config) {
  current <- config$current
  paths <- c("", "07_map_context/?test=1", "13_crime_series/index.html",
             "05_code_with_style/", "04_code_with_style/", "04_your_second_crime_map/",
             "15_no_maps/", "16_mapping_time/", "08_projects/", "00_setup/",
             "resources/template.R", "space%20name.html",
             "2099/", "1999/", "2025/not-a-page.html", paste0(current, "/not-a-page.html"),
             paste0(current, "/code_with_style.html"), paste0(current, "/llms.txt"),
             "2025/05_code_with_style/", "2024/04_code_with_style/",
             "2025/14_writing_reports/images/rstudio-markdown-preview.png")
  destinations <- c("", "07_map_context/?test=1", "16_crime_series/index.html",
                    "code_with_style.html", "code_with_style.html", "05_your_second_crime_map/",
                    "14_no_maps/", "15_mapping_time/", "01_getting_started/", "setup.html",
                    "resources/templates/crime_mapping_script.R", "space%20name.html")
  redirects <- c(paste0(current, "/", destinations), rep(NA_character_, length(paths) - length(destinations)))
  cases <- data.frame(path = paths, status = c(rep(302L, 12L), rep(404L, 4L), rep(200L, 5L)),
                      redirect = redirects)
  rbind(cases, data.frame(path = paste0(names(config$editions), "/"), status = 200L, redirect = NA_character_),
        data.frame(path = paste0(names(config$editions), "/search.json"), status = 200L, redirect = NA_character_))
}

check_site_http <- function(base, config) {
  require_publishing_packages("httr2")
  if (!grepl("^https?://[^?#]+/$", base)) publishing_fail("--base-url must be an HTTP(S) URL ending in /")
  problems <- character()
  cases <- http_cases(config)
  for (i in seq_len(nrow(cases))) {
    case <- cases[i, ]
    request <- httr2::request(paste0(base, case$path)) |>
      httr2::req_timeout(10) |>
      httr2::req_options(followlocation = FALSE) |>
      httr2::req_error(is_error = function(response) FALSE)
    response <- httr2::req_perform(request)
    status <- httr2::resp_status(response)
    if (status != case$status) {
      problems <- c(problems, paste0(case$path, ": HTTP ", status, ", expected ", case$status))
    }
    if (!is.na(case$redirect)) {
      location <- httr2::resp_header(response, "Location")
      if (!identical(location, paste0(base, case$redirect))) {
        problems <- c(problems, paste0(case$path, ": wrong redirect ", location))
      }
      if (!identical(httr2::resp_header(response, "Cache-Control"), "no-store")) {
        problems <- c(problems, paste0(case$path, ": moving redirect is cacheable"))
      }
    }
    if (case$status == 404L && !grepl("Page not found", httr2::resp_body_string(response), fixed = TRUE)) {
      problems <- c(problems, paste0(case$path, ": missing helpful 404 page"))
    }
  }
  message("Checked ", nrow(cases), " Apache requests")
  problems
}

check_site_main <- function(args = commandArgs(trailingOnly = TRUE)) {
  options <- parse_publishing_args(args, "--help", c("--output", "--base-url"), list(output = "_site"))
  if (isTRUE(options$help)) {
    cat("Usage: Rscript publishing/check_site.R [--output DIR] [--base-url URL]\n",
        "Run from the book root. Requires jsonlite, fs, xml2 and httr2 (for HTTP checks).\n", sep = "")
    return(invisible(NULL))
  }
  config <- load_manifest()
  problems <- check_site_files(options$output, config)
  if (!is.null(options[["base-url"]])) problems <- c(problems, check_site_http(options[["base-url"]], config))
  if (length(problems)) publishing_fail(paste(problems, collapse = "\n"))
  message("Edition checks passed")
}

if (sys.nframe() == 0L) check_site_main()
