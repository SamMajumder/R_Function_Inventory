

library(raster)
library(stars)
library(sf)
library(here)
library(tidyverse)

rm(list = ls())


raster_pipeline_point <- function(inputs, 
                                  df = NULL, 
                                  lat_col = NULL, 
                                  lon_col = NULL, 
                                  split_id = NULL, 
                                  search_strings = NULL, 
                                  resample_factor = NULL,
                                  crs = st_crs(4326),
                                  method = "bilinear",
                                  no_data_value = -9999,
                                  reference_shape = NULL) {
  
  # Internal function to process a single raster 
  process_raster <- function(input) {
    # Check if the file exists
    if (!file.exists(input)) {
      stop(paste("Error: The file", input, "does not exist."))
    }
    
    # Try reading the raster
    raster_layer <- tryCatch({
      if (is.character(input)) {
        stars::read_stars(input)
      } else {
        input
      }
    }, error = function(e) {
      stop(paste("Error reading the raster file:", input, "\nMessage:", e$message))
    })
    
    if (!is.null(resample_factor)) {
      new_dims <- map_dbl(dim(raster_layer), ~round(.x * resample_factor))
      raster_layer <- stars::st_warp(raster_layer, 
                                     dimensions = new_dims,
                                     crs = crs,
                                     method = method,
                                     use_gdal = TRUE,
                                     no_data_value = no_data_value)
    }
    
    return(raster_layer)
  }
  
  # Apply the process_raster function to each input using map
  processed_rasters <- map(inputs, process_raster)
  
  dataframes_with_values <- list()
  
  # If df, lat_col, and lon_col are provided
  if (!is.null(df) && !is.null(lat_col) && !is.null(lon_col)) {
    if (is.null(split_id) || is.null(search_strings)) {
      # Extract raster values based on coordinates and order of rasters
      df_list <- list(df)
      for (file in inputs) {
        cat("Processing file:", file, "\n")
        tryCatch({
          raster_data <- read_stars(file)
          df_sf <- st_as_sf(df, coords = c(lon_col, lat_col), crs = st_crs(raster_data))
          extracted_values <- st_extract(raster_data, df_sf, bilinear = TRUE)
          column_name <- paste0(basename(file), "_processed")
          df[[column_name]] <- extracted_values[[1]]
        }, error = function(e) {
          warning("Error processing file:", file, "\nMessage:", e$message)
        })
      }
      dataframes_with_values <- list(df)
    } else {
      # Check if split_id column exists in the dataframe
      if (!split_id %in% colnames(df)) {
        stop(paste("Error: The column", split_id, "does not exist in the dataframe."))
      }
      # Split the dataframe by split_id
      df_list <- df %>% group_by(!!sym(split_id)) %>% group_split()
      
      dataframes_with_values <- map(df_list, function(current_df) {
        if (nrow(current_df) == 0 || is.null(current_df[[split_id]])) {
          return(NULL)
        }
        current_id <- unique(current_df[[split_id]])
        current_search_string <- str_c("-", current_id, "-")
        
        cat("Processing for ID:", current_id, "\n")
        
        if (current_search_string %in% search_strings) {
          files <- list.files(path = dirname(inputs[1]), 
                              pattern = str_c(current_search_string, ".*\\.tif$"), 
                              full.names = TRUE)
          
          if (length(files) == 0) {
            cat("No raster files found matching the search string:", current_search_string, "\n")
            return(NULL)
          }
          
          for (file in files) {
            cat("Processing file:", file, "\n")
            tryCatch({
              raster_data <- read_stars(file)
              df_sf <- st_as_sf(current_df, coords = c(lon_col, lat_col), crs = st_crs(raster_data))
              extracted_values <- st_extract(raster_data, df_sf, bilinear = TRUE)
              column_name <- paste0(basename(file), "_processed")
              current_df[[column_name]] <- extracted_values[[1]]
            }, error = function(e) {
              warning("Error processing file:", file, "\nMessage:", e$message)
            })
          }
        }
        return(current_df)
      })
    }
  }
  
  return(list(processed_rasters = processed_rasters, dataframes_with_values = dataframes_with_values))
}




