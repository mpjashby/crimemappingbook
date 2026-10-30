# This script produces a map of concentrations of calls to opioid overdoses in
# Tempe, Arizona, since January 2020. Run in the crime_mapping workspace.

# PREPARE ----------------------------------------------------------------------

## Load packages ----
pacman::p_load(ggspatial, here, httr2, sf, sfhotspot, tidyverse)


## Load data ----

# All data layers should be harmonised to use EPSG:6404 since this uses metres
# and covers the central part of Arizona

# Download the original data into the workspace
request("https://mpjashby.github.io/crimemappingdata/tempe_opioid_calls.csv") |>
  req_perform(path = here("data", "raw", "tempe_opioid_calls.csv"))
request(
  "https://mpjashby.github.io/crimemappingdata/tempe_character_areas.gml"
) |>
  req_perform(path = here("data", "raw", "tempe_character_areas.gml"))

# Read local calls data, keep calls since January 2020 and transform coordinates
incidents <- here("data", "raw", "tempe_opioid_calls.csv") |>
  read_csv() |>
  janitor::clean_names() |>
  filter(incident_date >= ymd("2020-01-01")) |>
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  st_transform("EPSG:6404")

# Read the local city boundary and use the same coordinate reference system
character_areas <- here("data", "raw", "tempe_character_areas.gml") |>
  read_sf() |>
  janitor::clean_names() |>
  st_transform("EPSG:6404") |>
  # Some of the character areas have very long names which would not fit easily
  # on the map, so we abbreviate them first
  mutate(
    label = case_when(
      area_number == 1 ~ "North Tempe",
      area_number == 2 ~ "Double Butte",
      area_number == 3 ~ "Downtown",
      area_number == 7 ~ "The Lakes",
      area_number == 8 ~ "South Tempe",
      # If the area number is not specified above, use the existing area name
      TRUE ~ area_name
    )
  )


# WRANGLE ----------------------------------------------------------------------

# Estimate call density on a 150-metre grid, then clip it to the city boundary.
# Some recorded calls fall outside the boundary; a warning may be produced.
# Clipping limits the displayed density surface to the city rather than
# interpreting those approximate coordinates as exact locations.
incidents_kde <- incidents |>
  hotspot_kde(
    grid = hotspot_grid(character_areas, cell_size = 150),
    bandwidth_adjust = 0.33,
    quiet = TRUE
  ) |>
  hotspot_isoband(breaks = 10, quiet = TRUE) |>
  hotspot_clip(character_areas, quiet = TRUE)


# VISUALISE --------------------------------------------------------------------

# Create map
tempe_opioid_map <- hotspot_map(
  incidents_kde,
  basemap_type = "cartolight",
  caption = str_glue(
    "Author: Joe Bloggs, Date produced: {today()}\n",
    "Calls and character areas: City of Tempe (CC BY)\n",
    "Locations are approximate"
  )
) +
  # Add character area boundaries
  geom_sf(data = character_areas, colour = "grey50", fill = NA) +
  # Add character area labels
  geom_sf_label(
    aes(label = str_wrap(label, 10)),
    data = character_areas,
    alpha = 0.5,
    fill = "white",
    lineheight = 1,
    linewidth = 0,
    size = 2.5
  ) +
  # Add scale bar
  annotation_scale(width_hint = 1 / 5, style = "ticks", location = "bl") +
  labs(
    title = "Calls for suspected opioid overdoses in Tempe",
    subtitle = str_glue(
      "Calls to emergency medical services, ",
      "{format(min(pull(incidents, 'incident_date')), '%b %Y')} to ",
      "{format(max(pull(incidents, 'incident_date')), '%b %Y')}"
    ),
    fill = "density of\ncalls"
  ) +
  theme(
    legend.title = element_text(size = 8),
    plot.caption = element_text(hjust = 0, size = 6),
    plot.title = element_text(size = 12),
    plot.subtitle = element_text(size = 9, margin = margin(6, 0, 6, 0))
  )

# Save map
ggsave(
  here("output", "tempe_opioid_calls.jpg"),
  plot = tempe_opioid_map,
  width = 2000,
  height = 2000,
  units = "px"
)
