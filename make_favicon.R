# Create the favicon for GitHub issue #50.
# Run from the book workspace: Rscript make_favicon.R
# Adapted from make_cover_image.R: keep its Blues palette and rightward
# orienteering arrow, but omit the map detail and large outer margins.
# Do not source the cover script: this icon needs no data or font downloads.

required_packages <- c("ggspatial", "RColorBrewer", "ragg")
for (package in required_packages) {
  if (!requireNamespace(package, quietly = TRUE)) {
    stop("Install the required package: ", package, call. = FALSE)
  }
}

draw_favicon <- function(filename, size = 48) {
  blues <- RColorBrewer::brewer.pal(9, "Blues")

  ragg::agg_png(
    filename, width = size, height = size, units = "px",
    res = 72, background = "transparent"
  )
  on.exit(grDevices::dev.off())
  grid::grid.newpage()

  # A point-up regular hexagon, with a border that scales with the icon.
  grid::grid.polygon(
    x = c(0.5, 0.898, 0.898, 0.5, 0.102, 0.102),
    y = c(0.96, 0.73, 0.27, 0.04, 0.27, 0.73),
    gp = grid::gpar(fill = blues[3], col = blues[9], lwd = size / 16)
  )

  # Rotate the same arrow used in the cover logo to point right.
  # A pale outline separates it from the background at small sizes.
  grid::pushViewport(grid::viewport(
    x = 0.5, y = 0.5, width = 0.34, height = 0.66, angle = -90
  ))
  grid::grid.draw(ggspatial::north_arrow_orienteering(
    fill = rep(blues[9], 2), line_col = blues[1],
    line_width = size / 16, text_col = NA
  ))
  grid::grid.draw(ggspatial::north_arrow_orienteering(
    fill = rep(blues[9], 2), line_col = blues[9],
    line_width = size / 96, text_col = NA
  ))
  grid::popViewport()
}

if (!file.exists("_quarto.yml")) {
  stop("Run this script from the root of the book workspace.", call. = FALSE)
}

draw_favicon("images/favicon.png")
