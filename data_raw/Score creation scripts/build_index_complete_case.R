# ---- Load packages ----
library(dplyr)
library(tidyverse)
library(purrr)
library(readr)
library(e1071)

# ---- Load data ----
load("data/ei_data_standardised.rda")
load("data/ei_la_lookup.rda")

# ---- PCA ----
# Remove rows with NA values (as PCA can't run with nas)
# See missing data file 
ei_data_cleaned <- ei_data_standardised[complete.cases(ei_data_standardised), ]

# Perform PCA (excluding `pcon_code`)
pca_result <- prcomp(ei_data_cleaned[, -1], center = TRUE, scale. = TRUE)

# Summary of PCA (explains variance per component)
summary(pca_result)

# View PCA loadings (how indicators contribute to each principal component)
pca_result$rotation

# View first few principal components
head(pca_result$x)

# Screeplot (to decide on number of components)
screeplot(pca_result, type = "lines", main = "Scree Plot of PCA")

# ---- Create composite score ----
# Subdomain 1
ei_data_cleaned$attainment_subdomain <- 
  0.43 * ei_data_cleaned$average_a_level_grade +
  0.52 * ei_data_cleaned$average_gcse_grade +
  0.41 * ei_data_cleaned$ks2_percent_meeting_standard +
  0.37 * ei_data_cleaned$percent_progressed

# Subdomain 2
ei_data_cleaned$deprivation_subdomain <- 
  0.50 * ei_data_cleaned$weighted_percent_fsm +
  0.62 * ei_data_cleaned$funding_per_pupil +
  0.46 * ei_data_cleaned$pupil_to_qual_teacher_ratio

# Subdomain 3
ei_data_cleaned$school_type_subdomain <- 
  0.60 * ei_data_cleaned$weighted_percent_private +
  0.46 * ei_data_cleaned$weighted_percent_academy

# Domain
ei_data_cleaned$domain <- 
  ei_data_cleaned$attainment_subdomain +
  ei_data_cleaned$deprivation_subdomain +
  ei_data_cleaned$school_type_subdomain

# ---- Transform scores to be similar to HIE scale ----
ei_index_complete_case <- ei_data_cleaned |>
  mutate(across(
    .cols = -pcon_code,  # Select all columns except pcon_code
    ~ (. + 10) * 10  # Add ten and multiply by 100 (to centre on mean of 100)
  ))

# ---- Add local authority information ----
ei_index_complete_case <- inner_join(ei_la_lookup, ei_index_complete_case, by = "pcon_code")

# Save output to data/folder
usethis::use_data(ei_index_complete_case, overwrite = TRUE)