# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
private_dataset <- read.csv("downloaded_datasets/spc_school_level_underlying_data.csv")

# ---- Clean dataset ----
private <- private_dataset |>
  select(pcon_code = parl_con_code,
         phase_type_grouping, 
         headcount.of.pupils) |> 
  mutate(is_private = ifelse(phase_type_grouping %in% c("Independent school", 
                                                        "Non-maintained special school"), 1, 0)) |> # Create binary variable for private schools
  filter(!is.na(headcount.of.pupils)) |> # Remove rows with missing pupil counts
  group_by(pcon_code) |> # Created column for weighted percentage of pupils in private schools
  summarize(
    total_pupils = sum(headcount.of.pupils), # Total pupils per constituency
    private_pupils = sum(headcount.of.pupils * is_private), # Sum pupils in private schools
    weighted_percent_private = (private_pupils / total_pupils) * 100, # Weighted percentage pupils in private schools
    .groups = "drop"
  ) |> 
  select(pcon_code,
         weighted_percent_private) |>
  filter(!str_starts(pcon_code, "Unknown")) # Remove the one row which isn't a constituency

# ---- Save output to data/ folder ----
write.csv(private, "data/private.csv", row.names = FALSE)

  