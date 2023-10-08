

geoRflow_load <- function(file_path) {
  # Check if the file exists
  if (!file.exists(file_path)) {
    stop("File not found")
  }
  
  # Determine the file type based on its extension
  file_extension <- tools::file_ext(file_path)
  
  # Load and return the data based on the file type
  if (file_extension %in% c("tif", "tiff", "img", "jpg")) {
    # Raster data (GeoTIFF, JPEG, etc.)
    raster_data <- stars::read_stars(file_path)
    return(raster_data)
  } else if (file_extension %in% c("shp", "geojson", "gpkg")) {
    # Vector data (Shapefile, GeoJSON, GeoPackage, etc.)
    vector_data <- st_read(file_path)
    return(vector_data)
  } else if (file_extension %in% c("nc", "netcdf")) {
    # NetCDF data
    nc_data <- raster::brick(file_path)
    return(nc_data)
  } else {
    stop("Unsupported file type")
  }
}


