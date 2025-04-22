# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
pt_ratio_dataset <- read.csv("downloaded_datasets/workforce_ptrs_2010_2023_pcon.csv")

# ---- Clean dataset ----
pt_ratio <- pt_ratio_dataset |>
  filter(str_starts(time_period, "202223")) |> # Filter to only include data from 2022/23
  select(pcon_code,
         pupil_to_qual_teacher_ratio)

# ---- Save output to data/ folder ----
usethis::use_data(pt_ratio, overwrite = TRUE)