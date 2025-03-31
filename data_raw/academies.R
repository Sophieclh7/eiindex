# ---- Load packages ----
library(tidyverse)
library(dplyr)
library(stringr)

# ---- Load data ----
academies <- read.csv("downloaded_datasets/spc_school_level_underlying_data.csv")

# ---- Clean dataset ----
ei_academies <- academies |>
  select(pcon_code = parl_con_code,
         typeofestablishment_name, 
         headcount.of.pupils) |>
  mutate(is_academy = ifelse(str_detect(typeofestablishment_name, "Academy"), 1, 0)) |> # Create binary variable for academies
  filter(!is.na(headcount.of.pupils)) |> # Remove rows with missing pupil counts
  group_by(pcon_code) |>  
  summarize( # Create column for weighted percentage of pupils in academies
    total_pupils = sum(headcount.of.pupils), # Total pupils per constituency
    academy_pupils = sum(headcount.of.pupils * is_academy), # Sum pupils in academies
    weighted_percent_academy = (academy_pupils / total_pupils) * 100, #Weighted percentage pupils in academies
    .groups = "drop"
  ) |> 
  select(pcon_code, 
         weighted_percent_academy) |>
  filter(!str_starts(pcon_code, "Unknown")) # Remove the one row which isn't a constituency 

# ---- Save output to data/ folder ----
write.csv(ei_academies, "data/ei_academies.csv", row.names = FALSE)

