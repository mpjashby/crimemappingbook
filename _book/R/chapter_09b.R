# This script produces interactive maps of murder counts and murder rates in
# districts in Uttar Pradesh, India, in 2014.

# PREPARE ----------------------------------------------------------------------

# Load packages
pacman::p_load(here, httr2, leaflet, sf, tidyverse)

# Download the raw murder-count and district-boundary data
request(
  "https://mpjashby.github.io/crimemappingdata/uttar_pradesh_murders.csv"
) |>
  req_perform(path = here("data", "raw", "uttar_pradesh_murders.csv"))

request(
  "https://mpjashby.github.io/crimemappingdata/uttar_pradesh_districts.gpkg"
) |>
  req_perform(path = here("data", "raw", "uttar_pradesh_districts.gpkg"))

# Load murder counts and district boundaries
murders <- here("data", "raw", "uttar_pradesh_murders.csv") |>
  read_csv(show_col_types = FALSE)

districts <- here("data", "raw", "uttar_pradesh_districts.gpkg") |>
  read_sf()

# Download district population counts
request(
  "https://mpjashby.github.io/crimemappingdata/uttar_pradesh_population.csv"
) |>
  req_perform(path = here("data", "raw", "uttar_pradesh_population.csv"))

# Load district population counts
district_pop <- here("data", "raw", "uttar_pradesh_population.csv") |>
  read_csv(show_col_types = FALSE)

# WRANGLE ----------------------------------------------------------------------

# Join murder and population counts to district boundaries, then calculate the
# murder rate per 100,000 residents
district_murders <- districts |>
  # Join murder counts
  left_join(murders, by = join_by(district_name == district)) |>
  # Join population counts
  left_join(district_pop, by = join_by(district_name == district)) |>
  # Calculate murder rate
  mutate(murder_rate = murder / population * 100000)

# VISUALISE --------------------------------------------------------------------

# Create a custom colour palette function for murder counts
murder_colours <- colorNumeric(
  palette = "Reds",
  domain = pull(district_murders, "murder")
)

# Create an interactive map of murder counts
leaflet(district_murders) |>
  # Add base map
  addProviderTiles("Stadia.AlidadeSmooth") |>
  # Add district polygons coloured by number of murders
  addPolygons(
    fillColor = ~ murder_colours(murder),
    fillOpacity = 0.75,
    label = ~ paste0(district_name, ": ", murder, " murders"),
    weight = 2,
    color = "black"
  ) |>
  # Add legend
  addLegend(
    pal = murder_colours,
    values = ~murder,
    title = "number of murders"
  ) |>
  # Add inset map
  addMiniMap(toggleDisplay = TRUE)

# Create a colour palette for murder rates
murder_rate_colours <- colorNumeric(
  palette = "Reds",
  domain = pull(district_murders, "murder_rate")
)

# Create an interactive map of murder rates
leaflet(district_murders, elementId = "murder-rate-map") |>
  # Add base map
  addProviderTiles(
    "Esri.WorldImagery",
    options = providerTileOptions(opacity = 0.3)
  ) |>
  # Add district polygons coloured by murder rate
  addPolygons(
    fillColor = ~ murder_rate_colours(murder_rate),
    fillOpacity = 0.75,
    label = ~ paste0(
      district_name,
      ": ",
      round(murder_rate, 1),
      " murders per 100,000 residents"
    ),
    weight = 2,
    color = "black"
  ) |>
  # Add legend
  addLegend(
    pal = murder_rate_colours,
    values = ~murder_rate,
    title = htmltools::HTML("murders per<br>100,000 residents")
  ) |>
  # Add inset map
  addMiniMap(toggleDisplay = TRUE)
