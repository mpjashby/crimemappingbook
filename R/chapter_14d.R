# Load packages
pacman::p_load(ggrepel, here, httr2, tidyverse)

# Download South African vehicle-theft rates
request(
  "https://mpjashby.github.io/crimemappingdata/south_africa_vehicle_theft.rds"
) |>
  req_perform(path = here("data", "raw", "south_africa_vehicle_theft.rds"))

# Load the local copy of the vehicle-theft rates
vehicle_theft <- here("data", "raw", "south_africa_vehicle_theft.rds") |>
  read_rds() |>
  pivot_wider(names_from = crime_category, values_from = theft_rate) |>
  janitor::clean_names() |>
  rename(
    theft_of = theft_of_motor_vehicle,
    theft_from = theft_out_of_or_from_motor_vehicle
  )

# Create scatter plot of vehicle theft
vehicle_theft |>
  # Create a new column in the data, either containing the municipality name or
  # `NA` depending on the values of `theft_of` and `theft_from`
  mutate(label = if_else(theft_of > 17 | theft_from > 65, municipality, NA)) |>
  # Initiate plot
  ggplot() +
  # Specify which columns control the position of all the chart layers
  aes(x = theft_of, y = theft_from) +
  # Add vertical line showing median rate of theft of a vehicle
  geom_vline(
    xintercept = median(pull(vehicle_theft, "theft_of")),
    linetype = "22"
  ) +
  # Add horizontal line showing median rate of theft from a vehicle
  geom_hline(
    yintercept = median(pull(vehicle_theft, "theft_from")),
    linetype = "22"
  ) +
  # Add trend line
  geom_smooth(
    method = "lm",
    formula = y ~ x,
    se = FALSE,
    colour = "grey20"
  ) +
  # Add points
  geom_point(alpha = 0.5) +
  # Add labels for municipalities with unusually high rates
  geom_label_repel(aes(label = label), na.rm = TRUE, linewidth = 0) +
  # Add labels
  labs(
    title = "Vehicle thefts in South African municipalities",
    subtitle = str_glue(
      "each dot represents one municipality, 2018-19, dashed lines show ",
      "median values"
    ),
    x = "rate of thefts of motor vehicles per 1,000 vehicle-owning households",
    y = "rate of thefts from motor vehicles per 1,000 vehicle-owning households"
  ) +
  theme_minimal()
