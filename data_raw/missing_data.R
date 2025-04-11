# Check which rows have nas
ei_data_na <- ei_data |> 
  filter(if_any(everything(), is.na))

# Join na data to pcon_names
# To see which constituencies have missing data
pcon_names <- read.csv("downloaded_datasets/2223_sl_pcon_data_revised.csv")
pcon_names_filtered <- pcon_names |>
  filter(!str_starts(geographic_level, "National")) |>
  select(pcon_code,
         pcon_name)
pcon_names_joined <- inner_join(pcon_names_filtered, ei_data_na, by = "pcon_code") |>
  select(pcon_code, pcon_name, percent_progressed, average_a_level_grade)

# Check a level dataset for whether missing every year
a_levels <- read.csv("downloaded_datasets/aggregated_attainment_by_pcon_202024.csv")
na_pcons <- c(
  "Barnsley East", "Blackpool South", "Bolsover", "Bolton West",
  "Bury South", "Denton and Reddish", "Dudley South", "Fylde",
  "Hazel Grove", "Houghton and Sunderland South", "Meon Valley", "North West Hampshire",
  "Portsmouth South", "Romsey and Southampton North", "Stalybridge and Hyde", "Stockton North",
  "Warrington North", "Worsley and Eccles South", "Worthing West"
)
a_levels_filtered <- a_levels |>
  filter(pcon_name %in% na_pcons) |>
  select(pcon_code,
         pcon_name,
         time_period,
         average_a_level_grade = aps_per_entry_grade_alev)

a_levels_available <- a_levels_filtered |>
  filter(!str_starts(average_a_level_grade, "z"))

a_levels_unavailable <- a_levels_filtered |>
  filter(str_starts(average_a_level_grade, "z"),
         str_starts(time_period, "202324"))

# Do the same for progression
progression <- read.csv("downloaded_datasets/l4_tidy_2023_all_la_final.csv")
progression_filtered <- progression |>
  filter(str_starts(data_type, 'Percentage')) |>
  filter(pcon_code != "") |> # Filter to only include data at constituency level
  filter(pcon_name %in% na_pcons) |>
  select(pcon_code,
         pcon_name,
         time_period,
         percent_progressed = all_progressed)

progression_available <- progression_filtered |>
  filter(!str_starts(percent_progressed, "z"))
         
progression_unavailable <- a_levels_filtered |>
  filter(str_starts(average_a_level_grade, "z"),
         !str_starts(time_period, "202021"))       

         