# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
a_levels_dataset <- read.csv("downloaded_datasets/aggregated_attainment_by_pcon_202024.csv")

# Convert z values to na (for imputation to work)
a_levels_dataset <- a_levels_dataset |>
  mutate(
    aps_per_entry_alev = na_if(aps_per_entry_alev, "z"),
  )

# Filter for imputation data
impute_data <- a_levels_dataset |>
  filter(str_starts(time_period, "202324"), # Filter for only 2023/24
         pcon_name %in% c("Warrington North", "Worthing West")) |> # Filter for only Warrington North and Worthing West
  select(pcon_name, imputed_grade = aps_per_entry_alev) # Select relevant columns

# Clean and impute 2022/23 data
a_levels <- a_levels_dataset |>
  filter(str_starts(time_period, "202223")) |> # Filter for only 2022/23
  left_join(impute_data, by = "pcon_name") |> # Has to be done by pcon name rather than code because codes changed
  mutate(
    average_a_level_grade = coalesce(aps_per_entry_alev, imputed_grade) # Impute 2023/24 values for Warrington North and Worthing West 
  ) |>
  select(pcon_code, average_a_level_grade) # Select relevant columns

# ---- Save output to data/ folder ----
usethis::use_data(a_levels, overwrite = TRUE)