

#################
### 
######################## This one takes in multiple rasters instead of one## 


create_mean_rasters_multi_group <- function(directory_path, search_strings) {
  # Initialize a list to store mean rasters
  mean_rasters_list <- list()
  
  # Loop through each search string
  for (search_string in search_strings) {
    # List all files in the directory that match the current search string
    files <- list.files(directory_path, pattern = search_string, full.names = TRUE)
    
    # Check if there are any files that match the search string
    if (length(files) == 0) {
      warning(paste("No files found for search string:", search_string))
      next
    }
    
    # Read all the raster files that match the current search string
    rasters <- lapply(files, raster)
    
    # Calculate the mean raster for the current set of files
    mean_raster <- mean(stack(rasters))
    
    # Append the mean raster to the list
    mean_rasters_list[[search_string]] <- mean_raster
  }
  
  return(mean_rasters_list)
}
