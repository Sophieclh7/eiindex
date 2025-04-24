# ---- Load packages ----
library(tidyverse)
library(dplyr)
library(stringr)

# ---- Load data ----
academies_dataset <- read.csv("downloaded_datasets/spc_school_level_underlying_data.csv")

# ---- Clean dataset ----
academies <- academies_dataset |>
  mutate(is_academy = ifelse(str_detect(typeofestablishment_name, "Academy"), 1, 0)) |> # Create binary variable for academies
  filter(!is.na(headcount.of.pupils)) |> # Remove rows with missing pupil counts
  group_by(parl_con_code) |> # Groups schools by constituency
  summarize( # Create column for weighted percentage of pupils in academies
    weighted_percent_academy = sum(headcount.of.pupils * is_academy)/sum(headcount.of.pupils)*100, # Weighted number academy pupils divided by total pupils per constituency, multiplied by 100 to get percentage
  ) |> 
  ungroup() |>
  select(pcon_code = parl_con_code, weighted_percent_academy) |> # Select relevant columns
  filter(!str_starts(pcon_code, "Unknown")) 

# ---- Save output to data/ folder ----
usethis::use_data(academies, overwrite = TRUE)
