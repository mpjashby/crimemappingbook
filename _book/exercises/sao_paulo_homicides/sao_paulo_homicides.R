# This script creates a density map of homicides in São Paulo, Brazil, from 2021
# to 2022

# Load packages ----
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)


# Load data ----

# Download the original data into the workspace
request(
  "https://mpjashby.github.io/crimemappingdata/sao_paulo_homicides.xlsx"
) |>
  req_perform(path = here("data", "raw", "sao_paulo_homicides.xlsx"))
request("https://mpjashby.github.io/crimemappingdata/sao_paulo_muni.geojson") |>
  req_perform(path = here("data", "raw", "sao_paulo_muni.geojson"))

homicides <- here("data", "raw", "sao_paulo_homicides.xlsx") |>
  # Read Excel file -- there is only one sheet so we won't need to specify
  readxl::read_excel() |>
  # Convert names to snake_case
  janitor::clean_names() |>
  # Keep only homicides in 2021 and 2022
  filter(between(year, 2021, 2022)) |>
  # Convert to an SF object
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  # Convert to a CRS that uses metres
  st_transform("EPSG:5538")

# Load boundary data
muni <- here("data", "raw", "sao_paulo_muni.geojson") |>
  read_sf() |>
  # Convert names to snake_case
  janitor::clean_names() |>
  # Convert to a CRS that uses metres
  st_transform("EPSG:5538")


# Wrangle data ----

# Create KDE layer
homicides_kde <- homicides |>
  # Estimate density of homicides. São Paulo is very large, so use a larger
  # cell size than for most cities.
  hotspot_kde(
    grid = hotspot_grid(muni, cell_size = 1000, grid_type = "hex"),
    bandwidth_adjust = 0.33,
    quiet = TRUE
  ) |>
  # Clip the density layer to the area for which we have data
  hotspot_clip(muni, quiet = TRUE)


# Map data ----

# Create map
homicide_map <- hotspot_map(
  homicides_kde,
  basemap_type = "cartolight",
  caption = str_glue(
    "Homicides: State of São Paulo Public Security Secretariat\n",
    "Boundaries: Institute for Applied Economic Research"
  )
) +
  geom_sf(data = muni, colour = "grey50", fill = NA) +
  labs(
    title = "Density of recorded homicides in the São Paulo immediate region",
    subtitle = "Homicides recorded by police, 2021-2022",
    fill = "density of homicides"
  ) +
  # Remove unnecessary map elements
  theme(
    # Put a box around the legend to make it easier to read
    legend.background = element_rect(colour = NA, fill = "grey98"),
    # Since the map is wider than it is tall, change the legend to correspond
    legend.direction = "horizontal",
    # Make the legend expand relative to its top-right corner
    legend.justification = c(1, 1),
    # Add some space around the legend to make it easier to read
    legend.margin = margin(6, 12, 6, 6),
    # Move the legend inside the map area
    legend.position = "inside",
    # Position the legend in the top-right corner of the map
    legend.position.inside = c(0.98, 0.98)
  )

# Save map
ggsave(
  filename = here("output", "sao_paulo_homicide_2021_22.jpg"),
  plot = homicide_map,
  width = 297,
  height = 210,
  units = "mm"
)
