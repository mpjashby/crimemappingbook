# This script creates charts and maps showing how aggravated assaults in
# Chicago varied over time between 2010 and 2019

# Load packages
pacman::p_load(here, httr2, sf, sfhotspot, slider, tidyverse)

# LOAD DATA --------------------------------------------------------------------

# Download the original data
request(
  "https://mpjashby.github.io/crimemappingdata/chicago_aggravated_assaults.csv.gz"
) |>
  req_perform(
    path = here("data", "raw", "chicago_aggravated_assaults.csv.gz")
  )

request(
  "https://mpjashby.github.io/crimemappingdata/chicago_police_districts.kml"
) |>
  req_perform(path = here("data", "raw", "chicago_police_districts.kml"))

# Load Chicago aggravated assault data
assaults <- here("data", "raw", "chicago_aggravated_assaults.csv.gz") |>
  read_csv(show_col_types = FALSE)

# Load dataset of Chicago Police Department (CPD) district boundaries
cpd_districts <- here("data", "raw", "chicago_police_districts.kml") |>
  read_sf() |>
  janitor::clean_names() |>
  # Transform this object to use a suitable local coordinate reference system
  st_transform("EPSG:26916")

# Create a separate dataset holding just the boundaries of the three CPD
# districts covering the downtown area
cpd_central <- filter(cpd_districts, name %in% c("1", "12", "18"))

# SHOW CHANGE OVER TIME --------------------------------------------------------

# Count number of aggravated assaults each week
assault_weekly_counts <- assaults |>
  # Convert offence dates so that it appears each offence happened on the first
  # day (Sunday) of the week
  mutate(week_date = floor_date(as_date(date), unit = "week")) |>
  # Count the number of assaults each week
  count(week_date, name = "count") |>
  # The code `(n() - 1)` gives us the row number of the second-to-last row in
  # the data because `n()` returns the number of rows in the data. Note the
  # parentheses!
  slice(2:(n() - 1))

# Create plot of weekly assault counts with moving average
assault_weekly_counts |>
  # Calculate moving average
  mutate(moving_avg = slide_dbl(count, mean, .before = 3, .complete = TRUE)) |>
  ggplot() +
  # Specify which columns in the data will control which parts of the chart
  aes(x = week_date) +
  # Add points showing weekly counts of assaults
  geom_point(aes(y = count), colour = "grey75", size = 0.75) +
  # Add line showing moving average
  geom_line(aes(y = moving_avg), na.rm = TRUE) +
  # Specify how dates should be shown on the x axis
  scale_x_date(date_breaks = "1 year", date_labels = "%Y", expand = c(0, 0)) +
  # Make sure y axis starts at zero
  scale_y_continuous(limits = c(0, NA), expand = c(0, 0), position = "right") +
  # Add labels
  labs(
    title = "Trend in aggravated assaults in Chicago",
    subtitle = "points show weekly counts, line shows four-week moving average",
    caption = "Data from Chicago Police Department",
    x = NULL,
    y = "weekly count of aggravated assaults"
  ) +
  theme_minimal() +
  theme(
    panel.grid.minor.x = element_blank(),
    plot.caption = element_text(colour = "grey40"),
    plot.caption.position = "plot"
  )

# Create a seasonal plot of aggravated assaults
assault_weekly_counts |>
  mutate(
    # Create an eight-week moving average
    moving_avg = slide_dbl(count, mean, .before = 7, .complete = TRUE),
    # Create a new column showing just the year
    year = year(week_date),
    # By only specifying the `month` and `day` arguments to `make_date()` we
    # will create a date in 1970 (the year that R uses by default), but that
    # doesn't matter because we are not going to show the year on the chart
    pseudo_date = make_date(month = month(week_date), day = mday(week_date))
  ) |>
  ggplot() +
  # Specify which columns in the data should control which parts of the chart
  aes(x = pseudo_date, y = moving_avg, colour = year, group = year) +
  # Add lines
  geom_line(na.rm = TRUE) +
  # Specify how dates should be shown on the x axis
  scale_x_date(date_breaks = "1 month", date_labels = "%b") +
  # Make sure y axis starts at zero
  scale_y_continuous(limits = c(0, NA)) +
  # Specify that the legend should be labelled with whole numbers
  scale_colour_continuous(breaks = c(2010, 2013, 2016, 2019)) +
  # Add labels
  labs(
    x = NULL,
    y = "moving average of weekly count of aggravated assaults",
    colour = NULL
  ) +
  theme_minimal() +
  theme(
    panel.grid.minor.x = element_blank()
  )

# Create counts of assaults by hours of the day and week
assault_hourly_counts <- assaults |>
  # Extract day of the week and hour of the day from the date column
  mutate(wday = wday(date, label = TRUE), hour = hour(date)) |>
  # Count crimes for each hour of each day of the week
  count(wday, hour, name = "count") |>
  # By only setting the `hour` argument to `make_datetime()` we will create a
  # date-time on 1 January 1970, but that doesn't matter because we will not
  # show the date on the chart
  mutate(pseudo_date = make_datetime(hour = hour))

# Create chart of assaults by hour of the day for each day of the week
assault_hourly_counts |>
  # Create a new column specifying if each day is a weekday or weekend
  mutate(weekend = if_else(wday %in% c("Sat", "Sun"), "Sat–Sun", "Mon–Fri")) |>
  ggplot() +
  # Specify which columns in the data should control each part of the chart
  aes(x = pseudo_date, y = count, colour = wday) +
  # Add lines
  geom_line(linewidth = 1) +
  # Assign the facets to rows so that we can compare the same time on different
  # days more easily (change `rows` to `cols` to see the alternative)
  facet_grid(rows = vars(weekend)) +
  # Specify how dates should be shown on the x axis
  scale_x_datetime(date_breaks = "2 hours", date_labels = "%H:%M") +
  # Make sure y axis starts at zero and labels have thousands separators
  scale_y_continuous(limits = c(0, NA), labels = scales::comma_format()) +
  # Specify a qualitative colour scheme should be used
  scale_colour_brewer(type = "qual") +
  # Add labels
  labs(
    x = NULL,
    y = "hourly total of aggravated assaults, 2010–2019",
    fill = NULL
  ) +
  theme_minimal()

# MAP CHANGE OVER TIME ---------------------------------------------------------

# Calculate number of assaults by shift
assaults_by_shift <- assaults |>
  # Restrict counts to just the central area of Chicago
  filter(district %in% c(1, 12, 18)) |>
  mutate(
    shift = case_when(
      between(hour(date), 6, 13) ~ "06:00 to 13:59",
      between(hour(date), 14, 21) ~ "14:00 to 21:59",
      hour(date) >= 22 | hour(date) < 6 ~ "22:00 to 05:59",
      TRUE ~ NA
    )
  ) |>
  # Convert the data to an SF object
  st_as_sf(coords = c("longitude", "latitude"), crs = "EPSG:4326") |>
  # Transform it to a coordinate reference system based on metres
  st_transform("EPSG:26916")

# Create a grid to be used for every shift-specific KDE layer
grid <- hotspot_grid(cpd_central, cell_size = 200)

# Estimate density of assaults for each CPD shift
kde_by_shift <- assaults_by_shift |>
  # Group dataset by which shift the assaults occurred in
  group_by(shift) |>
  # Separately estimate density of assaults for each shift
  group_modify(
    \(x, ...) hotspot_kde(x, grid = grid, bandwidth_adjust = 0.5, quiet = TRUE)
  ) |>
  # Ungroup the dataset
  ungroup() |>
  # Convert the result to an SF object (because although `hotspot_kde()` returns
  # an SF object, `group_modify()` silently converts it to a tibble)
  st_as_sf() |>
  # Clip the result to the boundary of the three central police districts
  hotspot_clip(cpd_central, quiet = TRUE)

# Create new dataset containing just the cells in each shift with the highest
# KDE values
kde_shift_highest <- kde_by_shift |>
  group_by(shift) |>
  slice_max(order_by = kde, n = 10)

# Add density map of assaults by shift
hotspot_map(
  kde_by_shift,
  aes(fill = kde),
  colour = NA,
  basemap_type = "cartolight",
  caption = "Crime data from Chicago Police Department"
) +
  # Highlight the cells with the highest density in each shift
  geom_sf(
    data = kde_shift_highest,
    alpha = 0.75,
    colour = "red2",
    fill = NA,
    linewidth = 1
  ) +
  # Add district boundaries
  geom_sf(data = cpd_central, colour = "grey33", fill = NA) +
  # Add scale to control fill colour of KDE cells
  scale_fill_distiller(
    direction = 1,
    breaks = range(pull(kde_by_shift, kde)),
    labels = c("low", "high"),
  ) +
  # Specify a separate map for each shift
  facet_grid(cols = vars(shift)) +
  # Add labels
  labs(
    title = "Aggravated assaults in downtown Chicago, 2010–2019",
    fill = "density of aggravated assaults"
  ) +
  theme(
    legend.position = "bottom",
    legend.title = element_text(hjust = 1)
  )
