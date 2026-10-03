# This script produces a map of the density of homicides in the La Candelaria
# area of Medellin, Colombia, together with bus stops in or near the area

# Load packages
pacman::p_load(here, httr2, osmdata, sf, sfhotspot, tidyverse)

# LOAD DATA --------------------------------------------------------------------

## Load Medellin homicide data ----
# Download the original data
request(
  "https://mpjashby.github.io/crimemappingdata/medellin_homicides.csv"
) |>
  req_perform(path = here("data", "raw", "medellin_homicides.csv"))

# Note: this dataset uses ';' as the column separator
medellin_homicides <- here("data", "raw", "medellin_homicides.csv") |>
  read_csv2() |>
  # Remove rows with missing coordinates
  drop_na(longitud, latitud) |>
  # Convert the data to an SF object
  st_as_sf(coords = c("longitud", "latitud"), crs = "EPSG:4326")

## Load metro lines ----

# Download zip file
metro_lines_file <- here("data", "raw", "medellin_metro_lines.zip")
request(

  "https://mpjashby.github.io/crimemappingdata/medellin_metro_lines.zip"
) |>
  req_perform(path = metro_lines_file)

# Unzip the files into a named directory
metro_lines_dir <- here("data", "processed", "medellin_metro_lines")
unzip(metro_lines_file, exdir = metro_lines_dir)
# Load the data
metro_lines <- here(metro_lines_dir, "medellin_metro_lines.shp") |>
  read_sf()

## Load neighbourhood boundary ----
request(
  "https://mpjashby.github.io/crimemappingdata/medellin_comunas.gpkg"
) |>
  req_perform(path = here("data", "raw", "medellin_comunas.gpkg"))

medellin_comunas <- here("data", "raw", "medellin_comunas.gpkg") |>
  read_sf() |>
  janitor::clean_names()

# GET OSM DATA -----------------------------------------------------------------

# Calculate neighbourhood bounding box
la_candelaria_bbox <- medellin_comunas |>
  filter(nombre == "LA CANDELARIA") |>
  st_bbox()

# Define the bounding box of the area we want to search
bus_stops <- opq(la_candelaria_bbox) |>
  # Define the features we want
  add_osm_feature(key = "highway", value = "bus_stop") |>
  # Download those features for that area
  osmdata_sf()

## WRANGLE DATA ----------------------------------------------------------------

# Create neighbourhood boundary
la_candelaria <- medellin_comunas |>
  filter(nombre == "LA CANDELARIA") |>
  # Transform the data to a local coordinate reference system
  st_transform("EPSG:3115")

# Estimate homicide density
homicide_density <- medellin_homicides |>
  # Use the same CRS as `la_candelaria`
  st_transform("EPSG:3115") |>
  # Extract only those homicides occurring within the La Candelaria
  # neighbourhood (otherwise `hotspot_kde()` will be very slow)
  hotspot_clip(la_candelaria) |>
  # Estimate density of homicides
  hotspot_kde(
    grid = hotspot_grid(la_candelaria, cell_size = 100),
    bandwidth_adjust = 0.33,
    quiet = TRUE
  ) |>
  # Clip the result to the neighbourhood boundary
  hotspot_clip(la_candelaria)

la_candelaria_metro_lines <- metro_lines |>
  st_transform(st_crs(la_candelaria)) |>
  hotspot_clip(la_candelaria, quiet = TRUE)

# PLOT MAP ---------------------------------------------------------------------
place_data_map <- hotspot_map(
  homicide_density,
  basemap_type = "cartolight",
  caption = str_glue(
    "Map data: © OpenStreetMap contributors\n",
    "Homicide data: Alcaldía de Medellín (CC-BY-SA)"
  )
) +
  # Add metro lines within the neighbourhood
  geom_sf(
    aes(colour = "Metro line"),
    data = la_candelaria_metro_lines,
    linewidth = 1
  ) +
  # Add neighbourhood boundary
  geom_sf(data = la_candelaria, colour = "grey40", fill = NA, linewidth = 1.5) +
  # Add bus stop locations
  geom_sf(
    aes(shape = "Bus stop"),
    data = pluck(bus_stops, "osm_points"),
    colour = "black",
    fill = "white",
    size = 2
  ) +
  scale_colour_manual(values = c("Metro line" = "darkblue")) +
  scale_shape_manual(values = c("Bus stop" = 21)) +
  # Add plot labels
  labs(
    title = "Homicides do not appear to cluster around bus stops",
    subtitle = "La Candelaria, Medellin",
    colour = NULL,
    shape = NULL
  )

place_data_map
