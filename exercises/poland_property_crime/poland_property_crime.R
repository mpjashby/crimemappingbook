# Map recorded property offences per 100,000 residents in Polish counties in 2023.

# Load packages
pacman::p_load(here, httr2, leaflet, readxl, sf, tidyverse)


# Load data --------------------------------------------------------------------

# Download property offence counts into the workspace
request(
  "https://mpjashby.github.io/crimemappingdata/poland_property_crime_counts.xlsx"
) |>
  req_perform(path = here("data", "raw", "poland_property_crime_counts.xlsx"))

# Download population counts into the workspace
request("https://mpjashby.github.io/crimemappingdata/poland_population.tsv") |>
  req_perform(path = here("data", "raw", "poland_population.tsv"))

# Download powiat boundaries into the workspace
request(
  "https://mpjashby.github.io/crimemappingdata/poland_powiat_boundaries.gpkg"
) |>
  req_perform(path = here("data", "raw", "poland_powiat_boundaries.gpkg"))

# Read property offence counts, keeping geographic codes as text
property_crime <- here("data", "raw", "poland_property_crime_counts.xlsx") |>
  read_excel() |>
  # Select counts for 2023 only
  filter(rok == 2023)

# Read population counts, keeping geographic codes as text
population <- here("data", "raw", "poland_population.tsv") |>
  read_tsv() |>
  # Select population counts for 2023 only
  filter(rok == 2023)

# Read powiat boundaries as an SF object
powiats <- here("data", "raw", "poland_powiat_boundaries.gpkg") |>
  read_sf()


# Wrangle data -----------------------------------------------------------------

# Join 2023 counts to county boundaries and calculate incidence rates
property_crime_rate <- powiats |>
  # Join property offence counts using the common territorial code
  left_join(property_crime, by = join_by(jpt_kod_je == kod_teryt)) |>
  # Join population counts using the same territorial code
  left_join(
    select(population, kod_teryt, ludnosc),
    by = join_by(jpt_kod_je == kod_teryt)
  ) |>
  # Calculate property offences per 100,000 residents
  mutate(rate = przestepstwa_przeciwko_mieniu / ludnosc * 100000) |>
  # Transform coordinates for the interactive map
  st_transform("EPSG:4326")


# Create map -------------------------------------------------------------------

# Create a sequential colour palette for property crime rates
property_crime_colours <- colorNumeric(
  palette = "Reds",
  domain = pull(property_crime_rate, "rate")
)

# Create an interactive map of property crime rates
leaflet(property_crime_rate) |>
  # Add a light base map
  addProviderTiles("OpenStreetMap.Mapnik") |>
  # Colour powiats by rate and label them with their names and rates
  addPolygons(
    fillColor = ~ property_crime_colours(rate),
    fillOpacity = 0.75,
    label = ~ paste0(
      jpt_nazwa,
      ": ",
      round(rate, 1),
      " property offences per 100,000 residents in 2023"
    ),
    weight = 1,
    color = "black"
  ) |>
  # Add a legend identifying the place, year and rate units
  addLegend(
    pal = property_crime_colours,
    values = ~rate,
    title = htmltools::HTML(
      "Property crimes per<br>100,000 residents<br>in Poland, 2023"
    )
  ) |>
  # Add an inset map that readers can minimise
  addMiniMap(toggleDisplay = TRUE) |>
  # Credit the providers of the statistical data and processed boundaries
  addControl(
    html = paste0(
      "Statistics: Statistics Poland (CC BY 4.0).<br>",
      "Boundaries: Head Office of Geodesy and Cartography (GUGiK),<br>",
      "National Register of Boundaries (PRG)."
    ),
    position = "bottomleft"
  )
