# ---- Load libraries ----
library(tidyverse)
library(dplyr)

# ---- Heatmap function ----
ei_heatmap_function <- function(data, column, title){
  ggplot(data) +
    geom_sf(aes(fill = .data[[column]])) + # Fill with EI index values and remove area borders
    scale_fill_viridis_c(option = "C") + # Use viridis colourpalette for clarity
    theme_minimal() + # Remove background elements 
    labs(title = title, fill = "EI decile") + # Add title and key
    theme(axis.text = element_blank()) # Remove axis labels
}

# ---- Lowest scoring heatmap function ----
# Create a new function to handle manual colors for binary categories
ei_heatmap_function_lowest <- function(data, column, title) {
  ggplot(data) +
    geom_sf(aes(fill = .data[[column]]), color = NA) +  # Fill with the binary column
    scale_fill_manual(values = c("0" = "viridis", "1" = "grey90")) +  # Assign specific colors to lowest (0) and other (1)
    theme_minimal() +  # Remove background elements
    labs(title = title, fill = "Lowest") +  # Add title and key
    theme(axis.text = element_blank(),  # Remove axis labels
          legend.title = element_blank())  # Remove legend title
}
