# This script produces a map of bicycle thefts in Vancouver in 2020.

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Download the raw data to a local file
request(
  "https://mpjashby.github.io/crimemappingdata/vancouver_thefts.csv.gz"
) |>
  req_perform(path = here("data", "raw", "vancouver_thefts.csv.gz"))

# Load and wrangle bike theft data
thefts <- here("data", "raw", "vancouver_thefts.csv.gz") |>
  read_csv() |>
  janitor::clean_names() |>
  st_as_sf(coords = c("x", "y"), crs = "EPSG:32610")

bike_thefts <- filter(thefts, type == "Theft of Bicycle")

# Create a basic crime map
hotspot_map(bike_thefts, basemap_type = "cartolight", size = 0.7, alpha = 0.1)
