# ---- Load packages ----
library(dplyr)
library(tidyverse)
library(purrr)
library(readr)
library(e1071)

# ---- Load data ---- 
load("data/ei_data.rda")

# ---- Create complete case subset ----
ei_data_complete_case <- ei_data[complete.cases(ei_data), ] # Only include complete case rows (as cannot run outlier/skew test with NA values)

# ---- Check for outliers and skew ----
# Create function
outliers_skew <- function(x) {
  outliers <- sum(x < quantile(x, 0.25) - 1.5 * IQR(x) | # Identify outliers as those below Q1 - 1.5 x IQR
                    x > quantile(x, 0.75) + 1.5 * IQR(x)) # And those above Q3 + 1.5 x IQR
  skew <- skewness(x) # Check each indicator for skew
  tibble( # Print table of outliers and skew for each indicator
    outliers = outliers,
    skewness = round(skew, 2)
  )
}

# Run on dataset
outlier_skew_summary <- ei_data_complete_case |>
  select(-pcon_code) |> # Exclude pcon_code
  map_dfr(outliers_skew, .id = "indicator") # Binds the rows when displaying the table, so shows values for entire column rather than each row
print(outlier_skew_summary) # Print table of outliers and skew

# Apply log transformations
ei_data_complete_case$funding_per_pupil <- log(ei_data_complete_case$funding_per_pupil)
ei_data_complete_case$weighted_percent_private <- log(ei_data_complete_case$weighted_percent_private + 1)

# Recheck skew after transformations
outlier_skew_summary_transformed <- ei_data_complete_case |>
  select(-pcon_code) |>
  map_dfr(outliers_skew, .id = "indicator")
print(outlier_skew_summary_transformed)

# Apply transformations to full dataset (as before had excluded na rows)
ei_data$funding_per_pupil <- log(ei_data$funding_per_pupil)
ei_data$weighted_percent_private <- log(ei_data$weighted_percent_private + 1)

# ---- Standardise indicators ----
# Scale indicators
ei_data_scaled <- ei_data |>
  mutate(pupil_to_qual_teacher_ratio = pupil_to_qual_teacher_ratio * -1, # Ensure high values mean higher quality
         weighted_percent_fsm = weighted_percent_fsm * -1,
  )

# Standardize using Z-scores (excluding pcon_code)
ei_data_standardised <- ei_data_scaled |>
  mutate(across(-pcon_code, ~ (.-mean(., na.rm = TRUE)) / sd(., na.rm = TRUE))) # Ensure calculation ignores NA values

# ---- Save output to data/folder ----
usethis::use_data(ei_data_standardised, overwrite = TRUE)