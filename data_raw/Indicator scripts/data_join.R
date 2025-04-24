# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Join datasets ----
# I acknowledge the use of ChatGPT for assistance joining the rda files
ei_data <- list.files("data", full.names = TRUE) |> # List all files in the data folder
  keep(~ !str_starts(basename(.), "ei")) |> # Exclude files that start with ei (as none of the indicator datasets do)
  map(~ {
    env <- new.env() # Create new environment
    load(.x, envir = env) # Load rda files into environment
    get(ls(env)[1], envir = env) # Retrieve first object from environment
  }) |>
  reduce(full_join, by = "pcon_code") |> # Join all datasets by pcon_code
  mutate(across(-pcon_code, ~ as.numeric(as.character(.)))) # Convert all columns except pcon_code to numeric

# ---- Save output to data/ folder ----
usethis::use_data(ei_data, overwrite = TRUE)