# Load packages
pacman::p_load(gt, here, httr2, tidyverse)

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

# Produce table of crime counts in each Malaysian state
violence |>
  # Convert data to have one row per state
  pivot_wider(names_from = crime_type, values_from = count) |>
  # Convert new column names (the former values of `crime_type`) to snake case
  janitor::clean_names() |>
  # Choose only the columns we want to show in the table
  select(
    region,
    state,
    murder,
    rape,
    aggravated_assault,
    armed_robbery,
    unarmed_robbery
  ) |>
  # Specify the table rows should be grouped by the values of `region`
  group_by(region) |>
  # Functions from tidyverse above and functions from gt below
  gt(rowname_col = "state") |>
  # Format numbers with thousand separators and no decimals
  fmt_number(columns = where(is.numeric), decimals = 0) |>
  # Show distribution of values in some columns using colour
  data_color(columns = unarmed_robbery, palette = "Oranges") |>
  data_color(columns = rape, palette = "Blues") |>
  # Add column labels
  cols_label(
    "aggravated_assault" ~ "agg. assault",
    "armed_robbery" ~ md("robbery<br>(armed)"),
    "unarmed_robbery" ~ md("robbery<br>(unarmed)")
  ) |>
  # Add a summary row showing the total number of crimes in each region
  summary_rows(
    columns = where(is.numeric),
    fns = "regional total" ~ sum(.),
    fmt = everything() ~ fmt_number(., decimals = 0)
  ) |>
  # Add a summary row showing the total number of crimes in Malaysia
  grand_summary_rows(
    columns = where(is.numeric),
    fns = "national total" ~ sum(.),
    fmt = everything() ~ fmt_number(., decimals = 0)
  )
