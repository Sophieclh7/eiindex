# ---- Join datasets ---- 

# ---- Load packages ----
library(tidyverse)
library(dplyr)

# I acknowledge the use of ChatGPT for assistance joining the rda files
# ---- Load all .rda files ----
rda_files <- list.files(path = "data", pattern = "\\.rda$", full.names = TRUE)

# Load each RDA file and extract the object
datasets <- lapply(rda_files, function(file) {
  env <- new.env()
  load(file, envir = env)
  get(ls(env)[1], envir = env)
})

# ---- Join all datasets by "pcon_code" ----
ei_data <- reduce(datasets, full_join, by = "pcon_code") |>
  mutate(across(-pcon_code, ~ as.numeric(as.character(.))))

# ---- Save output to data/ folder ----
usethis::use_data(ei_data, overwrite = TRUE)
