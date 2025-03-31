# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
progression <- read.csv("downloaded_datasets/l4_tidy_2023_all_la_final.csv")

# ---- Clean dataset ----
ei_progression <- progression |>
  filter(str_starts(time_period, '202021'),
         str_starts(data_type, 'Percentage')) |>
  filter(pcon_code != "") |> # Filter to only include data at constituency level
  select(pcon_code,
         percent_progressed = all_progressed) # Percentage who progress to higher education/apprenticeship 

# ---- Save output to data/ folder ----
write.csv(ei_progression, "data/ei_progression.csv", row.names = FALSE)
