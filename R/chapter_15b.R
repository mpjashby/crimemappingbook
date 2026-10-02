# This script creates an animated map showing how the density of aggravated
# assaults in downtown Chicago varied by hour between 2010 and 2019

# Load packages
pacman::p_load(gganimate, here, httr2, sf, sfhotspot, tidyverse)


# LOAD DATA --------------------------------------------------------------------

# Download the original data
request(
  "https://mpjashby.github.io/crimemappingdata/chicago_aggravated_assaults.csv.gz"
) |>
  req_perform(
    path = here("data", "raw", "chicago_aggravated_assaults.csv.gz")
  )

request(
  "https://mpjashby.github.io/crimemappingdata/chicago_police_districts.kml"
) |>
  req_perform(path = here("data", "raw", "chicago_police_districts.kml"))

# Load Chicago aggravated assault data
assaults <- here("data", "raw", "chicago_aggravated_assaults.csv.gz") |>
  read_csv(show_col_types = FALSE)

# Load dataset of Chicago Police Department (CPD) district boundaries
cpd_districts <- here("data", "raw", "chicago_police_districts.kml") |>
  read_sf() |>
  janitor::clean_names() |>
  st_transform("EPSG:26916")

# Create a separate dataset holding just the boundaries of the three CPD
# districts covering the downtown area
cpd_central <- filter(cpd_districts, name %in% c("1", "12", "18"))


# WRANGLE DATA -----------------------------------------------------------------

# Create a version of the dataset with a column showing which hour the assault
# occurred in
assaults_by_hour <- assaults |>
  filter(district %in% c(1, 12, 18)) |>
  mutate(
    hour_name = str_pad(hour(date), width = 2, pad = "0"),
    hour_name = str_glue("{hour_name}:00 to {hour_name}:59")
  ) |>
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  st_transform("EPSG:26916")

# Create a grid to be used by all the KDE layers
grid <- hotspot_grid(cpd_central, cell_size = 200)

# Calculate KDE layer for each hour of the day
hour_layers <- assaults_by_hour |>
  group_by(hour_name) |>
  group_modify(
    \(x, ...) hotspot_kde(
      x,
      grid = grid,
      bandwidth_adjust = 0.5,
      quiet = TRUE
    )
  ) |>
  ungroup() |>
  st_as_sf() |>
  hotspot_clip(cpd_central, quiet = TRUE)

# Extract only the 10 cells with the highest density in each hour
hour_highest <- hour_layers |>
  group_by(hour_name) |>
  slice_max(order_by = kde, n = 10)


# CREATE AND SAVE ANIMATION ----------------------------------------------------

chicago_downtown_kde_map <- hotspot_map(
  hour_layers,
  basemap_type = "cartolight",
  caption = "Crime data from Chicago Police Department"
) +
  geom_sf(data = hour_highest, alpha = 0.75, colour = "red2", fill = NA) +
  geom_sf(data = cpd_central, colour = "grey33", fill = NA) +
  transition_states(states = hour_name) +
  labs(
    title = "Aggravated assaults in downtown Chicago, 2010–2019",
    subtitle = "Areas with most aggravated assaults:\n{closest_state}",
    fill = "density of\naggravated\nassaults"
  )

anim_save(
  filename = here("output", "chicago_downtown_agg_assaults.gif"),
  animation = animate(
    plot = chicago_downtown_kde_map,
    fps = 2,
    height = 800,
    width = 800,
    units = "px"
  )
)
