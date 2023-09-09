## This takes in a list of rasters already imported ####

extract_raster_data_by_id_multi <- function(df, raster_list, split_id, 
                                         coord_names = c("Longitude", "Latitude"), 
                                         new_column_name = "raster_values",
                                         bilinear = TRUE) {
  
  # Split the dataframe based on the split_id
  split_data <- df %>% group_split(!!sym(split_id))
  
  # Initialize an empty list to store the updated dataframes
  result_list <- list()
  
  # Loop through each split dataframe and its corresponding raster
  for (i in seq_along(split_data)) {
    current_df <- split_data[[i]]
    
    # Convert the dataframe to an sf object using the specified coordinate column names
    df_sf <- st_as_sf(current_df, coords = coord_names, crs = st_crs(4326))
    
    # Extract the raster values at the coordinates
    extracted_values <- raster::extract(raster_list[[i]], st_coordinates(df_sf), method = ifelse(bilinear, "bilinear", "simple"))
    
    # Add the extracted values to the dataframe with the new column name
    current_df[[new_column_name]] <- extracted_values
    
    # Add the updated dataframe to the result list
    result_list[[i]] <- current_df
  }
  
  return(result_list)
}
