# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
private_dataset <- read.csv("downloaded_datasets/spc_school_level_underlying_data.csv")

# ---- Clean dataset ----
private <- private_dataset |>
  mutate(is_private = ifelse(phase_type_grouping %in% c("Independent school", 
                                                        "Non-maintained special school"), 1, 0)) |> # Create binary variable for private schools
  filter(!is.na(headcount.of.pupils)) |> # Remove rows with missing pupil counts
  group_by(parl_con_code) |> # Group schools by constituency
  summarize( # Create column for weighted percentage of pupils in private schools
    weighted_percent_private = sum(headcount.of.pupils * is_private)/sum(headcount.of.pupils)*100, # Weighted number private school pupils divided by total pupils per constituency, multiplied by 100 to get percentage
  ) |> 
  ungroup() |>
  select(pcon_code = parl_con_code, weighted_percent_private) |> # Select relevant columns
  filter(!str_starts(pcon_code, "Unknown")) # Remove the one row which isn't a constituency

# ---- Save output to data/ folder ----
usethis::use_data(private, overwrite = TRUE)