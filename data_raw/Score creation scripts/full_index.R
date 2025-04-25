# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
load("data/ei_index_complete_case.rda")
load("data/ei_index_na.rda")

# ---- Join the two datasets ----
ei_index <- bind_rows(ei_index_complete_case, ei_index_na)

# ---- Add ^ symbol next to the pcon_code for the rows that used imputation ----
ei_index$pcon_name <- ifelse(ei_index$pcon_code %in% c("E14001055", "E14001017"), # Filter for Warrington North and Worthing West
                             paste0(ei_index$pcon_name, "^"),
                             ei_index$pcon_name) # Replaces original pcon_name column with the new column including ^

# ---- Save output to data/folder ----
usethis::use_data(ei_index, overwrite = TRUE)