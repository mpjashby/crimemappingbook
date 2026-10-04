# This script identifies clusters of robberies in Nottingham, England

# Load packages
pacman::p_load(ggspatial, here, httr2, sf, sfhotspot, tidyverse)


# LOAD DATA --------------------------------------------------------------------

# Download the original data
request(
  "https://mpjashby.github.io/crimemappingdata/nottingham_robbery.csv.gz"
) |>
  req_perform(path = here("data", "raw", "nottingham_robbery.csv.gz")) |>
  # Stop this command from producing an output in the R Console
  invisible()
# Load data and transform to British National Grid so distances are in metres
robbery <- here("data", "raw", "nottingham_robbery.csv.gz") |>
  read_csv(show_col_types = FALSE) |>
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  st_transform("EPSG:27700")

# FIND CLUSTERS ----------------------------------------------------------------

# Find clusters using DBSCAN

robbery_dbscan <- hotspot_dbscan(robbery, density_adjust = 5)

# PLOT MAP ---------------------------------------------------------------------

hotspot_map(
  robbery_dbscan,
  col_fill = "none",
  col_label = "prop",
  colour = "red2",
  basemap_type = "cartolight",
  caption = str_glue(
    "Contains public sector information licensed under the\nOpen ",
    "Government Licence v3.0."
  )
) +
  labs(title = "Nottingham robbery clusters") +
  theme(
    plot.title = element_text(colour = "grey50", face = "bold", size = 16)
  )
