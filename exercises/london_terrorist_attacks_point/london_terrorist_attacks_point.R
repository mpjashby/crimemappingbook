# Map recorded fatal terrorist attacks in London from 2010 to 2018.

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Download the original data and keep a local copy
request("https://mpjashby.github.io/crimemappingdata/london_attacks.csv") |>
  req_perform(path = here("data", "raw", "london_attacks.csv")) |>
  # Stop `req_perform()` print a message to the console
  invisible()

# Read data
attacks <- read_csv(here("data", "raw", "london_attacks.csv"))

# Keep only records within the requested date range, including both ends
attacks_filtered <- filter(attacks, date >= "2010-01-01", date <= "2018-12-31")

# Convert longitude and latitude to a spatial object
attacks_sf <- st_as_sf(
  attacks_filtered,
  coords = c("longitude", "latitude"),
  crs = "EPSG:4326"
)

# Transform to a projected coordinate reference system suitable for London
attacks_sf_trans <- st_transform(attacks_sf, crs = "EPSG:27700")

# Display the map
hotspot_map(
  attacks_sf_trans,
  basemap_type = "cartolight",
  colour = "red2",
  size = 5
)
