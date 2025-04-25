# ---- Load packages ----
library(tidyverse)
library(flextable)
library(officer)

# --- Load data ----
load("data/ei_index.rda")
load("data/ei_index_deciles.rda")

# ---- Clean data ----
ei_table <- inner_join(ei_index, ei_index_deciles, by = "pcon_code") |>
  ungroup() |>
  select(`Constituency name` = pcon_name.x, 
         `Authority name` = la_name.x, 
         `Attainment score` = attainment_subdomain, 
         `Attainment decile` = attainment_subdomain_decile, 
         `Deprivation score` = deprivation_subdomain, 
         `Deprivation decile` = deprivation_subdomain_decile, 
         `School type score` = school_type_subdomain, 
         `School type decile` = school_type_subdomain_decile, 
         `Domain score` = domain, 
         `Domain decile` = domain_decile) |>
  mutate(
    `Attainment score` = round(`Attainment score`, 1), # Round values to 1 dp
    `Deprivation score` = round(`Deprivation score`, 1),
    `School type score` = round(`School type score`, 1),
    `Domain score` = round(`Domain score`, 1)
  ) |>
  arrange(`Authority name`)

# ---- Convert data frame into a flextable ----
ft <- flextable(ei_table)

# Add table to word document
doc <- read_docx() |>
  body_add_flextable(ft)

# Save word document (will save in current wd)
print(doc, target = "my_table.docx")