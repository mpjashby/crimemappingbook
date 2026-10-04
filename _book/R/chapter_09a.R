# This script counts carjacking offences in each alcaldía in Mexico City in
# 2019 and produces a choropleth map of those counts.

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Download the raw data
request(
  "https://mpjashby.github.io/crimemappingdata/cdmx_car_jacking.gpkg"
) |>
  req_perform(path = here("data", "raw", "cdmx_car_jacking.gpkg"))

request(
  "https://mpjashby.github.io/crimemappingdata/cdmx_alcaldias.gpkg"
) |>
  req_perform(path = here("data", "raw", "cdmx_alcaldias.gpkg"))

# Load carjacking and alcaldía data
cdmx_car_jacking <- here("data", "raw", "cdmx_car_jacking.gpkg") |>
  read_sf()

cdmx_alcaldias <- here("data", "raw", "cdmx_alcaldias.gpkg") |>
  read_sf()

# Count carjacking offences in each alcaldía

car_jacking_counts <- hotspot_count(cdmx_car_jacking, grid = cdmx_alcaldias)

# Create a choropleth map of carjacking counts

car_jacking_map <- hotspot_map(
  car_jacking_counts,
  basemap_type = "cartolight",
  caption = "Carjacking data: Mexico City Attorney General's Office (2019)"
) +
  labs(title = "Carjacking offences in Mexico City, 2019")

car_jacking_map
