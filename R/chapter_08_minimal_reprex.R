#' ---
#' output:
#'   reprex::reprex_document:
#'     advertise: FALSE
#' ---

pacman::p_load(sfhotspot, tidyverse)

memphis_robberies_jan +
  hotspot_map(basemap_type = "none")
