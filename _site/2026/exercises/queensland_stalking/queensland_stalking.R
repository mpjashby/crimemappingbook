# Map recorded stalking incidents per 100,000 residents in Queensland in 2018.

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)


# Load data --------------------------------------------------------------------

# Download the original data into the workspace
request("https://mpjashby.github.io/crimemappingdata/qld_stalking.xlsx") |>
  req_perform(path = here("data", "raw", "qld_stalking.xlsx"))
request("https://mpjashby.github.io/crimemappingdata/qld_population.csv.gz") |>
  req_perform(path = here("data", "raw", "qld_population.csv.gz"))
request(
  "https://mpjashby.github.io/crimemappingdata/qld_police_divisions.gpkg"
) |>
  req_perform(path = here("data", "raw", "qld_police_divisions.gpkg"))

# Read local data and select stalking counts for 2018
# No need to specify the `sheet` argument in `read_excel()` because the Excel
# file only has one sheet
stalking <- here("data", "raw", "qld_stalking.xlsx") |>
  readxl::read_excel() |>
  filter(year == 2018)
population <- read_csv(here("data", "raw", "qld_population.csv.gz"))
divisions <- read_sf(here("data", "raw", "qld_police_divisions.gpkg"))


# Wrangle data -----------------------------------------------------------------

# Join data and calculate rate
stalking_rate <- divisions |>
  left_join(population, by = join_by(division == police_division)) |>
  left_join(stalking, by = join_by(division)) |>
  mutate(rate = stalking / population * 100000)

# Pimpama has no matching population, so its rate remains NA.
# Keep it on the map in grey rather than treating missing data as zero.

# Find divisions with highest stalking rate and label them in order
stalking_rate_highest <- stalking_rate |>
  slice_max(rate, n = 10, with_ties = FALSE) |>
  arrange(desc(rate)) |>
  mutate(label = str_glue("{division} ({scales::ordinal(row_number())})"))


# Create map -------------------------------------------------------------------

stalking_map <- hotspot_map(
  stalking_rate,
  mapping = aes(fill = rate),
  basemap_type = "cartolight",
  caption = str_glue(
    "Map produced by Joe Bloggs on {lubridate::today()}\n",
    "Offences: Queensland Police Service (CC BY 4.0)\n",
    "Population and boundaries: Queensland Government\n",
    "Grey: rate cannot be calculated because population data unavailable"
  ),
  alpha = 0.75,
  linewidth = 0.25
) +
  # Add thicker boundaries for 10 divisions with highest rates
  geom_sf(
    data = stalking_rate_highest,
    colour = "black",
    fill = NA,
    linewidth = 0.75
  ) +
  # Add labels for 10 divisions with highest rates
  geom_sf_label(
    aes(label = str_wrap(label, width = 12)),
    data = stalking_rate_highest,
    alpha = 0.75,
    fill = "white",
    size = 2.5,
    lineheight = 0.95,
    linewidth = 0
  ) +
  scale_fill_distiller(direction = 1) +
  labs(
    title = "Recorded stalking rates in Queensland",
    subtitle = str_glue(
      "Ten police divisions with the highest rates are highlighted"
    ),
    fill = "stalking incidents\nper 100,000 people\nin 2018"
  ) +
  theme(
    # Slightly lower the legend in the visual hierarchy by giving it a
    # background that is white and semi-transparent
    legend.background = element_rect(colour = NA, fill = rgb(1, 1, 1, 0.75)),
    # Base legend position on the top-right corner of the legend, which makes
    # moving the legend to the top-right corner easier
    legend.justification = c(1, 1),
    # Add some padding around the legend
    legend.margin = margin(6, 9, 9, 9),
    # Move the legend almost to the top-right corner of the map, since this is
    # the area of the map with no content in it
    legend.position = "inside",
    legend.position.inside = c(0.95, 0.98),
    # Make the legend title slightly smaller, again reducing its prominence
    legend.title = element_text(size = 10),
    # Left-align the caption
    plot.caption = element_text(hjust = 0),
    # Add some space above and below the plot subtitle
    plot.subtitle = element_text(margin = margin(6, 0, 6, 0)),
    # Make the plot title larger and bold to move it up the visual hierarchy
    plot.title = element_text(face = "bold", size = 16)
  )


# Save map ---------------------------------------------------------------------

# Create map that is 2000px x 2000px
ggsave(
  filename = here("output", "queensland_stalking_rate_map_2018.jpg"),
  plot = stalking_map,
  width = 2000,
  height = 2000,
  units = "px"
)
