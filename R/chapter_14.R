# This script creates a combination of maps showing the sequence of shootings
# during the Hungerford massacre in 1987

# Load packages
pacman::p_load(ggrepel, ggspatial, here, httr2, patchwork, tidyverse)


# LOAD DATA --------------------------------------------------------------------

# Download the original shootings data
request(
  "https://mpjashby.github.io/crimemappingdata/hungerford_shootings.csv"
) |>
  req_perform(path = here("data", "raw", "hungerford_shootings.csv"))

# Load the local copy of the shootings data
hungerford_shootings <- here("data", "raw", "hungerford_shootings.csv") |>
  read_csv() |>
  arrange(order)


# PREPARE DATA -----------------------------------------------------------------

# Create dataset of lines joining shootings in sequence
hungerford_lines <- hungerford_shootings |>
  arrange(order) |>
  rename(x_end = easting, y_end = northing) |>
  mutate(x_start = lag(x_end), y_start = lag(y_end)) |>
  # Remove the first row, which contains missing values and which we don't need
  drop_na(x_start, y_start)


# MAKE COMPONENT MAPS ----------------------------------------------------------

# Create overview map showing all shooting locations
hungerford_map_overall <- ggplot() +
  annotation_map_tile(type = "cartolight", zoomin = 0, progress = "none") +
  geom_curve(
    aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
    data = hungerford_lines,
    arrow = arrow(length = unit(3, "mm"), type = "closed"),
    curvature = -0.2,
    colour = "darkorange4"
  ) +
  geom_point(
    aes(x = easting, y = northing),
    data = hungerford_shootings,
    shape = 21,
    colour = "white",
    fill = "darkorange4",
    size = 3
  ) +
  geom_label_repel(
    aes(x = easting, y = northing, label = order),
    data = filter(hungerford_shootings, order %in% 1:2),
    colour = "white",
    fill = "darkorange4",
    fontface = "bold",
    linewidth = 0
  ) +
  annotation_scale(style = "ticks", line_col = "grey40", text_col = "grey40") +
  scale_y_continuous(expand = expansion(2)) +
  coord_sf(crs = "EPSG:27700") +
  labs(title = "Shootings in Wiltshire") +
  theme_void() +
  theme(
    panel.border = element_rect(colour = "grey20", fill = NA),
    plot.title = element_text(margin = margin(b = -18))
  )

# Create detail map showing shooting locations in Hungerford town
hungerford_map_town <- ggplot() +
  annotation_map_tile(type = "cartolight", zoomin = 0, progress = "none") +
  geom_curve(
    aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
    data = slice(hungerford_lines, 3:n()),
    arrow = arrow(length = unit(3, "mm"), type = "closed"),
    curvature = -0.2,
    colour = "darkorange4"
  ) +
  geom_point(
    aes(x = easting, y = northing),
    data = slice(hungerford_shootings, 3:n()),
    shape = 21,
    colour = "white",
    fill = "darkorange4",
    size = 3
  ) +
  geom_label_repel(
    aes(x = easting, y = northing, label = order),
    data = slice(hungerford_shootings, 3:n()),
    colour = "white",
    fill = "darkorange4",
    fontface = "bold",
    linewidth = 0
  ) +
  annotation_scale(style = "ticks", line_col = "grey40", text_col = "grey40") +
  scale_x_continuous(expand = expansion(0.3)) +
  scale_y_continuous(expand = expansion(0.3)) +
  coord_sf(crs = "EPSG:27700") +
  labs(title = "Shootings in Hungerford town") +
  theme_void() +
  theme(
    panel.border = element_rect(colour = "grey20", fill = NA),
    plot.margin = margin(t = 12)
  )


# COMBINE AND SAVE MAPS --------------------------------------------------------

hungerford_map <- (hungerford_map_overall / hungerford_map_town) +
  plot_annotation(
    title = "Shootings during the Hungerford massacre",
    caption = "Data from the official report into the shootings",
    theme = theme(
      plot.caption = element_text(colour = "grey40", hjust = 0),
      plot.title = element_text(colour = "grey50", face = "bold", size = 14)
    )
  )

ggsave(
  here("output", "hungerford_map.jpg"),
  hungerford_map,
  width = 900 / 150,
  height = 900 / 150,
  dpi = 150
)
