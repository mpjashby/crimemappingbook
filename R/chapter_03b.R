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
