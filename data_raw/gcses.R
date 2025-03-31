# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
gcses <- read.csv("downloaded_datasets/2223_sl_pcon_data_revised.csv")

# ---- Clean dataset ----
ei_gcses <- gcses |>
  filter(!str_starts(geographic_level, "National")) |> # Remove row containing national average grade
  select(pcon_code,
         average_gcse_grade = avg_att8) # Filter for average attainment 8 grade

# ---- Save output to data/ folder ----
write.csv(ei_gcses, "data/ei_gcses.csv", row.names = FALSE)
