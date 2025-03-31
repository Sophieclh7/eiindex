# ---- Load packages ----
library(openxlsx)
library(tidyverse)
library(dplyr)

# ---- Load data ----
funding <- read.xlsx("downloaded_datasets/Schoolfunding.xlsx", sheet = "data", rows = 2:4799, cols = 1:20)

# ---- Clean dataset ----
ei_funding <- funding |>
  filter(str_starts(Year, "2022-23")) |> # Filter to only include data from 2022/23
  select(pcon_code = ONSconstID,
         `Allocation per pupil for constituency` = `Cons,.Allocation.per.Pupil.(Real)`)

# ---- Save output to data/ folder ----
write.csv(ei_funding, "data/ei_funding.csv", row.names = FALSE)
