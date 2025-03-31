# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
ks2 <- read.csv("downloaded_datasets/ks2_parliamentary_constituency_2019_to_2023_revised.csv")

# ---- Clean dataset ----
ei_ks2 <- ks2 |>
  filter(str_starts(time_period, "202223")) |> # Filter to only include data from 2022/23
  filter(!str_starts(geographic_level, "National")) |> # Remove row containing national average grade
  select(pcon_code,
         ks2_percent_meeting_standard = pt_rwm_met_expected_standard)

# ---- Save output to data/ folder ----
write.csv(ei_a_levels, "data/ei_ks2.csv", row.names = FALSE)
