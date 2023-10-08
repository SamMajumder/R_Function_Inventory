
geoRflow_export <- function(data, format, output_dir, split_id = NULL, ...) {
  
  # Check if the output directory exists, if not, create it
  if(!dir.exists(output_dir)) {
    dir.create(output_dir)
  }
  
  # If data is a character (assumed to be a filepath), load it
  if(is.character(data)) {
    ext <- tolower(tools::file_ext(data))
    if(ext %in% c("shp")) {
      data <- st_read(data)
    } else if(ext %in% c("tif", "tiff", "grd", "img", "nc", "netcdf")) {
      data <- read_stars(data)
    } else {
      stop("Unsupported file type or extension.")
    }
  }
  
  # Check if split_id exists in the data and split if necessary
  if(!is.null(split_id)) {
    if(split_id %in% colnames(data)) {
      slices <- data %>% group_by(!!sym(split_id)) %>% group_split()
    } else {
      stop(paste("Error: The column", split_id, "does not exist in the dataset."))
    }
  } else {
    slices <- list(data)
  }
  
  for(slice in slices) {
    unique_id <- unique(slice[[split_id]])
    filename <- paste0(split_id, "_", unique_id)
    
    switch(format,
           "GeoJSON" = {
             output_path <- file.path(output_dir, paste0(filename, ".geojson"))
             if(!inherits(slice, 'sf')) {
               stop("Only 'sf' objects can be exported to GeoJSON.")
             }
             st_write(slice, output_path, driver = "GeoJSON", ...)
           },
           "Shapefile" = {
             output_path <- file.path(output_dir, filename)  # .shp is automatically added
             if(!inherits(slice, 'sf')) {
               stop("Only 'sf' objects can be exported to Shapefile.")
             }
             st_write(slice, output_path, driver = "ESRI Shapefile", ...)
           },
           "netCDF" = {
             output_path <- file.path(output_dir, paste0(filename, ".nc"))
             if(!inherits(slice, 'stars')) {
               stop("Only 'stars' objects can be exported to netCDF.")
             }
             write_stars(slice, output_path, ...)
           },
           stop("Unsupported export format.")
    )
  }
}










