# ---- Load packages ----
library(dplyr)
library(tidyverse)
library(purrr)
library(readr)
library(e1071)

# ---- Load data ----
load("data/ei_data_standardised.rda")
load("data/ei_la_lookup.rda")

# ---- Create subset of rows with missing data ----
ei_data_standardised_na <- ei_data_standardised |> 
  filter(if_any(everything(), is.na)) |> # Filter for rows including NA
  mutate_all(~ replace(., is.na(.), 0)) # Replace NA values with 0 (the mean for z scores)

# ---- Create composite score ----
# Subdomain 1
ei_data_standardised_na$attainment_subdomain <- 
  0.43 * ei_data_standardised_na$average_a_level_grade +
  0.52 * ei_data_standardised_na$average_gcse_grade +
  0.41 * ei_data_standardised_na$ks2_percent_meeting_standard +
  0.37 * ei_data_standardised_na$percent_progressed

# Subdomain 2
ei_data_standardised_na$deprivation_subdomain <- 
  0.50 * ei_data_standardised_na$weighted_percent_fsm +
  0.62 * ei_data_standardised_na$funding_per_pupil +
  0.46 * ei_data_standardised_na$pupil_to_qual_teacher_ratio

# Subdomain 3
ei_data_standardised_na$school_type_subdomain <- 
  0.60 * ei_data_standardised_na$weighted_percent_private +
  0.46 * ei_data_standardised_na$weighted_percent_academy

# Domain
ei_data_standardised_na$domain <- 
  ei_data_standardised_na$attainment_subdomain +
  ei_data_standardised_na$deprivation_subdomain +
  ei_data_standardised_na$school_type_subdomain

# ---- Transform scores to be similar to HIE scale ----
ei_index_na <- ei_data_standardised_na |>
  mutate(across(
    .cols = -pcon_code,  # Select all columns except pcon_code
    ~ (. + 10) * 10  # Add ten and multiply by 100 (to centre on mean of 100)
  ))

# ---- Add local authority information ----
ei_index_na <- inner_join(ei_la_lookup, ei_index_na, by = "pcon_code") # Join lookup file by pcon_code

# ---- Add asterisks to constituency codes and names ----
ei_index_na$pcon_name <- paste0(ei_index_na$pcon_name, "*") # So can identify columns with missing values

# ---- Save output to data/ folder ----
usethis::use_data(ei_index_na, overwrite = TRUE)