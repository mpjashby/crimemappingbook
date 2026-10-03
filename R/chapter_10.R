# This script prepares and geocodes fictional incident addresses in Chicago.

# Load packages
pacman::p_load(sf, sfhotspot, tidygeocoder, tidyverse)

# Create example dataset of addresses to be geocoded
addresses <- tribble(
  ~"offense_date"        , ~"location_type" , ~"address"             ,
  "2019-01-01T00:00:00Z" , "residence"      , "2400 W Carmen Ave"    ,
  "2019-01-01T00:00:00Z" , "residence"      , "2700 S TRIPP AVE"     ,
  "2019-01-01T11:44:00Z" , "residence"      , "3700 S PAULINA ST"    ,
  "2019-01-01T11:44:00Z" , "residence"      , "3700 S Paulina St"    ,
  "2019-01-01T16:37:00Z" , "government"     , "1100 S HAMILTON AVE"  ,
  "2019-01-02T17:09:00Z" , "gas station"    , NA                     ,
  "2019-01-02T17:09:00Z" , "gas station"    , "8200 S HALSTED ST"    ,
  "2019-01-05T00:01:00Z" , "residence"      , "1300 N HUDSON AVE"    ,
  "2019-01-05T14:00:00Z" , "other"          , "6200 N Claremont Ave" ,
  "2019-01-07T06:50:00Z" , "residence"      , "9500 S BELL AVE"      ,
)

# Prepare each distinct, non-missing address for geocoding
addresses_for_geocoding <- addresses |>
  # Drop rows that have NA values in the `address` column
  drop_na(address) |>
  # Add city, state and country, then convert to upper case so that `distinct()`
  # will not treat identical addresses as different because of different cases,
  # e.g. 'ST' vs 'St' as abbreviations for 'Street'
  mutate(
    address = str_to_upper(str_glue("{address}, CHICAGO, IL, UNITED STATES"))
  ) |>
  # Select only the address column, since we won't send the other columns to the
  # geocoding function
  select(address) |>
  # Find all the unique rows in the data
  distinct(address)

# Geocode each address using Nominatim

addresses_geocoded <- tidygeocoder::geocode(
  addresses_for_geocoding,
  address = "address",
  method = "osm"
)

# Join the geocoded coordinates back to the original rows

addresses_final <- addresses |>
  # Create a temporary address column to use in matching the geocoded addresses
  mutate(
    temp_address = str_to_upper(str_glue(
      "{address}, CHICAGO, IL, UNITED STATES"
    ))
  ) |>
  # `left_join()` keeps all the rows in the left-hand dataset (the original
  # `addresses` object) and matching rows in the right-hand dataset (the
  # geocoding results)
  left_join(addresses_geocoded, by = c("temp_address" = "address")) |>
  # Remove the temporary address column
  select(-temp_address)

addresses_final

# Convert the geocoded results to an SF object and plot them over a basemap

addresses_sf <- addresses_final |>
  drop_na(long, lat) |>
  st_as_sf(coords = c("long", "lat"), crs = "EPSG:4326")

hotspot_map(addresses_sf, colour = "#CC0000")
