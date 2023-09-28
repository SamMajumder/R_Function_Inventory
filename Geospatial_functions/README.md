# R Functions Documentation

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

```R

##Sample dataframe and raster list

df <- data.frame(ID = c(1, 2), Longitude = c(34.5, 35.6), Latitude = c(-0.5, -1.6))

rasters <- list(raster1, raster2)

##Extract raster data

result <- extract_raster_data_by_id_multi(df, rasters, "ID")

```

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
