# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
fsm_dataset <- read.csv("downloaded_datasets/spc_school_level_underlying_data.csv")

# ---- Clean dataset ----
fsm <- fsm_dataset |>
  select(pcon_code = parl_con_code,
         headcount.of.pupils,
         percent_fsm = X..of.pupils.known.to.be.eligible.for.free.school.meals) |>
  mutate(percent_fsm = na_if(percent_fsm, "z")) |>  # Convert missing values to NA
  filter(!is.na(percent_fsm), !is.na(headcount.of.pupils)) |>  # Remove rows containing NAs
  mutate(percent_fsm = as.numeric(percent_fsm)) |>  # Convert free school meals column to numeric
  group_by(pcon_code) |>  # Create column for weighted percentage of pupils eligible for free school meals
  summarize(
    weighted_percent_fsm = sum(percent_fsm * headcount.of.pupils)/sum(headcount.of.pupils),
    total_pupils = sum(headcount.of.pupils),  # Total pupils per constituency
    .groups = "drop"
  ) |> 
  select(pcon_code,
         weighted_percent_fsm) |>
  filter(!str_starts(pcon_code, "Unknown")) # Remove the one row which isn't a constituency

# ---- Save output to data/ folder ----
write.csv(fsm, "data/fsm.csv", row.names = FALSE)
