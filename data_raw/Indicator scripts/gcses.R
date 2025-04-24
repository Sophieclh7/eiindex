# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
gcses_dataset <- read.csv("downloaded_datasets/2223_sl_pcon_data_revised.csv")

# ---- Clean dataset ----
gcses <- gcses_dataset |>
  filter(!str_starts(geographic_level, "National")) |> # Remove row containing national average grade
  select(pcon_code, average_gcse_grade = avg_att8) # Select relevant columns

# ---- Save output to data/ folder ----
usethis::use_data(gcses, overwrite = TRUE)