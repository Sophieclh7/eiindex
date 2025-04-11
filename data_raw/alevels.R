# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
a_levels_dataset <- read.csv("downloaded_datasets/aggregated_attainment_by_pcon_202024.csv")

# Define the grade conversion
grade_conversion <- c(
  "A-" = 10, 
  "B+" = 9, 
  "B" = 8, 
  "B-" = 7,
  "C+" = 6, 
  "C" = 5, 
  "C-" = 4, 
  "D+" = 3,
  "D" = 2, 
  "E" = 1
)

# Pull 2023/24 grades for Worthing West and Warrington North for imputation
impute_data <- a_levels_dataset |>
  filter(str_starts(time_period, "202324"),
         pcon_name %in% c("Warrington North", "Worthing West")) |>
  mutate(average_a_level_grade = grade_conversion[aps_per_entry_grade_alev]) |>
  select(pcon_name, imputed_grade = average_a_level_grade)

# Clean 2022/23 data
a_levels <- a_levels_dataset |>
  filter(str_starts(time_period, "202223")) |>
  select(pcon_code, pcon_name, aps_per_entry_grade_alev) |>
  mutate(average_a_level_grade = grade_conversion[aps_per_entry_grade_alev]) |>
  left_join(impute_data, by = "pcon_name") |>
  mutate(
    average_a_level_grade = coalesce(average_a_level_grade, imputed_grade)
  ) |>
  select(pcon_code, average_a_level_grade)

# ---- Save output to data/ folder ----
write.csv(a_levels, "data/a_levels.csv", row.names = FALSE)
