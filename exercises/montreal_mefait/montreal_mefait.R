# Map recorded damage to property (méfait) in Montreal in 2025.

# Load the packages needed for downloading, preparing and mapping the data
pacman::p_load(here, httr2, sf, sfhotspot, tidyverse)

# Download the original compressed CSV file and keep a local copy
request("https://mpjashby.github.io/crimemappingdata/montreal_mefait.csv.gz") |>
  # Save the file in the workspace's data/raw folder
  req_perform(path = here("data", "raw", "montreal_mefait.csv.gz"))

# Locate the downloaded file within the workspace
mefait_2025 <- here("data", "raw", "montreal_mefait.csv.gz") |>
  # Read the compressed CSV file, including its date column
  read_csv() |>
  # Convert column names to snake_case
  janitor::clean_names() |>
  # Keep dates from 1 January to 31 December 2025 inclusive
  filter(date >= ymd("2025-01-01"), date <= ymd("2025-12-31")) |>
  # Interpret x and y as projected coordinates in metres using EPSG:2950
  st_as_sf(coords = c("x", "y"), crs = "EPSG:2950")

# Draw a point map over a base map, with small, partly transparent points
hotspot_map(
  mefait_2025,
  basemap_type = "cartolight",
  alpha = 0.25,
  colour = "blue2",
  size = 0.5
)
