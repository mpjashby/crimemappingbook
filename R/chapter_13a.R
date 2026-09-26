# This script produces a dual kernel-density map of burglary risk in three
# wards in Nottingham, England

# Load packages
pacman::p_load(ggspatial, here, httr2, osmdata, sf, sfhotspot, tidyverse)


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

# Load and prepare ward boundaries
wards <- here("data", "raw", "nottingham_wards.gpkg") |>
  read_sf() |>
  st_transform("EPSG:27700") |>
  filter(ward_name %in% c("Castle", "Lenton & Wollaton East", "Meadows"))

# Load and prepare burglary locations
burglaries <- here("data", "raw", "nottingham_burglary.csv.gz") |>
  read_csv() |>
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  st_transform("EPSG:27700") |>
  hotspot_clip(wards)


# GET BUILDING DATA ------------------------------------------------------------

buildings_file <- here("data", "processed", "nottingham_buildings.rds")

if (file.exists(buildings_file)) {
  nottingham_buildings <- readRDS(buildings_file)
} else {
  nottingham_buildings <- wards |>
    st_transform("EPSG:4326") |>
    st_bbox() |>
    opq(timeout = 120) |>
    add_osm_feature(key = "building") |>
    osmdata_sf()

  saveRDS(nottingham_buildings, buildings_file)
}


# WRANGLE DATA -----------------------------------------------------------------

nottingham_building_centroids <- bind_rows(
  pluck(nottingham_buildings, "osm_polygons"),
  pluck(nottingham_buildings, "osm_multipolygons")
) |>
  st_transform("EPSG:27700") |>
  st_centroid() |>
  hotspot_clip(wards)

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
