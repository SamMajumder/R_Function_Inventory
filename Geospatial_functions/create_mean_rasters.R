
### Functi
############# This function takes in multiple rasters and calculates the mean 
## from them and creates a raster which contains the mean values of that raster
## this one creates a single list of rasters ###



create_mean_raster <- function(directory_path, search_string) {
  # List all files in the directory that match the search string
  files <- list.files(directory_path, pattern = search_string, full.names = TRUE)
  
  # Read all the raster files
  rasters <- lapply(files, raster)
  
  # Calculate the mean raster
  mean_raster <- mean(stack(rasters))
  
  return(mean_raster)
}
