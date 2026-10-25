# Map the density of recorded fatal shootings in NYC in 2019,
# excluding Staten Island. Run in the crime_mapping workspace.

## Load packages and data ------------------------------------------------------

# Note: both datasets will be harmonised to use EPSG:6538 for use with
# `hotspot_kde()`

# Load packages
pacman::p_load(ggspatial, here, httr2, sf, sfhotspot, tidyverse)

# Download the original data into the workspace
request("https://mpjashby.github.io/crimemappingdata/nyc_shootings.csv") |>
  req_perform(path = here("data", "raw", "nyc_shootings.csv"))
request("https://mpjashby.github.io/crimemappingdata/nyc_precincts.gpkg") |>
  req_perform(path = here("data", "raw", "nyc_precincts.gpkg"))

# Read local shootings data and select fatal shootings in 2019
shootings <- read_csv(here("data", "raw", "nyc_shootings.csv")) |>
  janitor::clean_names() |>
  filter(murder == TRUE, boro != "STATEN ISLAND") |>
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  st_transform("EPSG:6538")

# Load NYC police precincts data
precincts <- here("data", "raw", "nyc_precincts.gpkg") |>
  read_sf() |>
  janitor::clean_names() |>
  # Filter out precincts in Staten Island, since there are very few fatal
  # shootings there and it takes up a lot of space due to the position of Staten
  # Island relative to the rest of NYC
  filter(precinct <= 119) |>
  st_transform("EPSG:6538")


## Wrangle data ----------------------------------------------------------------

# Calculate KDE
shootings_kde <- shootings |>
  hotspot_kde(
    grid = hotspot_grid(precincts, cell_size = 250),
    bandwidth_adjust = 0.33,
    quiet = TRUE
  ) |>
  hotspot_clip(precincts, quiet = TRUE)


## Make map --------------------------------------------------------------------

shootings_map <- hotspot_map(
  shootings_kde,
  basemap_type = "cartolight",
  caption = str_glue(
    "Author: Joe Bloggs, Date produced: {lubridate::today()}\n",
    "Shootings: New York City Police Department\n",
    "Boundaries: City of New York (CC BY 3.0 AU)"
  )
) +
  geom_sf(data = precincts, colour = "grey33", fill = NA) +
  geom_sf_label(
    aes(label = scales::ordinal(precinct)),
    data = precincts,
    alpha = 0.5,
    colour = "grey33",
    fill = "white",
    size = 2.5,
    linewidth = NA
  ) +
  annotation_scale(width_hint = 1 / 5, style = "ticks", location = "br") +
  labs(
    title = str_glue(
      "Density of recorded fatal shootings in New York City"
    ),
    subtitle = str_glue(
      "Fatal shootings recorded by NYC Police, 2019, excluding Staten Island"
    ),
    fill = "density of\nshootings"
  ) +
  # Make the map square (i.e. have an aspect or height/width ratio of 1) to
  # expand the area covered by the map without reducing the size of the area
  # covered by the data layer
  fixed_plot_aspect(ratio = 1) +
  theme(
    # We're going to overlay the legend on the map, so we should give the
    # legend a solid background
    legend.background = element_rect(colour = NA, fill = "#F2F2F2"),
    # Use the top-right corner of the legend as the anchor point for determining
    # its position
    legend.justification = c(1, 1),
    # Make the legend colour bar smaller
    legend.key.width = unit(0.8, "lines"),
    # Create a margin around the legend, since it has a solid background
    legend.margin = margin(6, 6, 6, 6),
    # Move the top-right corner of the legend to be very near the top-right
    # corner of the map
    legend.position = "inside",
    legend.position.inside = c(0.98, 0.98),
    # Make the legend and title smaller to reduce their visual prominence
    legend.text = element_text(size = rel(0.7)),
    legend.title = element_text(size = rel(0.8)),
    plot.subtitle = element_text(size = rel(0.8), margin = margin(3, 0, 6, 0)),
    plot.caption = element_text(colour = "grey45", size = rel(0.7), hjust = 0)
  )


# Save the finished map in the workspace output folder
ggsave(
  here("output", "nyc_fatal_shootings_2019.png"),
  plot = shootings_map,
  width = 210,
  height = 210,
  units = "mm"
)
