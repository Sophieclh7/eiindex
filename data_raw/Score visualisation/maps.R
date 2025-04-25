# ---- Load packages ----
library(sf)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(vtable)

# ---- Load data ----
load("data/ei_index_deciles.rda")
shapefile_path <- "downloaded_datasets/Westminster_Parliamentary_Constituencies_Dec_2022_UK_BUC_7490486975279281621/PCON_DEC_2022_UK_BUC.shp"
constituencies_shapefile <- st_read(shapefile_path)

# ---- Filter shapefile ----
constituencies_shapefile_england <- constituencies_shapefile |>
  filter(str_starts(PCON22CD, "E")) # Filter to only include England

# ---- Join ei index data to spatial data ----
ei_spatial_data <- left_join(constituencies_shapefile_england, ei_index_deciles, by = c("PCON22CD" = "pcon_code"))

# ---- Get summary statistics for index ----
st(ei_index) # Summary statistics table

# ---- Create heatmaps ----
# Create heatmap function
ei_heatmap_function <- function(data, column, title){
  ggplot(data) +
    geom_sf(aes(fill = .data[[column]]), color = NA) + # Fill with EI index values and remove area borders
    scale_fill_viridis_c(option = "C") + # Use viridis colourpalette for clarity
    theme_minimal() + # Remove background elements 
    labs(title = title, fill = "EI decile") + # Add title and key
    theme(axis.text = element_blank()) # Remove axis labels
}

# Run function on each domain/subdomain
domain_map <- ei_heatmap_function(ei_spatial_data, "domain_decile", "Heatmap of Educational Inequality (Domain Score)")
attainment_map <- ei_heatmap_function(ei_spatial_data, "attainment_subdomain_decile", "Heatmap of Educational Inequality (Attainment subdomain)")
deprivation_map <- ei_heatmap_function(ei_spatial_data, "deprivation_subdomain_decile", "Heatmap of Educational Inequality (Deprivation subdomain)")
school_type_map <- ei_heatmap_function(ei_spatial_data, "school_type_subdomain_decile", "Heatmap of Educational Inequality (School type subdomain)")

# View heatmaps
print(domain_map)
print(attainment_map)
print(deprivation_map)
print(school_type_map)

# ---- Create lowest scoring areas maps ----
# Create a new function to add binary variable column
lowest_scoring_function <- function(data, column) {
  data |>
    mutate(!!paste0(column, "_lowest") := # Add column called domain/subdomain_lowest for lowest scoring binary variable
             case_when(
               .data[[column]] %in% c(1, 2, 3) ~ "Lowest scoring (1-3rd Decile)", # Assign areas in 1-3rd decile as lower scoring
               .data[[column]] %in% c(4:10) ~ "Higher scoring (4-10th Decile)")) # Assign areas in 4-10th decile as higher scoring
}

# Apply function to each domain/subdomain column
ei_spatial_data <- lowest_scoring_function(ei_spatial_data, "domain_decile")
ei_spatial_data <- lowest_scoring_function(ei_spatial_data, "attainment_subdomain_decile")
ei_spatial_data <- lowest_scoring_function(ei_spatial_data, "deprivation_subdomain_decile")
ei_spatial_data <- lowest_scoring_function(ei_spatial_data, "school_type_subdomain_decile")

# Create new function for lowest scoring map
ei_heatmap_function_lowest <- function(data, column, title) {
  ggplot(data) +
    geom_sf(aes(fill = .data[[column]]), color = NA) +  # Fill with the column
    scale_fill_manual(values = c("Lowest scoring (1-3rd Decile)" = "blue", 
                                 "Higher scoring (4-10th Decile)" = "grey90")) +  # Use names for categories
    theme_minimal() +  # Remove background elements
    labs(title = title) +  # Add title and key
    theme(axis.text = element_blank())  # Remove axis labels
}

# Apply the function to each domain/subdomain
domain_map_lowest <- ei_heatmap_function_lowest(ei_spatial_data, "domain_decile_lowest", "Lowest scoring areas (Domain score)")
attainment_map_lowest <- ei_heatmap_function_lowest(ei_spatial_data, "attainment_subdomain_decile_lowest", "Lowest scoring areas (Attainment subdomain score)")
deprivation_map_lowest <- ei_heatmap_function_lowest(ei_spatial_data, "deprivation_subdomain_decile_lowest", "Lowest scoring areas (Deprivation subdomain score)")
school_type_map_lowest <- ei_heatmap_function_lowest(ei_spatial_data, "school_type_subdomain_decile_lowest", "Lowest scoring areas (School type subdomain score)")

# View maps
print(domain_map_lowest)
print(attainment_map_lowest)
print(deprivation_map_lowest)
print(school_type_map_lowest)

# ---- Create subset of constituencies in lowest three deciles for all subdomains ----
lowest_scoring <- ei_spatial_data |>
  filter(str_starts(attainment_subdomain_decile_lowest, "Low"),
         str_starts(deprivation_subdomain_decile_lowest, "Low"),
         str_starts(school_type_subdomain_decile_lowest, "Low"))