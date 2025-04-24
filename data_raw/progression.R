# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
progression_dataset <- read.csv("downloaded_datasets/l4_tidy_2023_all_la_final.csv")

# ---- Clean dataset ----
progression <- progression_dataset |>
  filter(str_starts(time_period, '202021'), # Filter for only 2020/21 cohort (most recent data)
         str_starts(data_type, 'Percentage')) |> # Filter for percentages rather than raw counts
  filter(pcon_code != "") |> # Filter to only include data at constituency level
  select(pcon_code, percent_progressed = all_progressed) # Select relevant columns (percentage who progress to higher education/apprenticeship) 

# ---- Save output to data/ folder ----
usethis::use_data(progression, overwrite = TRUE)