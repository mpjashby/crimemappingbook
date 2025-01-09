# Load packages
pacman::p_load(hexSticker, showtext, sf, sfhotspot, tidyverse)

# Register custom font
font_add_google("Red Hat Display", "roboto")

# Load and wrangle bike theft data
bike_thefts <- read_csv("https://mpjashby.github.io/crimemappingdata/vancouver_thefts.csv.gz") |>
  janitor::clean_names() |>
  st_as_sf(coords = c("x", "y"), crs = "EPSG:32610") |>
  filter(type == "Theft of Bicycle")

# Create buffer around weighted centroid of the crime points
centroid_buffer1 <- bike_thefts |> centr::mean_center() |> sf::st_buffer(2000)
centroid_buffer2 <- bike_thefts |> centr::mean_center() |> sf::st_buffer(2000 * 2)

# Estimate density of bike thefts
bike_theft_density <- hotspot_kde(
  bike_thefts,
  grid = hotspot_grid(centroid_buffer2, cell_size = 200),
  bandwidth_adjust = 0.5,
  quiet = TRUE
)

hex_cover_image <- ggplot() +
  geom_sf(
    aes(fill = kde),
    data = st_intersection(bike_theft_density, centroid_buffer2),
    colour = RColorBrewer::brewer.pal(9, "Blues")[4],
    linewidth = 0.1
  ) +
  ggspatial::annotation_north_arrow(
    width = unit(0.25, "npc"),
    height = unit(0.6, "npc"),
    pad_x = unit(0.345, "npc"),
    pad_y = unit(0.19, "npc"),
    rotation = -90,
    style = ggspatial::north_arrow_orienteering(
      line_col = RColorBrewer::brewer.pal(9, "Blues")[1],
      line_width = 6,
      text_col = NA
    )
  ) +
  ggspatial::annotation_north_arrow(
    width = unit(0.25, "npc"),
    height = unit(0.6, "npc"),
    pad_x = unit(0.345, "npc"),
    pad_y = unit(0.19, "npc"),
    rotation = -90,
    style = ggspatial::north_arrow_orienteering(
      fill = rep(RColorBrewer::brewer.pal(9, "Blues")[9], times = 2),
      line_col = RColorBrewer::brewer.pal(9, "Blues")[9],
      line_width = 0.5,
      text_col = NA
    )
  ) +
  scale_fill_gradient(
    low = RColorBrewer::brewer.pal(9, "Blues")[3],
    high = RColorBrewer::brewer.pal(9, "Blues")[7],
    aesthetics = c("colour", "fill")
  ) +
  theme_void() +
  theme(legend.position = "none")

sticker(
  hex_cover_image,
  package = "",
  s_x = 1,
  s_y = 1,
  s_width = 2.2,
  s_height = 2.2,
  h_color = RColorBrewer::brewer.pal(9, "Blues")[9],
  h_size = 2.5,
  white_around_sticker = TRUE,
  filename = "images/hex_cover_image.png"
)


cover_image <- ggplot() +
  ggimage::geom_image(
    aes(x = 0, y = 0, image = image),
    data = tibble(x = 0, y = 0, image = here::here("images/hex_cover_image.png")),
    size = 0.75
  ) +
  theme_void()

ggsave("images/cover_image.png", plot = cover_image, width = 600, height = 600, units = "px")

