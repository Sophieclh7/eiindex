# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
la_lookup <- read.csv("downloaded_datasets/Ward_to_PCON_to_LAD_to_UTLA_(December_2023)_Lookup_in_the_UK.csv")

# ---- Clean dataset ----
ei_la_lookup <- la_lookup |>
  filter(str_starts(PCON23CD, "E")) |> # Filter to only include England
  group_by(PCON23CD) |> # Group by constituency code
  slice(1) |> # Collapse to only include a row for each constituency and their local authority
  select(pcon_code = PCON23CD, pcon_name = PCON23NM, la_code = UTLA23CD, la_name= UTLA23NM) # Select relevant columns

# Save to data/folder
usethis::use_data(ei_la_lookup, overwrite = TRUE)
