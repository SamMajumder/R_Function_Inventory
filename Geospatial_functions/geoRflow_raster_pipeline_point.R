

#########
### extract values from a raster at points ###
########

geoRflow_raster_pipeline_point <- function(inputs,
                                           df = NULL,
                                           lat_col = NULL,
                                           lon_col = NULL,
                                           split_id = NULL,
                                           search_strings = NULL,
                                           method = "stars",
                                           resample_factor = NULL,
                                           crs = st_crs(4326),
                                           method_resampling = "bilinear",
                                           no_data_value = -9999,
                                           reference_shape = NULL,
                                           use_bilinear = TRUE) {
  
  # Check inputs
  if (length(inputs) == 0) {
    stop("Error: No inputs provided.")
  }
  
  # Helper function to load and assign CRS to a raster file
  load_raster <- function(input) {
    cat("Loading raster:", input, "\n")
    raster_data <- tryCatch({
      if (is.character(input)) {
        if (method == "stars") {
          stars::read_stars(input)
        } else {
          raster::brick(input)
        }
      } else {
        input
      }
    }, error = function(e) {
      cat("Error loading raster:", input, "\n")
      stop(e)
    })
    
    # Assign user-specified CRS
    cat("Assigning CRS to raster:", input, "\n")
    if (method == "stars") {
      raster_data <- sf::st_set_crs(raster_data, crs)
    } else {
      raster::crs(raster_data) <- crs
    }
    
    return(raster_data)
  }
  
  # Helper function to resample a raster
  resample_raster <- function(raster_data) {
    cat("Resampling raster...\n")
    if (!is.null(resample_factor)) {
      new_dims <- purrr::map_dbl(dim(raster_data), ~ round(.x * resample_factor))
      resampled_raster <- tryCatch({
        stars::st_warp(raster_data,
                       dimensions = new_dims,
                       method = method_resampling,
                       use_gdal = TRUE,
                       no_data_value = no_data_value)
      }, error = function(e) {
        cat("Error in resampling raster.\n")
        stop(e)
      })
      return(resampled_raster)
    } else {
      return(raster_data)
    }
  }
  
  # Helper function to crop a raster to a reference shape
  crop_raster <- function(raster_data) {
    cat("Cropping raster...\n")
    if (!is.null(reference_shape)) {
      ref_shape <- tryCatch({
        if (is.character(reference_shape)) {
          sf::st_read(reference_shape, quiet = TRUE)
        } else {
          reference_shape
        }
      }, error = function(e) {
        cat("Error reading reference shape.\n")
        stop(e)
      })
      ref_shape <- sf::st_transform(ref_shape, sf::st_crs(raster_data))
      cropped_raster <- suppressWarnings(sf::st_crop(raster_data, ref_shape))
      return(cropped_raster)
    } else {
      return(raster_data)
    }
  }
  
  # Helper function to extract raster values at specified point locations
  extract_raster_values <- function(raster_data, df_sf) {
    cat("Extracting raster values...\n")
    extracted_values <- tryCatch({
      stars::st_extract(raster_data, df_sf, bilinear = use_bilinear)
    }, error = function(e) {
      cat("Error in extracting raster values:\n", conditionMessage(e), "\n")
      return(NULL)
    })
    return(extracted_values[[1]])  # This line should be outside of the tryCatch block
  }
  
  # Process a single data frame (either the whole df or a subset)
  process_df <- function(current_df, files, file_names) {
    for (i in seq_along(files)) {
      cat("Processing file:", file_names[i], "\n")
      raster_data <- files[[i]]
      df_sf <- tryCatch({
        sf::st_as_sf(current_df, coords = c(lon_col, lat_col), crs = sf::st_crs(raster_data))
      }, error = function(e) {
        cat("Error in converting dataframe to sf object:\n", conditionMessage(e), "\n")
        return(NULL)
      })
      column_name <- paste0(file_names[i], "_processed")
      current_df[[column_name]] <- extract_raster_values(raster_data, df_sf)
    }
    return(current_df)
  }
  
  # Initialize the progress bar
  pb <- txtProgressBar(min = 0, max = length(inputs), style = 3)
  
  # Main processing function to load, resample, and crop rasters
  process_single_raster <- function(input, index) {
    raster_data <- load_raster(input)
    raster_data <- resample_raster(raster_data)
    raster_data <- crop_raster(raster_data)
    # Update the progress bar
    setTxtProgressBar(pb, index)
    return(raster_data)
  }
  
  # Use map2 to pass both the raster data and the index to process_single_raster
  processed_rasters <- purrr::map2(inputs, seq_along(inputs), process_single_raster)
  
  # Close the progress bar for raster processing
  close(pb)
  
  # Separate vector to store file names
  file_names <- basename(inputs)
  
  dataframes_with_values <- list()
  
  if (is.null(split_id) || is.null(search_strings)) {
    files <- processed_rasters
    dataframes_with_values <- list(process_df(df, files, file_names))
  } else {
    if (!split_id %in% colnames(df)) {
      stop(paste("Error: The column", split_id, "does not exist in the dataframe."))
    }
    df_list <- df %>% group_by(!!sym(split_id)) %>% dplyr::group_split()
    
    dataframes_with_values <- purrr::map(df_list, function(current_df) {
      if (nrow(current_df) == 0 || is.null(current_df[[split_id]])) {
        return(NULL)
      }
      current_id <- unique(current_df[[split_id]])
      cat("Processing for ID:", current_id, "\n")
      
      # Filter the rasters based on the current ID
      matching_indices <- grepl(current_id, file_names)
      matching_files <- processed_rasters[matching_indices]
      matching_file_names <- file_names[matching_indices]
      
      if (length(matching_files) == 0) {
        cat("No raster files found matching the ID:", current_id, "\n")
        return(NULL)
      }
      
      return(process_df(current_df, matching_files, matching_file_names))
    })
  }
  
  return(list(processed_rasters = processed_rasters, dataframes_with_values = dataframes_with_values))
}

