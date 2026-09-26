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
  "2019-01-07T06:50:00Z" , "residence"      , "9500 S BELL AVE"
)

# Prepare each distinct, non-missing address for geocoding
addresses_for_geocoding <- addresses |>
  drop_na(address) |>
  # Add city, state and country, then standardise case before finding distinct
  # addresses
  mutate(
    address = str_to_upper(str_glue("{address}, CHICAGO, IL, UNITED STATES"))
  ) |>
  select(address) |>
  distinct(address)

# Geocode each address using Nominatim
addresses_geocoded <- tidygeocoder::geocode(
  addresses_for_geocoding,
  address = "address",
  method = "osm"
)

# Join the geocoded coordinates back to the original rows
addresses_final <- addresses |>
  mutate(
    temp_address = str_to_upper(str_glue(
      "{address}, CHICAGO, IL, UNITED STATES"
    ))
  ) |>
  left_join(addresses_geocoded, by = c("temp_address" = "address")) |>
  select(-temp_address)

addresses_final

# Convert the geocoded results to an SF object and plot them over a basemap
addresses_sf <- addresses_final |>
  drop_na(long, lat) |>
  st_as_sf(coords = c("long", "lat"), crs = "EPSG:4326")

hotspot_map(addresses_sf, colour = "#CC0000")
