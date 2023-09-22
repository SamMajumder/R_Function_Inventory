
extract_raster_data_by_id <- function(df, directory_path, search_strings, 
                                      split_id, 
                                      coord_names = c("LONGITUDE", "LATITUDE"), 
                                      pattern = ".tif",
                                      bilinear=TRUE) {
  
  # Check if directory_path exists and is accessible
  if (!dir.exists(directory_path)) {
    stop("Error: The provided directory path does not exist or is inaccessible.")
  }
  
  # Check if required packages are loaded
  if (!requireNamespace("sf", quietly = TRUE) || !requireNamespace("dplyr", quietly = TRUE)) {
    stop("Error: Required packages ('sf' and 'dplyr') are not installed or loaded.")
  }
  
  # Split the dataframe by the specified ID
  df_list <- df %>% group_split(!!sym(split_id))
  
  # Initialize an empty list to store the updated dataframes
  result_list <- list()
  
  # Initialize progress bar
  pb <- txtProgressBar(min = 0, max = length(df_list), style = 3)
  
  # Loop through each ID value and its corresponding dataframe
  for (i in seq_along(df_list)) {
    # Update progress bar
    setTxtProgressBar(pb, i)
    
    current_df <- df_list[[i]]
    # Get the unique ID for the current dataframe
    current_id <- unique(current_df[[split_id]])
    
    # Get the search string for the current ID
    current_search_string <- paste0("-", current_id, "-")
    
    # Check if the current search string is in the provided search_strings
    if (current_search_string %in% search_strings) {
      
      # Get a list of all files with the current search string in the name and matching the pattern
      files <- list.files(directory_path, pattern = paste0(current_search_string, ".*", pattern), full.names = TRUE)
      
      # Loop through each matching file and extract data
      for (file in files) {
        tryCatch({
          # Read the raster data
          raster_data <- read_stars(file)
          
          # Convert the dataframe to an sf object using the specified coordinate column names
          df_sf <- st_as_sf(current_df, coords = coord_names, crs = st_crs(raster_data))
          
          # Extract the raster values at the coordinates
          extracted_values <- st_extract(raster_data, df_sf, bilinear = bilinear)
          
          # Add the extracted values to the dataframe with a new column name based on the file
          column_name <- paste0(basename(file), "_values")
          current_df <- current_df %>% mutate(!!column_name := extracted_values[[1]])
          
          # Add the matched string to the dataframe
          current_df$matched_string <- current_search_string
          
          # Clear raster data from memory
          rm(raster_data)
          gc()
        }, 
        error = function(e) {
          warning(paste("Error processing file:", file, "\nMessage:", e$message))
        })
      }
      
      # Add the updated dataframe to the result list using the current ID as the list name
      result_list[[as.character(current_id)]] <- current_df
    }
  }
  
  # Close progress bar
  close(pb)
  
  return(result_list)
}
