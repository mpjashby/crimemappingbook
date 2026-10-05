# Load packages
pacman::p_load(here, httr2, readxl, tidyverse)

# Download the data from a URL and store it in a local file
request(
  "https://mpjashby.github.io/crimemappingdata/san_francisco_robbery.csv"
) |>
  req_perform(path = here("data", "raw", "san_francisco_robbery.csv"))

# Load the local file into R
san_fran_rob <- read_csv(here("data", "raw", "san_francisco_robbery.csv"))
