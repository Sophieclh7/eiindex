# ---- Load packages ----
library(tidyverse)
library(dplyr)

# ---- Load data ----
load("data/ei_index.rda")

# ---- Create decile columns for each domain/subdomain ----
ei_index_deciles <- ei_index |>
  ungroup() |> # Make sure data isn't grouped
  mutate(
    attainment_subdomain_decile = ntile(attainment_subdomain, 10), # Split data into deciles
    deprivation_subdomain_decile = ntile(deprivation_subdomain, 10),
    school_type_subdomain_decile = ntile(school_type_subdomain, 10),
    domain_decile = ntile(domain, 10)
  ) |>
  select(pcon_code, pcon_name, la_code, la_name, attainment_subdomain_decile, # Select relevant columns
         deprivation_subdomain_decile, school_type_subdomain_decile, domain_decile)

# ---- Save output to data/ folder ----
usethis::use_data(ei_index_deciles, overwrite = TRUE)