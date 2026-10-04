# Load packages
pacman::p_load(here, httr2, readxl, tidyverse)

# Download the data from a URL and store it in a local file
request(
  "https://mpjashby.github.io/crimemappingdata/aggravated_assaults.xlsx"
) |>
  req_perform(path = here("data", "raw", "aggravated_assaults.xlsx"))

# Load the Austin data from the Excel workbook
agg_assault_data <- read_excel(
  here("data", "raw", "aggravated_assaults.xlsx"),
  sheet = "Austin"
)

# Count aggravated assaults by location category and weekday
agg_assault_counts <- agg_assault_data |>
  filter(!is.na(location_category), !is.na(date)) |>
  mutate(
    date = as_date(date),
    weekday = wday(date, label = TRUE)
  ) |>
  count(location_category, weekday) |>
  arrange(location_category, weekday)

# Save the processed data without changing the original file
write_csv(
  agg_assault_counts,
  here("data", "processed", "aggravated_assault_counts.csv")
)
