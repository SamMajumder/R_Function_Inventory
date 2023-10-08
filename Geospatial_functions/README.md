# R Functions Documentation

## `geoRflow_load`

### Description:
The `geoRflow_load` function reads and loads geospatial data from the specified file path. It first checks if the file exists, and then identifies the file type based on its extension. Based on the file type, it loads and returns raster, vector, or NetCDF data using appropriate R functions from the `stars`, `sf`, and `raster` packages.

### Parameters:
- **`file_path`**: A string specifying the path to the geospatial data file to be loaded.

### Returns:
- Depending on the file type, one of the following:
  - **`raster_data`**: An object of class `stars` representing raster data if the file extension is among ("tif", "tiff", "img", "jpg").
  - **`vector_data`**: An object of class `sf` representing vector data if the file extension is among ("shp", "geojson", "gpkg").
  - **`nc_data`**: An object of class `RasterBrick` representing NetCDF data if the file extension is among ("nc", "netcdf").

### Errors:
- Throws an error if the file is not found or if the file type is unsupported.

### Notes:
- The function utilizes the `stars`, `sf`, and `raster` packages for reading and loading geospatial data. Ensure that these packages are installed and loaded.
- The `tools` package is used for extracting the file extension from the `file_path`.

### Example of Simple Usage:

**Basic Usage**:
```R
# Load a GeoTIFF raster file
raster_data <- geoRflow_load(file_path = "path/to/raster.tif")

# Load a Shapefile vector file
vector_data <- geoRflow_load(file_path = "path/to/vector.shp")

# Load a NetCDF file
nc_data <- geoRflow_load(file_path = "path/to/data.nc")
```
### Use Case & Example:
#### Geospatial Data Analysis for Environmental Monitoring:
Imagine you are an environmental scientist with a collection of geospatial files containing land use, vegetation index, and climate data. You need to load these different types of geospatial data to analyze environmental changes over time in a specific region.

Using `geoRflow_load`, you can:

- **Load Various Data Types**: Easily load raster, vector, or NetCDF data with a single function call, without having to worry about the underlying file reading functions.
- **Error Handling**: The function checks for file existence and supported file types, providing clear error messages to guide further actions.

# Sample Usage
```R
land_use_data <- geoRflow_load(file_path = "path/to/land_use.shp")
vegetation_index_data <- geoRflow_load(file_path = "path/to/vegetation_index.tif")
climate_data <- geoRflow_load(file_path = "path/to/climate_data.nc")
```

---

## `geoRflow_export`

### Description:
The `geoRflow_export` function exports geospatial data to specified formats such as GeoJSON, Shapefile, or netCDF. The function first checks the existence of the output directory, creating it if necessary. If the input data is provided as a file path, it reads the data into appropriate spatial objects. Optionally, the function can split the data based on a specified identifier before exporting. The actual export is handled in a flexible manner, allowing for additional arguments to be passed to the underlying writing functions.

### Parameters:
- **`data`**: A spatial object or a character string specifying the path to the geospatial data file to be exported.
- **`format`**: A character string specifying the export format. Options include "GeoJSON", "Shapefile", and "netCDF".
- **`output_dir`**: A character string specifying the path to the output directory.
- **`split_id`**: (Optional) A character string specifying the column name used to split the data before exporting.
- **`...`**: Additional arguments to be passed to the underlying writing functions.

### Returns:
- The function exports the spatial data to the specified format, writing the files to the specified output directory. It does not return anything to the R environment.

### Errors:
- Throws an error if the file type or extension is unsupported, the specified `split_id` column does not exist, or the data type is incompatible with the specified export format.

### Notes:
- The function utilizes the `sf` and `stars` packages for handling spatial data and the `dplyr` package for data manipulation. Ensure that these packages are installed and loaded.
- The `tools` package is used for extracting the file extension from the `data` argument when it is a character string.

### Example of Simple Usage:

**Basic Usage**:
```R
# Export a spatial object to GeoJSON
geoRflow_export(data = spatial_obj, format = "GeoJSON", output_dir = "path/to/output")

# Export a spatial object to Shapefile
geoRflow_export(data = spatial_obj, format = "Shapefile", output_dir = "path/to/output")

# Export a spatial object to netCDF
geoRflow_export(data = spatial_obj, format = "netCDF", output_dir = "path/to/output")

```

### Use Case & Example:
#### Geospatial Data Export for Data Sharing:
Imagine you are a GIS analyst who needs to share geospatial data with collaborators in various formats. Your collaborators prefer different formats: some prefer GeoJSON, others prefer Shapefiles, and yet others prefer netCDF. Moreover, some datasets are quite large, and you want to split them based on a certain attribute (e.g., region) to make the data more manageable.

Using `geoRflow_export`, you can:

- **Flexible Export**: Easily export spatial data to various formats with a single function call.
- **Data Splitting**: Optionally split the data based on a specified attribute before exporting, making large datasets more manageable for your collaborators.
- **Directory Management**: Automatically check for the existence of the output directory and create it if necessary, streamlining the export process.

# Sample Usage
# Assuming spatial_obj is a spatial object with a 'Region' column

```R
# Export data, splitting it by region, to GeoJSON
geoRflow_export(data = spatial_obj, format = "GeoJSON", output_dir = "path/to/output", split_id = "Region")

# Similarly for Shapefile and netCDF
geoRflow_export(data = spatial_obj, format = "Shapefile", output_dir = "path/to/output", split_id = "Region")
geoRflow_export(data = spatial_obj, format = "netCDF", output_dir = "path/to/output", split_id = "Region")

```

---

## `extract_raster_data_by_id`

### Description:
This function extracts raster data values at specified coordinates from raster files in a given directory. The function returns a list of data frames with the extracted raster values. Each data frame in the list also contains a column "matched_string" indicating which raster file string pattern was matched and used for data extraction.

### Parameters:
- `df`: A dataframe containing coordinates and an ID column.
- `directory_path`: Path to the directory containing raster files.
- `search_strings`: A vector of strings to identify specific raster files in the directory.
- `split_id`: Name of the column in `df` used to split the dataframe.
- `coord_names`: Names of the columns in `df` containing the coordinates. Default is `c("LONGITUDE", "LATITUDE")`.
- `pattern`: File pattern to identify raster files. Default is ".tif".
- `bilinear`: Logical. If `TRUE`, uses bilinear interpolation for extraction. Default is `TRUE`.

### Returns:
A list of dataframes with the extracted raster values. Each dataframe will also have a "matched_string" column indicating the matched raster file string pattern.

### Notes:
- The function uses the `st_extract` function from the `sf` package to extract raster values. Ensure that the `sf` package is installed and loaded.
- The `search_strings` parameter is used to identify specific raster files in the directory. Ensure that the search strings match the naming convention of your raster files.
- The function now includes error handling. If there's an issue reading a raster file or if the directory path is incorrect, the function will display a warning and continue processing.
- A progress bar is displayed in the console, indicating which ID is currently being processed.

### Example Usage:

```R
##Sample dataframe and raster list

df <- data.frame(ID = c(1, 2), LONGITUDE = c(34.5, 35.6), LATITUDE = c(-0.5, -1.6))

##Extract raster data

result <- extract_raster_data_by_id(df, "/path/to/rasters", c("-1-", "-2-"), "ID")
```

### Use Case & Example:

Imagine you have a dataframe like this:

```R
df <- data.frame(YEAR = c(2001, 2001, 2002, 2002, 2003),
                 LONGITUDE = c(34.5, 35.6, 34.5, 35.6, 34.5),
                 LATITUDE = c(-0.5, -1.6, -0.5, -1.6, -0.5))

```
This dataframe contains data spanning multiple years (2001, 2002, and 2003). Each entry has a latitude and longitude, but not all locations are present in every year. In a directory, you have raster files, each containing data for a specific month and year (e.g., temperature or precipitation data for January 2001, February 2001, etc.).

Using `extract_raster_data_by_id`, you can:

- **Process the Data:** For each unique year in your dataframe, the function identifies all associated raster files.
- **Extract Values:** Data values are extracted from each raster file based on the specific latitude and longitude coordinates in your dataframe for that year.
- **Add Extracted Values:** These extracted values are added as new columns to the dataframe, one for each month/raster file.
- **Organize Results:** Obtain a list of dataframes, where each dataframe corresponds to a unique year and contains the extracted raster values for each month of that year.

This approach is especially useful for researchers and analysts working with spatial-temporal data, allowing for efficient extraction and organization of raster data based on spatial coordinates and temporal identifiers.

---


## `raster_pipeline_point`

### Description:
The `raster_pipeline_point` function processes raster files, optionally resamples them, optionally crops them to a reference shapefile, and optionally extracts values for points provided in a dataframe. With the added `use_bilinear` argument, users can now opt to use bilinear interpolation when extracting values from the raster. The function is designed to handle various scenarios based on the combination of mandatory and optional arguments provided.

### Parameters:
- **`inputs`**: A list of paths to raster files that the user wants to process.
- **`df`**: (Optional) A dataframe containing coordinates for which raster values need to be extracted.
- **`lat_col`**, **`lon_col`**: (Optional) Names of the columns in `df` containing the latitude and longitude coordinates, respectively.
- **`split_id`**: (Optional) Name of the column in `df` used to split the dataframe.
- **`search_strings`**: (Optional) A vector of strings to identify specific raster files.
- **`resample_factor`**: (Optional) Factor by which the raster should be resampled.
- **`crs`**: Coordinate Reference System to be assigned to rasters with undefined CRS. Default is EPSG:4326 (WGS 84).
- **`method`**: (Optional) Method used for resampling. Default is "bilinear".
- **`no_data_value`**: (Optional) Value assigned to cells with no data. Default is -9999.
- **`reference_shape_path`**: (Optional) Path to a reference shapefile used to crop the rasters.
- **`use_bilinear`**: (Optional) Boolean flag to use bilinear interpolation when extracting values. Default is TRUE.

### Returns:
- **`processed_rasters`**: A list of processed raster layers.
- **`dataframes_with_values`**: A list of dataframes with extracted raster values (if `df`, `lat_col`, and `lon_col` are provided).

### Notes:
- The function uses functions from the `sf` and `stars` packages for spatial operations. Ensure that these packages are installed and loaded.
- If a raster has an undefined CRS, the function assigns it the user-defined `crs`.
- If a `reference_shape` is provided and its CRS is different from the raster's CRS, the raster is transformed to the CRS of the reference shapefile.
- During resampling, the user-defined `crs` is used as the target CRS.
- A progress bar is displayed to show the progress of processing each raster in the `inputs` list.

### Example of Simple Usage:

**Basic Usage**:
```R
# Process a list of raster files
result <- raster_pipeline_point(inputs = list("path/to/raster1.tif", "path/to/raster2.tif"))
```

**With Data Extraction**:
```R
## extract raster data at coordinates and add it to the dataframe

df <- data.frame(LATITUDE = c(-0.5, -1.6), LONGITUDE = c(34.5, 35.6))
result <- raster_pipeline_point(inputs = list("path/to/raster1.tif"), df = df, lat_col = "LATITUDE", lon_col = "LONGITUDE")
```

**With Resampling**:
```R
result <- raster_pipeline_point(inputs = list("path/to/raster1.tif"), resample_factor = 0.5)
```

### Use Case & Example:
#### Spatial Analysis for Environmental Research:
Imagine you're an environmental researcher with a collection of raster files representing monthly precipitation data over several years. Each raster file is named based on the month and year it represents, like `Jan_2001.tif`, `Feb_2001.tif`, and so on. You also have a dataframe of specific locations (e.g., weather stations) with latitude, longitude coordinates, and years of data collection. You're interested in extracting the monthly precipitation values for these locations to analyze trends over time.

Using `raster_pipeline_point`, you can:

- **Process the Data**: Provide the paths to your raster files and the dataframe of locations.
- **Match Data by Year**: The `split_id` and `search_strings` parameters allow the function to match the years in the dataframe with the appropriate raster files, ensuring that data extraction is specific to each year.
- **Extract Values**: The function will extract the monthly precipitation values for each location.
- **Resample Rasters**: If your rasters are at a very high resolution and you want to reduce the computational load, you can resample them.
- **Crop to Area of Interest**: If you have a shapefile representing your study area, you can provide its path to crop the rasters to this area, reducing unnecessary data.

```R
# Sample dataframe of locations
df <- data.frame(StationID = c(1, 2), LATITUDE = c(-0.5, -1.6), LONGITUDE = c(34.5, 35.6), Year = c(2001, 2002))

# Extract precipitation data for these locations from a list of raster files
result <- raster_pipeline_point(
    inputs = list("path/to/precip_Jan_2001.tif", "path/to/precip_Feb_2001.tif", "path/to/precip_Jan_2002.tif"),
    df = df,
    lat_col = "LATITUDE",
    lon_col = "LONGITUDE",
    split_id = "Year",
    search_strings = c("-2001-", "-2002-"),
    reference_shape_path = "path/to/study_area_shapefile.shp",
    resample_factor = 0.5
)
```

In this example, the function returns a list of dataframes, where each dataframe corresponds to a unique year and contains the extracted raster values for each month of that year. The raster files are also resampled and cropped to the area of interest, ensuring efficient and relevant data extraction.

---


# `raster_pipeline_polygon`

## Description
The `raster_pipeline_polygon` function processes raster files, optionally resamples them, and optionally extracts values for polygons provided in a dataframe. The function is tailored to handle various workflows based on the combination of mandatory and optional arguments provided.

## Parameters
- **`inputs`**: A list of paths to raster files that the user wants to process.
- **`df`**: (Optional) A dataframe containing polygons for which raster values need to be extracted.
- **`polygon_col`**: (Optional) Name of the column in `df` containing the polygons.
- **`split_id`**: (Optional) Name of the column in `df` used to split the dataframe.
- **`search_strings`**: (Optional) A vector of strings to identify specific raster files.
- **`resample_factor`**: (Optional) Factor by which the raster should be resampled.
- **`crs`**: Coordinate Reference System to be assigned to rasters. Default is EPSG:4326 (WGS 84).
- **`method`**: (Optional) Method used for resampling. Default is "bilinear".
- **`no_data_value`**: (Optional) Value assigned to cells with no data. Default is -9999.
- **`use_bilinear`**: (Optional) Boolean to decide if bilinear method should be used during extraction. Default is TRUE.

## Returns
- **`processed_rasters`**: A list of processed raster layers.
- **`dataframes_with_values`**: A list of dataframes with extracted raster values (if `df` and `polygon_col` are provided).

## Notes
- The function uses functions from the `sf` and `stars` packages for spatial operations. Ensure that these packages are installed and loaded.
- If a raster has an undefined CRS, the function assigns it the user-defined `crs`.
- A progress bar is displayed to show the progress of processing each raster in the `inputs` list.

## Example of Simple Usage
**Basic Usage**:
```R
# Process a list of raster files
result <- raster_pipeline_polygon(inputs = list("path/to/raster1.tif", "path/to/raster2.tif"))
```

**With Data Extraction**:
```R
# Sample dataframe of locations with polygons
df <- data.frame(PolygonName = c("Area1", "Area2"), Polygon = c("POLYGON(...)", "POLYGON(...)"))
# Extract raster data for these polygons
result <- raster_pipeline_polygon(inputs = list("path/to/raster1.tif"), df = df, polygon_col = "Polygon")
```

**With Resampling**:
```R
result <- raster_pipeline_polygon(inputs = list("path/to/raster1.tif"), resample_factor = 0.5)
```

## Use Case & Example
### Spatial Analysis for Environmental Research
Imagine you're an environmental researcher with a collection of raster files representing yearly vegetation data. Each raster file is named based on the year it represents, like `Vegetation_2001.tif`, `Vegetation_2002.tif`, and so on. You also have a dataframe of specific regions (e.g., national parks) with their polygon geometries and years of interest. You're interested in extracting the yearly vegetation values for these regions.

Using `raster_pipeline_polygon`, you can:
- **Process the Data**: Provide the paths to your raster files and the dataframe of regions.
- **Match Data by Year**: The `split_id` and `search_strings` parameters can be utilized to match the years in the dataframe with the appropriate raster files.
- **Extract Values**: The function will extract the yearly vegetation values for each region.

```R
# Sample dataframe of regions with polygons
df <- data.frame(RegionName = c("ParkA", "ParkB"), Polygon = c("POLYGON(...)", "POLYGON(...)"), Year = c(2001, 2002))
# Extract vegetation data for these regions from a list of raster files
result <- raster_pipeline_polygon(
    inputs = list("path/to/Vegetation_2001.tif", "path/to/Vegetation_2002.tif"),
    df = df,
    polygon_col = "Polygon",
    split_id = "Year",
    search_strings = c("-2001-", "-2002-")
)
```
In this example, the function returns a list of dataframes, where each dataframe corresponds to a unique year and contains the extracted raster values for that year.

---


## `create_mean_raster`

### Description:
This function calculates the mean values from multiple rasters and returns a single raster containing these mean values.

### Parameters:
- `directory_path`: Path to the directory containing raster files.
- `search_string`: A string pattern to identify specific raster files in the directory.

### Returns:
A raster containing the mean values of the input rasters.

### Notes:
- The function uses the `mean` function from the `raster` package to calculate the mean values. Ensure that the `raster` package is installed and loaded.
- The `search_string` parameter is used to identify specific raster files in the directory. Ensure that the search string matches the naming convention of your raster files.
- The function assumes that the raster files in the directory are compatible (i.e., they have the same extent, resolution, and CRS) for the mean calculation.

### Example Usage:

```R

##Create mean raster

mean_rast <- create_mean_raster("/path/to/rasters", "search_pattern")

```
---

## `create_mean_rasters_multi_group`

### Description:
This function calculates the mean values from multiple sets of rasters based on provided search strings and returns a list of rasters containing these mean values.

### Parameters:
- `directory_path`: Path to the directory containing raster files.
- `search_strings`: A vector of string patterns to identify specific sets of raster files in the directory.

### Returns:
A list of rasters containing the mean values of the input rasters for each search string.

### Notes:
- The function uses the `mean` function from the `raster` package to calculate the mean values. Ensure that the `raster` package is installed and loaded.
- The `search_strings` parameter is used to identify specific sets of raster files in the directory. Ensure that the search strings match the naming convention of your raster files.
- The function assumes that the raster files in the directory are compatible (i.e., they have the same extent, resolution, and CRS) for the mean calculation.


### Example Usage:

```R

##Create list of mean rasters

mean_rasters <- create_mean_rasters_multi_group("/path/to/rasters", c("pattern1", "pattern2"))

```

---

## `plot_raster_with_sf_points_interactive`

### Description:
This function creates an interactive map with a raster overlay and point data from an `sf` object overlaid on the raster.

### Parameters:
- `mean_raster`: A raster object containing the data to be plotted.
- `df_sf`: An `sf` object containing the point data to be overlaid on the raster.
- `hovertext_columns`: Columns from `df_sf` to be used for hovertext in the interactive plot.
- `plot_title`: Title for the plot. Default is "Interactive Plot".

### Returns:
An interactive plot with the raster and point data.

### Notes:
- The function uses `ggplot2` for plotting and `plotly` to make the plot interactive.
- The `hovertext_columns` parameter specifies which columns from the `sf` object should be displayed as hovertext in the interactive plot.
- The raster data is plotted using `geom_raster` and the point data is plotted using `geom_point`.
- The `mean_raster` should be compatible with the coordinate reference system of the `sf` object.


### Example usage:

```R

##Sample raster and sf object

mean_raster <- raster(matrix(runif(100), 10))

df_sf <- st_as_sf(data.frame(ID = 1:10, Longitude = runif(10, 34, 36), Latitude = runif(10, -1, 1)), coords = c("Longitude", "Latitude"))

##Plot interactive map

plot <- plot_raster_with_sf_points_interactive(mean_raster, df_sf, c("ID"))

```

---
## `plot_rasters_with_sf_points_interactive_multi`

### Description:
This function creates a series of interactive raster plots with point data overlayed on each raster. The points are plotted based on a specified ID and can be colored based on their values.

### Parameters:
- `raster_list`: A list of raster objects to be plotted.
- `df_sf`: An `sf` object containing the point data to be overlaid on the rasters.
- `id_column`: Name of the column in `df_sf` used to split the dataframe and match with the rasters.
- `hovertext_columns`: Columns from `df_sf` to be used for hovertext in the interactive plots.
- `title_strings`: A vector of titles for each plot.
- `color_column`: Optional. Name of the column in `df_sf` used to color the points. If NULL, points are colored red. Default is NULL.
- `color_ramp`: Color ramp to use for the points. Default is "YlOrRd".
- `color_direction`: Direction of the color ramp. Use 1 for regular direction and -1 for reversed direction. Default is 1.

### Returns:
A list of interactive plots with the raster and point data.

### Notes:
- The function uses `ggplot2` for plotting and `plotly` to make the plots interactive.
- The `hovertext_columns` parameter specifies which columns from the `sf` object should be displayed as hovertext in the interactive plots.
- The raster data is plotted using `geom_raster` and the point data is plotted using `geom_point`.
- The `raster_list` and `df_sf` should be compatible in terms of length and order.
- The `color_column` parameter allows for coloring the points based on a specific column in the `sf` object. If this parameter is not provided, the points are colored red by default.

### Example Usage:

```R
##Sample raster list and sf object**

rasters <- list(raster1, raster2)

df_sf <- st_as_sf(data.frame(ID = c(1, 2), Longitude = c(34.5, 35.6), Latitude = c(-0.5, -1.6)), coords = c("Longitude", "Latitude"))

##Plot interactive maps**

plots <- plot_rasters_with_sf_points_interactive_multi(rasters, df_sf, "ID", c("ID"), c("Title1", "Title2"))

```
---  

## `calculate_yearly_avg`

### Description:
This function calculates the yearly average for each year across all cells, based on a raster brick where each layer represents monthly data. The function is designed to handle raster bricks with layers that are chronologically arranged, representing monthly data for consecutive years.

### Parameters:
- **raster_brick**: A raster brick object where each layer represents monthly data. The layers should be chronologically arranged.

### Returns:
A list containing the yearly average for each year based on the layers in the provided raster brick.

### Notes:
- The function assumes that the raster brick contains monthly data layers that are chronologically arranged.
- If the raster brick has a number of layers that is not a multiple of 12 (e.g., due to incomplete data for the last year), the function will still compute the average for the remaining months.
- The function uses a progress bar to indicate the progress of the calculation, especially useful for raster bricks with a large number of layers.

### Example Usage:

```R

## Assuming `temp_data_subset` is your raster brick with monthly data layers

yearly_averages <- calculate_yearly_avg(temp_data_subset)

```
---

### `calculate_yearly_avg_raster`

#### Description:
This function calculates the yearly average for each cell in a raster brick. The raster brick is assumed to contain monthly data, with 12 layers representing each month of a year. The function returns a raster stack where each layer represents the yearly average for each cell.

#### Parameters:
- `raster_brick`: A raster brick containing monthly data. The number of layers should be a multiple of 12, with each set of 12 layers representing data for a year.

#### Value:
Returns a raster stack where each layer contains the yearly average values for each cell.

#### Notes:
- The function assumes that the raster brick contains 12 layers for each year, representing monthly data.
- A progress bar is displayed during the calculation to provide feedback on the progress.
- If the total number of layers in the raster brick is not a multiple of 12, the function will still compute the average for the remaining months in the last year.

#### Example usage:

```R
# Assuming temp_data_subset is your raster brick with monthly data

yearly_avg_result <- calculate_yearly_avg_raster(temp_data_subset)

```

---
