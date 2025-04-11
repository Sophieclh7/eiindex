# ---- Join datasets ---- 

# Load package
library(stringr)

# List all CSV files in the "data" folder
files <- list.files(path = "data", pattern = "\\.csv$", full.names = TRUE)

# Exclude files that start with "ei"
files <- files[!str_starts(basename(files), "ei")]

# Read all datasets into a list
datasets <- lapply(files, read_csv)

# Join all datasets by "pcon_code"
ei_data <- reduce(datasets, full_join, by = "pcon_code") |>
  mutate(across(-pcon_code, ~ as.numeric(as.character(.))))

# ---- Save output to data/ folder ----
write.csv(ei_data, "data/ei_data.csv", row.names = FALSE)
