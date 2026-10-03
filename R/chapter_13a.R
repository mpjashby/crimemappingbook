# This script produces a dual kernel-density map of burglary risk in three
# wards in Nottingham, England

# Load packages
pacman::p_load(here, httr2, osmdata, sf, sfhotspot, tidyverse)

# LOAD DATA --------------------------------------------------------------------

# Download the original data
request(
  "https://mpjashby.github.io/crimemappingdata/nottingham_wards.gpkg"
) |>
  req_perform(path = here("data", "raw", "nottingham_wards.gpkg"))

request(
  "https://mpjashby.github.io/crimemappingdata/nottingham_burglary.csv.gz"
) |>
  req_perform(path = here("data", "raw", "nottingham_burglary.csv.gz"))

# Load dataset of wards in Nottingham and choose the ones we want
wards <- here("data", "raw", "nottingham_wards.gpkg") |>
  read_sf() |>
  st_transform("EPSG:27700") |>
  filter(ward_name %in% c("Castle", "Lenton & Wollaton East", "Meadows"))

# Load dataset of burglaries and keep only those in the wards of interest
burglaries <- here("data", "raw", "nottingham_burglary.csv.gz") |>
  read_csv() |>
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  st_transform("EPSG:27700") |>
  hotspot_clip(wards)

# GET BUILDING DATA ------------------------------------------------------------

buildings_file <- here("data", "processed", "nottingham_buildings.rds")

if (file.exists(buildings_file)) {
  # If buildings data has already been downloaded, load it from the saved copy
  nottingham_buildings <- read_rds(buildings_file)
} else {
  # If buildings data has not been downloaded, get it from OpenStreetMap and
  # save a copy
  nottingham_buildings <- wards |>
    # Transform ward boundaries to CRS needed by `opq()`
    st_transform("EPSG:4326") |>
    # Calculate bounding box
    st_bbox() |>
    # Set up OSM query
    opq(timeout = 120) |>
    # Add type of feature to fetch
    add_osm_feature(key = "building") |>
    # Fetch features from OSM database
    osmdata_sf()

  write_rds(nottingham_buildings, buildings_file)
}

# WRANGLE DATA -----------------------------------------------------------------

# Extract polygon/multipolygon layers and combine them into a single object
nottingham_building_centroids <- bind_rows(
  pluck(nottingham_buildings, "osm_polygons"),
  pluck(nottingham_buildings, "osm_multipolygons")
) |>
  # Transform to the same CRS as the `wards` object
  st_transform("EPSG:27700") |>
  # Convert polygons to points
  st_centroid() |>
  # Remove any points outside the wards of interest
  hotspot_clip(wards)

# Estimate density of burglary risk
burglary_risk <- hotspot_dual_kde(
  burglaries,
  nottingham_building_centroids,
  bandwidth_adjust = 0.25,
  grid = hotspot_grid(wards, cell_size = 100),
  quiet = TRUE
) |>
  hotspot_clip(wards)

# PLOT MAP ---------------------------------------------------------------------

hotspot_map(
  burglary_risk,
  basemap_type = "cartolight",
  caption = str_glue(
    "Contains public sector information licensed under the Open ",
    "Government Licence v3.0"
  )
) +
  # Add ward boundaries
  geom_sf(data = wards, fill = NA) +
  labs(
    title = "Burglary risk in south-west Nottingham",
    subtitle = str_glue(
      "dual kernel density of burglary risk in Castle, Lenton & Wollaton ",
      "East and Meadows wards"
    ),
    fill = "density of burglary risk, 2020"
  ) +
  theme(
    legend.position = "bottom",
    plot.caption = element_text(colour = "grey40"),
    plot.subtitle = element_text(margin = margin(t = 6, b = 6)),
    plot.title = element_text(colour = "grey50", face = "bold", size = 16)
  )
