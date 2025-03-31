# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
a_levels <- read.csv("downloaded_datasets/aggregated_attainment_by_pcon_202024.csv")

# ---- Clean dataset ----
ei_a_levels <- a_levels |>
  filter(str_starts(time_period, "202223")) |> # Filter to only include data from 2022/23
  select(pcon_code,
         average_a_level_grade = aps_per_entry_grade_alev)|>
  mutate(average_a_level_grade = case_when(
    average_a_level_grade == "A-" ~ 10,
    average_a_level_grade == "B+" ~ 9,
    average_a_level_grade == "B"  ~ 8,
    average_a_level_grade == "B-" ~ 7,
    average_a_level_grade == "C+" ~ 6,
    average_a_level_grade == "C"  ~ 5,
    average_a_level_grade == "C-" ~ 4,
    average_a_level_grade == "D+" ~ 3,
    average_a_level_grade == "D"  ~ 2,
    average_a_level_grade == "E"  ~ 1,
  ))

# ---- Save output to data/ folder ----
write.csv(ei_a_levels, "data/ei_a_levels.csv", row.names = FALSE)
