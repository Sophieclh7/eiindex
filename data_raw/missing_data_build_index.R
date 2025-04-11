# Load data
ei_data_standardised <- read.csv("data/ei_data_standardised.csv")

# Create subset of rows with missing data
ei_data_standardised_na <- ei_data_standardised |> 
  filter(if_any(everything(), is.na))

# Replace all NA values with 0
ei_data_standardised_na <- ei_data_standardised_na |> 
  mutate_all(~ replace(., is.na(.), 0))

# Create the composite score
# Subdomain 1
ei_data_standardised_na$attainment_subdomain <- 
  -0.43 * ei_data_standardised_na$average_a_level_grade +
  -0.52 * ei_data_standardised_na$average_gcse_grade +
  -0.41 * ei_data_standardised_na$ks2_percent_meeting_standard +
  -0.37 * ei_data_standardised_na$percent_progressed

# Subdomain 2
ei_data_standardised_na$deprivation_subdomain <- 
  -0.50 * ei_data_standardised_na$weighted_percent_fsm +
  0.62 * ei_data_standardised_na$`Allocation.per.pupil.for.constituency` +
  0.46 * ei_data_standardised_na$pupil_to_qual_teacher_ratio

# Subdomain 3
ei_data_standardised_na$school_type_subdomain <- 
  0.60 * ei_data_standardised_na$weighted_percent_private +
  -0.46 * ei_data_standardised_na$weighted_percent_academy

# Composite score
ei_data_standardised_na$domain <- 
  ei_data_standardised_na$attainment_subdomain +
  ei_data_standardised_na$deprivation_subdomain +
  ei_data_standardised_na$school_type_subdomain

# Transform scores to be similar to HIE scale
ei_index_na <- ei_data_standardised_na |>
  mutate(across(
    .cols = -pcon_code,  # Exclude pcon_code column
    .fns = ~ (. + 10) * 10  # Apply transformation to each column
  ))

# Add asterisks to pcon_code and any value in the dataset that is 100
ei_index_na <- ei_index_na |>
  mutate(across(
    .cols = everything(),  # Apply to all columns
    .fns = ~ ifelse(. == 100, paste0(., "*"), .)  # If the value is 100, append "*"
  ))

# Add asterisks to the pcon_code column (for all rows)
ei_index_na$pcon_code <- paste0(ei_index_na$pcon_code, "*")
