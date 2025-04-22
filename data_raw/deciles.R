# Load data
load("data/ei_index.rda")

# Add deciles to each subdomain and the domain
ei_index_deciles <- ei_index |>
  mutate(
    attainment_subdomain_decile = ntile(attainment_subdomain, 10),
    deprivation_subdomain_decile = ntile(deprivation_subdomain, 10),
    school_type_subdomain_decile = ntile(school_type_subdomain, 10),
    domain_decile = ntile(domain, 10)
  ) |>
  select(
    pcon_code,
    pcon_name,
    la_code,
    la_name,
    attainment_subdomain_decile,
    deprivation_subdomain_decile,
    school_type_subdomain_decile,
    domain_decile
  )

# Save to data/folder
usethis::use_data(ei_index_deciles, overwrite = TRUE)