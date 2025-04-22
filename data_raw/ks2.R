# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
ks2_dataset <- read.csv("downloaded_datasets/ks2_parliamentary_constituency_2019_to_2023_revised.csv")

# ---- Clean dataset ----
ks2 <- ks2_dataset |>
  filter(str_starts(time_period, "202223"), # Filter to only include data from 2022/23
         !str_starts(geographic_level, "National")) |> # Remove row containing national average grade
  select(pcon_code,
         ks2_percent_meeting_standard = pt_rwm_met_expected_standard)

# ---- Save output to data/ folder ----
usethis::use_data(ks2, overwrite = TRUE)