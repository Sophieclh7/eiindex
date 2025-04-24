# Educational Inequality Index

## Overview

Dissertation repository containing code and datasets used to create the educational inequality index

## Installation

You can install the eiindex package using: 

``` r
install.packages("devtools")
library(devtools)
devtools::install_github("Sophieclh7/eiindex")
library(eiindex)
```
## View scripts

You can view R scripts in R using:

``` r
system.file("scripts", package = "eiindex") # To find the script path
file.edit(system.file("scripts", "your_script_name.R", package = "eiindex")) # To open a specific script
```

## View datasets

You can view datasets in R using:

``` r
data(package = "eiindex") # For all datasets
data("dataset_name", package = "eiindex") # For a specific dataset
```

To view documentation for datasets, use:

``` r
?datasetname
```