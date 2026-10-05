# Load packages
pacman::p_load(ggridges, here, httr2, tidyverse)

# Download the burglary data
request(
  "https://mpjashby.github.io/crimemappingdata/northants_burglary_counts.rds"
) |>
  req_perform(path = here("data", "raw", "northants_burglary_counts.rds"))

# Load the local copy of the burglary data
burglary <- here("data", "raw", "northants_burglary_counts.rds") |>
  read_rds()

# Add ridge plot of Northamptonshire burglary
burglary |>
  # Wrap the district names by replacing any space in a name with a new-line
  mutate(district = str_replace_all(district, "\\s", "\n")) |>
  ggplot() +
  # Specify which columns in the data contain the values we're interested in
  aes(x = count, y = district) +
  # Add ridge plot
  geom_density_ridges() +
  # Remove unnecessary space at either end of x axis
  scale_x_continuous(expand = c(0, 0)) +
  # Add labels
  labs(
    title = "Number of burglaries in Northamptonshire neighbourhoods",
    x = "count of burglaries, 2020",
    y = NULL
  ) +
  theme_minimal()
