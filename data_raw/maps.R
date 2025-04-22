# Load packages
library(sf)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(vtable)

# Load shapefile
shapefile_path <- "downloaded_datasets/Westminster_Parliamentary_Constituencies_Dec_2022_UK_BUC_7490486975279281621/PCON_DEC_2022_UK_BUC.shp"
constituencies_shapefile <- st_read(shapefile_path)

# Plot the geometries to inspect the boundaries
plot(st_geometry(constituencies_shapefile))

# Filter to only include England
constituencies_shapefile_england <- constituencies_shapefile |>
  filter(str_starts(PCON22CD, "E"))

# Check that worked
plot(st_geometry(constituencies_shapefile_england))

# Load ei index data
load("data/ei_index_deciles.rda")

# Join ei index data to spatial data
ei_spatial_data <- left_join(constituencies_shapefile_england, ei_index_deciles, by = c("PCON22CD" = "pcon_code"))

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
map1 <- ei_heatmap_function(ei_spatial_data, "domain_decile", "Heatmap of Educational Inequality (Domain Score)")
map2 <- ei_heatmap_function(ei_spatial_data, "attainment_subdomain_decile", "Heatmap of Educational Inequality (Attainment subdomain)")
map3 <- ei_heatmap_function(ei_spatial_data, "deprivation_subdomain_decile", "Heatmap of Educational Inequality (Deprivation subdomain)")
map4 <- ei_heatmap_function(ei_spatial_data, "school_type_subdomain_decile", "Heatmap of Educational Inequality (School type subdomain)")

# View heatmaps
print(map1)
print(map2)
print(map3)
print(map4)

# Create a new function to add binary variable column
# I acknowledge the use of ChatGPT to help create this function
lowest_scoring_function <- function(data, column) {
  data |>
    mutate(!!paste0(column, "_lowest") := 
             case_when(
               .data[[column]] %in% c(1, 2, 3) ~ "Lowest scoring (1-3rd Decile)",   
               .data[[column]] %in% c(4:10) ~ "Higher scoring (4-10th Decile)")) 
}

# Apply to create a binary column for each domain/subdomain
ei_spatial_data <- lowest_scoring_function(ei_spatial_data, "domain_decile")
ei_spatial_data <- lowest_scoring_function(ei_spatial_data, "attainment_subdomain_decile")
ei_spatial_data <- lowest_scoring_function(ei_spatial_data, "deprivation_subdomain_decile")
ei_spatial_data <- lowest_scoring_function(ei_spatial_data, "school_type_subdomain_decile")

# Create a new function to handle manual colors for the categories
ei_heatmap_function_lowest <- function(data, column, title) {
  ggplot(data) +
    geom_sf(aes(fill = .data[[column]]), color = NA) +  # Fill with the column
    scale_fill_manual(values = c("Lowest scoring (1-3rd Decile)" = "blue", 
                                 "Higher scoring (4-10th Decile)" = "grey90")) +  # Use names for categories
    theme_minimal() +  # Remove background elements
    labs(title = title) +  # Add title and key
    theme(axis.text = element_blank())  # Remove axis labels
}

# Apply the function to create maps
map5 <- ei_heatmap_function_lowest(ei_spatial_data, "domain_decile_lowest", "Lowest scoring areas (Domain score)")
map6 <- ei_heatmap_function_lowest(ei_spatial_data, "attainment_subdomain_decile_lowest", "Lowest scoring areas (Attainment subdomain score)")
map7 <- ei_heatmap_function_lowest(ei_spatial_data, "deprivation_subdomain_decile_lowest", "Lowest scoring areas (Deprivation subdomain score)")
map8 <- ei_heatmap_function_lowest(ei_spatial_data, "school_type_subdomain_decile_lowest", "Lowest scoring areas (School type subdomain score)")

# View updated heatmaps
print(map5)
print(map6)
print(map7)
print(map8)

# Create subset of constituencies in lowest three deciles for all subdomains
lowest_scoring <- ei_spatial_data |>
  filter(str_starts(attainment_subdomain_decile_lowest, "Low"),
         str_starts(deprivation_subdomain_decile_lowest, "Low"),
         str_starts(school_type_subdomain_decile_lowest, "Low"))

# Create histograms for domain and subdomain scores
load("data/ei_index.rda")
hist(ei_index$domain)