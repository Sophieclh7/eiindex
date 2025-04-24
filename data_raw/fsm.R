# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
fsm_dataset <- read.csv("downloaded_datasets/spc_school_level_underlying_data.csv")

# ---- Clean dataset ----
fsm <- fsm_dataset |>
  rename(percent_fsm = X..of.pupils.known.to.be.eligible.for.free.school.meals) |>
  mutate(percent_fsm = na_if(percent_fsm, "z")) |>  # Convert missing values to NA
  filter(!is.na(percent_fsm), !is.na(headcount.of.pupils)) |>  # Remove rows containing NAs
  mutate(percent_fsm = as.numeric(percent_fsm)) |>  # Convert free school meals column to numeric
  group_by(parl_con_code) |> # Groups schools by constituency
  summarize( # Create column for weighted percentage of pupils eligible for FSMs
    weighted_percent_fsm = sum(percent_fsm * headcount.of.pupils)/sum(headcount.of.pupils), # Weighted pupils eligible for FSMs divide by total pupils in constituency
  ) |> 
  select(pcon_code = parl_con_code,
         weighted_percent_fsm) |>
  filter(!str_starts(pcon_code, "Unknown")) # Remove the one row which isn't a constituency

# ---- Save output to data/ folder ----
usethis::use_data(fsm, overwrite = TRUE)
