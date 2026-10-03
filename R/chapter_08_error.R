# Load packages
pacman::p_load(here, sf, sfhotspot, tidyverse)
# Load Bronx shootings dataset and wrangle it
bronx_shootings <- here("data", "raw", "bronx_shootings.csv") |>
  read_csv() |>
  janitor::clean_names() |>
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  rename(shooting_date = occur_date, fatal = murder) |>
  # Keep only fatal shootings
  filter(fatal == TRUE) |>
  select(shooting_date, incident_key)

# Load NYPD precincts and filter to keep just those from the Bronx
bronx_precincts <- here("data", "raw", "nyc_precincts.gpkg") |>
  read_sf() |>
  janitor::clean_names() |>
  # Filter just those precincts that are in the Bronx (40th to 52nd)
  filter(precinct %in% 40:52)

# Map shootings
bronx_shootings +
  hotspot_map(

    basemap_type = "none",
    caption = "Shootings data: NYC Open Data",
    alpha = 0.5,
    colour = "red2"
  ) +
  # Add precinct boundaries
  geom_sf(data = bronx_precincts, colour = "grey50", fill = NA) +
  labs(
    title = "Fatal shootings in the Bronx",
    subtitle = "January to December 2019"
  ) +
  theme(
    plot.title = element_text(colour = "grey30", face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5)
  )
