# ---- Load packages ----
library(dplyr)
library(tidyverse)
library(purrr)
library(readr)
library(e1071)

# ---- Load dataset ---- 
ei_data <- read_csv("data/ei_data.csv")

# Create subset with no nas
ei_data_complete_case <- ei_data[complete.cases(ei_data), ]

# Check for outliers and skew
# Create function
outliers_skew <- function(x) {
  
  outliers <- sum(x < quantile(x, 0.25) - 1.5 * IQR(x) |
                    x > quantile(x, 0.75) + 1.5 * IQR(x))
  
  skew <- skewness(x)
  
  tibble(
    outliers = outliers,
    percent_outliers = round(100 * outliers / length(x), 2),
    skewness = round(skew, 2)
  )
}

# Run on dataset
outlier_skew_summary <- ei_data_complete_case |>
  select(-pcon_code) |>
  map_dfr(outliers_skew, .id = "indicator")
print(outlier_skew_summary)

# Log transform Allocation per pupil for constituency (avoid log(0) by adding a small constant)
ei_data_complete_case$`Allocation per pupil for constituency` <- log(ei_data_complete_case$`Allocation per pupil for constituency`)

# Log transform weighted_percent_private
ei_data_complete_case$weighted_percent_private <- log(ei_data_complete_case$weighted_percent_private + 1)

# Recheck skew after transformation
outlier_skew_summary_trans <- ei_data_complete_case |>
  select(-pcon_code) |>
  map_dfr(outliers_skew, .id = "indicator")

# Print updated skew summary
print(outlier_skew_summary_trans)

# Apply transformations to full dataset
ei_data$`Allocation per pupil for constituency` <- log(ei_data$`Allocation per pupil for constituency`)

# Log transform weighted_percent_private
ei_data$weighted_percent_private <- log(ei_data$weighted_percent_private + 1)

# Scale indicators
ei_data_scaled <- ei_data |>
  mutate(pupil_to_qual_teacher_ratio = pupil_to_qual_teacher_ratio * -1,
         weighted_percent_fsm = weighted_percent_fsm * -1,
  )

# Standardize using Z-scores (excluding pcon_code)
ei_data_standardised <- ei_data_scaled |>
  mutate(across(-pcon_code, ~ (.-mean(., na.rm = TRUE)) / sd(., na.rm = TRUE)))

# Save output to data/folder (so can be used for missing data build index)
write.csv(ei_data_standardised, "data/ei_data_standardised.csv", row.names = FALSE)

# Remove rows with NA values
# See missing data file 
ei_data_cleaned <- ei_data_standardised[complete.cases(ei_data), ]

# Perform PCA (excluding `pcon_code`)
pca_result <- prcomp(ei_data_standardised[, -1], center = TRUE, scale. = TRUE)

# Summary of PCA (explains variance per component)
summary(pca_result)

# View PCA loadings (how indicators contribute to each principal component)
pca_result$rotation

# View first few principal components (transformed data)
head(pca_result$x)

# Screeplot (decide on number of components)
screeplot(pca_result, type = "lines", main = "Scree Plot of PCA")

# Create the composite score
# Subdomain 1
ei_data_standardised$attainment_subdomain <- 
  -0.43 * ei_data_standardised$average_a_level_grade +
  -0.52 * ei_data_standardised$average_gcse_grade +
  -0.41 * ei_data_standardised$ks2_percent_meeting_standard +
  -0.37 * ei_data_standardised$percent_progressed

# Subdomain 2
ei_data_standardised$deprivation_subdomain <- 
  -0.50 * ei_data_standardised$weighted_percent_fsm +
  0.62 * ei_data_standardised$`Allocation per pupil for constituency` +
  0.46 * ei_data_standardised$pupil_to_qual_teacher_ratio

# Subdomain 3
ei_data_standardised$school_type_subdomain <- 
  0.60 * ei_data_standardised$weighted_percent_private +
  -0.46 * ei_data_standardised$weighted_percent_academy

# Composite score
ei_data_standardised$domain <- 
  ei_data_standardised$attainment_subdomain +
  ei_data_standardised$deprivation_subdomain +
  ei_data_standardised$school_type_subdomain

# Transform scores to be similar to HIE scale
ei_index_complete_case <- ei_data_standardised |>
  mutate(across(
    .cols = -pcon_code,  # Exclude pcon_code column
    .fns = ~ (. + 10) * 10  # Apply transformation to each column
  ))

# Save output to data/folder
write.csv(ei_index_complete_case, "data/ei_index_complete_case.csv", row.names = FALSE)
