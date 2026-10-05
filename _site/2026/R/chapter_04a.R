# Load packages
pacman::p_load(here, httr2, readxl, tidyverse)

# Download the data from a URL and store it in a local file
request(
  "https://mpjashby.github.io/crimemappingdata/san_francisco_robbery.csv"
) |>
  req_perform(path = here("data", "raw", "san_francisco_robbery.csv"))

# Load the local file into R
san_fran_rob <- read_csv(here("data", "raw", "san_francisco_robbery.csv"))

# Produce counts of robberies each weekday
q1_weekday_counts <- san_fran_rob |>
  filter(
    as_date(date_time) >= ymd("2019-01-01"),
    as_date(date_time) <= ymd("2019-03-31")
  ) |>
  mutate(weekday = wday(date_time, label = TRUE)) |>
  count(weekday)

# Save the processed data without changing the original file
write_csv(
  q1_weekday_counts,
  here("data", "processed", "q1_weekday_counts.csv")
)
