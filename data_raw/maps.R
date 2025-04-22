# Load packages
library(sf)
library(dplyr)
library(tidyverse)
library(ggplot2)

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
ei_index_deciles <- read.csv("data/ei_index_deciles.csv")

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