# Load packages
pacman::p_load(here, tidyverse)

# Load a dataset from the workspace and wrangle it
road_deaths <- read_csv(here("data", "raw", "road_deaths_data.csv")) |>
  janitor::clean_names() |>
  rename(ksi_drivers = drivers, ksi_pass_front = front, ksi_pass_rear = rear) |>
  select(-petrol_price, -van_killed) |>
  mutate(
    law = as.logical(law),
    ksi_driver_rate = ksi_drivers / (kms / 1000)
  )

# Make a time-series chart of two continuous variables, coloured by a
# categorical variable, then add a trend line
road_deaths |>
  ggplot(aes(x = month_beginning, y = ksi_driver_rate)) +
  geom_point(aes(colour = law)) +
  geom_smooth() +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  scale_y_continuous(labels = scales::comma_format(), limits = c(0, NA)) +
  scale_colour_brewer(type = "qual") +
  labs(
    x = NULL,
    y = "drivers killed or seriously injured per 1,000km travelled",
    colour = "after seat belts made mandatory"
  ) +
  theme_minimal() +
  theme(
    axis.line.x = element_line(colour = "grey90"),
    axis.ticks = element_line(colour = "grey90"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    legend.position = "bottom"
  )
