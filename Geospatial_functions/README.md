# R Functions Documentation

---

## `extract_raster_data_by_id`

### Description:
This function extracts raster data values at specified coordinates from raster files in a given directory. The function returns a list of data frames with the extracted raster values.

### Parameters:
- `df`: A dataframe containing coordinates and an ID column.
- `directory_path`: Path to the directory containing raster files.
- `search_strings`: A vector of strings to identify specific raster files in the directory.
- `split_id`: Name of the column in `df` used to split the dataframe.
- `coord_names`: Names of the columns in `df` containing the coordinates. Default is `c("LONGITUDE", "LATITUDE")`.
- `pattern`: File pattern to identify raster files. Default is ".tif".
- `bilinear`: Logical. If `TRUE`, uses bilinear interpolation for extraction. Default is `TRUE`.

### Returns:
A list of dataframes with the extracted raster values.

### Notes:
- The function uses the `st_extract` function from the `sf` package to extract raster values. Ensure that the `sf` package is installed and loaded.
- The `search_strings` parameter is used to identify specific raster files in the directory. Ensure that the search strings match the naming convention of your raster files.

### Example Usage:

**Sample dataframe and raster list**
df <- data.frame(ID = c(1, 2), LONGITUDE = c(34.5, 35.6), LATITUDE = c(-0.5, -1.6))

**Extract raster data**
result <- extract_raster_data_by_id(df, "/path/to/rasters", c("-1-", "-2-"), "ID")


---

## `extract_raster_data_by_id_multi`

### Description:
This function extracts raster data values at specified coordinates from a list of provided rasters. The function returns a list of data frames with the extracted raster values.

### Parameters:
- `df`: A dataframe containing coordinates and an ID column.
- `raster_list`: A list of raster objects.
- `split_id`: Name of the column in `df` used to split the dataframe.
- `coord_names`: Names of the columns in `df` containing the coordinates. Default is `c("Longitude", "Latitude")`.
- `new_column_name`: Name of the new column in the dataframe to store the extracted raster values. Default is "raster_values".
- `bilinear`: Logical. If `TRUE`, uses bilinear interpolation for extraction. Default is `TRUE`.

### Returns:
A list of dataframes with the extracted raster values.

### Notes:
- The function uses the `extract` function from the `raster` package to extract raster values. Ensure that the `raster` package is installed and loaded.

### Example Usage:

**Sample dataframe and raster list**
df <- data.frame(ID = c(1, 2), Longitude = c(34.5, 35.6), Latitude = c(-0.5, -1.6))
rasters <- list(raster1, raster2) 

**Extract raster data**
result <- extract_raster_data_by_id_multi(df, rasters, "ID")

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

**Create mean raster**
mean_rast <- create_mean_raster("/path/to/rasters", "search_pattern")

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

**Create list of mean rasters**
mean_rasters <- create_mean_rasters_multi_group("/path/to/rasters", c("pattern1", "pattern2"))

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

**Sample raster and sf object**
mean_raster <- raster(matrix(runif(100), 10))
df_sf <- st_as_sf(data.frame(ID = 1:10, Longitude = runif(10, 34, 36), Latitude = runif(10, -1, 1)), coords = c("Longitude", "Latitude"))
**Plot interactive map**
plot <- plot_raster_with_sf_points_interactive(mean_raster, df_sf, c("ID")) 


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

**Sample raster list and sf object**
rasters <- list(raster1, raster2)
df_sf <- st_as_sf(data.frame(ID = c(1, 2), Longitude = c(34.5, 35.6), Latitude = c(-0.5, -1.6)), coords = c("Longitude", "Latitude"))

**Plot interactive maps**
plots <- plot_rasters_with_sf_points_interactive_multi(rasters, df_sf, "ID", c("ID"), c("Title1", "Title2"))


---














