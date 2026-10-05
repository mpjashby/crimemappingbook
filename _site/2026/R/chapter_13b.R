# This script produces a map of significant robbery hotspots in Nottingham,
# England

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# LOAD DATA --------------------------------------------------------------------

# Download the original data
request(
  "https://mpjashby.github.io/crimemappingdata/nottingham_robbery.csv.gz"
) |>
  req_perform(path = here("data", "raw", "nottingham_robbery.csv.gz"))

request(
  "https://mpjashby.github.io/crimemappingdata/nottingham_wards.gpkg"
) |>
  req_perform(path = here("data", "raw", "nottingham_wards.gpkg"))

# Load data and transform to British National Grid so distances are in metres
robbery <- here("data", "raw", "nottingham_robbery.csv.gz") |>
  read_csv() |>
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  st_transform("EPSG:27700")
nottingham_wards <- here("data", "raw", "nottingham_wards.gpkg") |>
  read_sf() |>
  st_transform("EPSG:27700")


# FIND HOTSPOTS ----------------------------------------------------------------

# Calculate Gi* statistic
robbery_gistar <- robbery |>
  hotspot_gistar(cell_size = 100, bandwidth_adjust = 0.25, quiet = TRUE) |>
  filter(gistar > 0, pvalue < 0.05) |>
  hotspot_clip(nottingham_wards)

# PLOT MAP ---------------------------------------------------------------------

hotspot_map(
  robbery_gistar,
  basemap_type = "cartolight",
  sign = "hot",
  caption = str_glue(
    "Contains public sector information licensed under the Open ",
    "Government Licence v3.0."
  )
) +
  # Add ward boundaries
  geom_sf(data = nottingham_wards, colour = "grey70", fill = NA) +
  labs(title = "Nottingham robbery hotspots")
