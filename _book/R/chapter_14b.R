# This script creates several charts as examples of how to make charts in R

# Load packages
pacman::p_load(ggplot2, here, httr2, paletteer, tidyverse)

# Download annual counts of different types of violence in Malaysia
request(
  "https://mpjashby.github.io/crimemappingdata/malaysia_violence_counts.rds"
) |>
  req_perform(path = here("data", "raw", "malaysia_violence_counts.rds"))

# Load the local copy and keep only counts from 2017
violence <- here("data", "raw", "malaysia_violence_counts.rds") |>
  read_rds() |>
  # Keep only counts from 2017
  filter(year == 2017)

# Create bar chart of murder counts
malaysia_murder_bar_chart <- violence |>
  # Keep only rows representing murder counts
  filter(crime_type == "murder") |>
  # Re-order states according to number of murders
  mutate(state = fct_reorder(state, count)) |>
  # Initialise chart
  ggplot() +
  # Translate columns in the data to aesthetics on the chart
  aes(x = count, y = state, fill = region) +
  # Add bars
  geom_col() +
  # Specify colour-blind-safe fill colours
  scale_fill_paletteer_d("PrettyCols::Bright") +
  # Add labels
  labs(
    title = "Murders in Each Malaysian State (2017)",
    caption = "Source: Hakim et al. (2019)",
    x = "Count",
    y = NULL
  ) +
  # Remove unnecessary chart elements
  theme_minimal() +
  theme(
    axis.title.x = element_text(hjust = 1),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    plot.title.position = "plot"
  )

malaysia_murder_bar_chart
