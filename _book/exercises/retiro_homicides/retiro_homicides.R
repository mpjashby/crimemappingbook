# Map recorded homicides in the Retiro neighbourhood of Buenos Aires in 2023.

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Download the original data and keep a local copy
request("https://mpjashby.github.io/crimemappingdata/retiro_homicides.csv") |>
  req_perform(path = here("data", "raw", "retiro_homicides.csv"))

# Read data
homicides <- here("data", "raw", "retiro_homicides.csv") |>
  read_csv()

# Convert longitude and latitude to a spatial object
homicides_sf <- st_as_sf(
  homicides,
  coords = c("longitud", "latitud"),
  crs = "EPSG:4326"
)

# Transform to a projected coordinate reference system suitable for Buenos Aires
homicides_sf_trans <- st_transform(homicides_sf, crs = "EPSG:5348")

# Display the map
hotspot_map(
  homicides_sf_trans,
  basemap_type = "cartolight",
  colour = "blue2",
  size = 3
)
