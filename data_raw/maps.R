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
ei_index <- read.csv("data/ei_index.csv")

# Join ei index data to spatial data
joined_data <- left_join(constituencies_shapefile_england, ei_index, by = c("PCON22CD" = "pcon_code"))

# Create heatmap for domain scores
ggplot(joined_data) +
  geom_sf(aes(fill = domain), color = NA) +
  scale_fill_viridis_c(option = "C", na.value = "grey80") +
  theme_minimal() +
  labs(title = "Heatmap of Educational Inequality (Composite Score)",
       fill = "EI Score") +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank())
