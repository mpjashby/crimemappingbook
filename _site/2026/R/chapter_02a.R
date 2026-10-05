# Load the R packages we need to analyse this data
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Download the data from a URL and store it in a local file
request("https://mpjashby.github.io/crimemappingdata/downtown_homicides.csv") |>
  req_perform(path = here("data", "raw", "downtown_homicides.csv"))

# Load the data into R
homicides <- read_csv(here("data", "raw", "downtown_homicides.csv"))

# Convert the data to a simple features object, which we can use in functions
# that work on spatial data
homicides_sf <- st_as_sf(
  homicides,
  coords = c("longitude", "latitude"),
  crs = "EPSG:4326"
)

# Transform the data coordinate reference system
homicides_sf_trans <- st_transform(homicides_sf, "EPSG:26967")

# Create the map
hotspot_map(
  homicides_sf_trans,
  basemap_type = "cartolight",
  colour = "orangered1",
  size = 4
)
