# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
a_levels_dataset <- read.csv("downloaded_datasets/aggregated_attainment_by_pcon_202024.csv")

# Convert z values to na
a_levels_dataset <- a_levels_dataset |>
  mutate(
    aps_per_entry_alev = na_if(aps_per_entry_alev, "z"),
    aps_per_entry_alev = as.numeric(aps_per_entry_alev)  # force other non-numeric to NA
  )

# Pull 2023/24 imputation data
impute_data <- a_levels_dataset |>
  filter(str_starts(time_period, "202324"),
         pcon_name %in% c("Warrington North", "Worthing West")) |>
  select(pcon_name, imputed_grade = aps_per_entry_alev)

# Clean and impute 2022/23 data
a_levels <- a_levels_dataset |>
  filter(str_starts(time_period, "202223")) |>
  select(pcon_code, pcon_name, aps_per_entry_alev) |>
  left_join(impute_data, by = "pcon_name") |>
  mutate(
    average_a_level_grade = coalesce(aps_per_entry_alev, imputed_grade)
  ) |>
  select(pcon_code, average_a_level_grade)

# ---- Save output to data/ folder ----
usethis::use_data(a_levels, overwrite = TRUE)
