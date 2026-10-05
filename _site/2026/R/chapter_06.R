# This script produces a density map of bicycle thefts in Vancouver in 2020.

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Download the raw data to a local file
request(
  "https://mpjashby.github.io/crimemappingdata/vancouver_thefts.csv.gz"
) |>
  req_perform(path = here("data", "raw", "vancouver_thefts.csv.gz"))

# Download Vancouver neighbourhood boundaries
request(
  "https://mpjashby.github.io/crimemappingdata/vancouver_neighbourhoods.geojson"
) |>
  req_perform(
    path = here("data", "raw", "vancouver_neighbourhoods.geojson")
  )

# Load and wrangle bike theft data
thefts <- here("data", "raw", "vancouver_thefts.csv.gz") |>
  read_csv() |>
  janitor::clean_names() |>
  st_as_sf(coords = c("x", "y"), crs = "EPSG:32610")

bike_thefts <- filter(thefts, type == "Theft of Bicycle")

# Load Vancouver neighbourhood boundaries
vancouver_nbhds <- here("data", "raw", "vancouver_neighbourhoods.geojson") |>
  read_sf() |>
  st_transform("EPSG:32610")

# Estimate density of bike thefts and clip the result
bike_theft_density_clip <- bike_thefts |>
  hotspot_kde(
    grid = hotspot_grid(vancouver_nbhds, quiet = TRUE),
    bandwidth_adjust = 0.5,
    quiet = TRUE
  ) |>
  hotspot_clip(vancouver_nbhds)

# Plot density map
hotspot_map(bike_theft_density_clip, basemap_type = "cartolight") +
  # Add neighbourhood boundaries
  geom_sf(data = vancouver_nbhds, colour = "seagreen3", fill = NA) +
  # Add neighbourhood names
  geom_sf_label(
    aes(label = str_wrap(name, 10)),
    data = vancouver_nbhds,
    alpha = 0.5,
    colour = "seagreen",
    fill = "white",
    lineheight = 1,
    size = 2.5,
    linewidth = NA
  )
