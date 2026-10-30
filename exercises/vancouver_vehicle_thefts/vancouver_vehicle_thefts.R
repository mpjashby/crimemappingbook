# This script produces a dot map of thefts from vehicles in Vancouver in 2020

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Download the original data and keep a local copy
request(
  "https://mpjashby.github.io/crimemappingdata/vancouver_thefts.csv.gz"
) |>
  req_perform(path = here("data", "raw", "vancouver_thefts.csv.gz"))

# Read and wrangle data
thefts_from_vehicles <- here("data", "raw", "vancouver_thefts.csv.gz") |>
  read_csv() |>
  # Convert column names to snake-case
  janitor::clean_names() |>
  # Convert object to an object that understands each row represents a location
  # on the Earth's surface
  st_as_sf(coords = c("x", "y"), crs = "EPSG:32610") |>
  # Keep only the rows in the dataset relating to thefts from vehicles
  filter(type == "Theft from Vehicle")

# Create a dot map of thefts from vehicles
hotspot_map(
  thefts_from_vehicles,
  basemap_type = "cartodark",
  alpha = 0.25,
  colour = "orange3",
  size = 0.33
)
