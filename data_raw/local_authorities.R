# Load data
la_lookup <- read.csv("downloaded_datasets/Ward_to_PCON_to_LAD_to_UTLA_(December_2023)_Lookup_in_the_UK.csv")

# Filter data
ei_la_lookup <- la_lookup |>
  select(pcon_code = PCON23CD,
         pcon_name = PCON23NM,
         la_code = UTLA23CD,
         la_name = UTLA23NM,
         ward_code = WD23CD,
         ward_name = WD23NM
  ) |>
  filter(str_starts(pcon_code, "E")) |> # Only include England
  group_by(pcon_code, pcon_name) |> # Collapse to only include a row for each constituency and their local authority
  slice(1) |>
  ungroup() |>
  select(pcon_code, # Select relevant columns
         pcon_name,
         la_code,
         la_name)

# Save to data/folder
usethis::use_data(ei_la_lookup, overwrite = TRUE)
