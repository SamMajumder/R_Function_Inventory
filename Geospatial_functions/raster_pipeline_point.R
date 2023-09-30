
rm(list = ls())

library(sf)
library(stars)
library(purrr)
library(tidyverse)

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
  
  # Initialize the progress bar
  pb <- txtProgressBar(min = 0, max = length(inputs), style = 3)
  
  process_raster <- function(input) {
    # Update progress bar
    setTxtProgressBar(pb, which(inputs == input))
    
    if (!file.exists(input)) {
      stop(paste("Error: The file", input, "does not exist."))
    }
    
    raster_layer <- tryCatch({
      if (is.character(input)) {
        stars::read_stars(input)
      } else {
        input
      }
    }, error = function(e) {
      stop(paste("Error reading the raster file:", input, "\nMessage:", e$message))
    })
    
    if (!is.null(reference_shape)) {
      if (is.character(reference_shape)) {
        reference_shape <- st_read(reference_shape, quiet = TRUE)
      }
      
      if (!st_crs(reference_shape) == st_crs(raster_layer)) {
        reference_shape <- st_transform(reference_shape, crs = st_crs(raster_layer))
      }
      
      raster_layer <- st_crop(raster_layer, reference_shape)
    }
    
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
  
  processed_rasters <- map(inputs, process_raster)
  
  # Close the progress bar
  close(pb)
  
  dataframes_with_values <- list()
  
  if (!is.null(df) && !is.null(lat_col) && !is.null(lon_col)) {
    if (is.null(split_id) || is.null(search_strings)) {
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
      if (!split_id %in% colnames(df)) {
        stop(paste("Error: The column", split_id, "does not exist in the dataframe."))
      }
      df_list <- df %>% group_by(!!sym(split_id)) %>% dplyr::group_split()
      dataframes_with_values <- map(df_list, function(current_df) {
        if (nrow(current_df) == 0 || is.null(current_df[[split_id]])) {
          return(NULL)
        }
        current_id <- unique(current_df[[split_id]])
        current_search_string <- paste0("-", current_id, "-")
        cat("Processing for ID:", current_id, "\n")
        
        if (current_search_string %in% search_strings) {
          files <- list.files(path = dirname(inputs[1]), 
                              pattern = paste0(current_search_string, ".*\\.tif$"), 
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

library(here)


## TEST ## 

raster_files <- list.files(here("Datasets"),
                           pattern = ".tif",
                           full.names = TRUE)


years <- c("2000","2001","2002")

df <- read.csv(here("Datasets","Kenya_conflicts.csv")) %>% 
                                 dplyr::filter(YEAR %in% years)




results <- raster_pipeline_point(
  inputs = raster_files,
  df = df,
  lat_col = "LATITUDE",
  lon_col = "LONGITUDE",
  split_id = "YEAR",
  search_strings = c("-2000-", "-2001-","2002"),
  reference_shape = here("Datasets",
                         "ken_adm_iebc_20191031_shp",
                         "ken_admbnda_adm0_iebc_20191031.shp"),
  resample_factor = 0.5,
  crs = st_crs(4326)  
)




