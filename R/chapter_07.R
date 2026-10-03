# This script adds contextual elements to a density map of shootings in the
# Bronx in 2019, then saves the finished map as a PDF.

# Load packages
pacman::p_load(ggspatial, here, httr2, sf, sfhotspot, tidyverse)

# Download the raw data
request(
  "https://mpjashby.github.io/crimemappingdata/bronx_shootings.csv"
) |>
  req_perform(path = here("data", "raw", "bronx_shootings.csv"))

request(
  "https://mpjashby.github.io/crimemappingdata/nyc_precincts.gpkg"
) |>
  req_perform(path = here("data", "raw", "nyc_precincts.gpkg"))

# Load shootings data and transform it to use an appropriate coordinate system
shootings <- here("data", "raw", "bronx_shootings.csv") |>
  read_csv(show_col_types = FALSE) |>
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  st_transform("EPSG:6538")

# Load NYC police precincts data
precincts <- here("data", "raw", "nyc_precincts.gpkg") |>
  read_sf() |>
  janitor::clean_names() |>
  # Filter just those precincts that are in the Bronx (40th to 52nd)
  filter(precinct %in% 40:52) |>
  st_transform("EPSG:6538")

# Estimate density of shootings and clip the result to the Bronx precincts
shootings_kde <- shootings |>
  hotspot_kde(
    grid = hotspot_grid(precincts, cell_size = 200),
    bandwidth_adjust = 0.33,
    quiet = TRUE
  ) |>
  hotspot_clip(precincts, quiet = TRUE)

# Create the map
shootings_map <- hotspot_map(
  shootings_kde,
  basemap_type = "cartolight",
  caption = str_glue(
    "Author: Joe Bloggs, Date produced: {lubridate::today()},\n",
    "Data: NYC Open Data, https://data.cityofnewyork.us/d/833y-fsy8"
  )
) +
  # Add precinct boundaries
  geom_sf(data = precincts, colour = "grey33", fill = NA) +
  # Add precinct labels
  geom_sf_label(
    aes(label = scales::ordinal(precinct)),
    data = precincts,
    alpha = 0.5,
    colour = "grey33",
    fill = "white",
    size = 2.5,
    linewidth = NA
  ) +
  # Add scale bar
  annotation_scale(width_hint = 1 / 5, style = "ticks", location = "br") +
  labs(
    title = "Shootings are focused in the South Bronx",
    subtitle = "Fatal and non-fatal shootings recorded by NYC Police, 2019",
    fill = "kernel density\nof shootings"
  ) +
  theme(
    # Make the plot subtitle smaller and adjust the margin around it
    plot.subtitle = element_text(size = rel(0.8), margin = margin(3, 0, 6, 0)),
    # Make the map caption smaller, left-aligned and grey
    plot.caption = element_text(colour = "grey45", size = rel(0.8), hjust = 0)
  )

# Save the map

ggsave(
  here("output", "bronx_shootings_2019.pdf"),
  plot = shootings_map,
  width = 210,
  height = 210,
  units = "mm"
)
