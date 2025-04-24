# ---- Load packages ----
library(openxlsx)
library(tidyverse)
library(dplyr)

# ---- Load data ----
funding_dataset <- read.xlsx("downloaded_datasets/Schoolfunding.xlsx", sheet = "data", rows = 2:4799, cols = 1:20)

# ---- Clean dataset ----
funding <- funding_dataset |>
  filter(str_starts(Year, "2022-23")) |> # Filter to only include data from 2022/23
  select(pcon_code = ONSconstID, `funding_per_pupil` = `Cons,.Allocation.per.Pupil.(Real)`) # Select relevant columns

# ---- Save output to data/ folder ----
usethis::use_data(funding, overwrite = TRUE)