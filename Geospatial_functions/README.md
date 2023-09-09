
### `extract_raster_data_by_id`

### Description
This function extracts raster data values at specific points provided in a dataframe. It is designed to work with multiple raster files that match specific search strings. The function returns a list of dataframes with the extracted raster values added as new columns.

### Parameters
- **df**: A dataframe containing the coordinates for which raster data should be extracted.
- **directory_path**: The path to the directory containing the raster files.
- **search_strings**: A vector of strings to match raster filenames in the directory.
- **split_id**: The column name in `df` used to split the dataframe into groups.
- **coord_names** (default: `c("LONGITUDE", "LATITUDE")`): The column names in `df` that represent the coordinates.
- **pattern** (default: ".tif"): The file extension pattern to search for in the directory.
- **bilinear** (default: TRUE): A logical value indicating whether to use bilinear interpolation when extracting raster values.

### Returns
A list of dataframes. Each dataframe corresponds to a unique value of `split_id` and contains the original data along with the extracted raster values as new columns.

### Usage
To extract raster data for specific points in a dataframe, use the function as follows:

```R
result <- extract_raster_data_by_id(df = your_dataframe, 
                                    directory_path = "path/to/rasters", 
                                    search_strings = c("-search1-", "-search2-"), 
                                    split_id = "YourIDColumn")


#### Notes:
- The function uses the `st_extract` function from the `stars` package to extract raster data. Ensure that the `stars` package is installed and loaded.
- The function assumes that the raster files are in the `.tif` format by default, but this can be changed using the `pattern` argument.
- The `search_strings` parameter is used to identify specific raster files in the directory. Ensure that the search strings match the naming convention of your raster files.
- The `bilinear` argument determines the method of extraction. If `TRUE`, bilinear interpolation is used; otherwise, the nearest neighbor method is used.

---

## `extract_raster_data_by_id_multi`

### Description
This function extracts values from a list of raster datasets at specific points provided in a dataframe. The function returns a list of dataframes with the extracted raster values added as a new column.

### Parameters
- **df**: A dataframe containing the coordinates for which raster data should be extracted.
- **raster_list**: A list of raster datasets (already imported) corresponding to the groups in `df`.
- **split_id**: The column name in `df` used to split the dataframe into groups.
- **coord_names** (default: `c("Longitude", "Latitude")`): The column names in `df` that represent the coordinates.
- **new_column_name** (default: "raster_values"): The name of the new column where the extracted raster values will be stored.
- **bilinear** (default: TRUE): A logical value indicating whether to use bilinear interpolation when extracting raster values.

### Returns
A list of dataframes. Each dataframe corresponds to a unique group in `df` and contains the original data along with the extracted raster values in the specified new column.

### Usage
To extract raster data for specific points in a dataframe using a list of raster datasets, use the function as follows:

```R
result <- extract_raster_data_by_id_multi(df = your_dataframe, 
                                          raster_list = your_raster_list, 
                                          split_id = "YourIDColumn")


#### Notes:
- Ensure that the length of `raster_list` matches the number of unique groups in `df` based on `split_id`.
- The function uses the `extract` function from the `raster` package for raster data extraction. Ensure that the `raster` package is installed and loaded.
- The function assumes that the raster datasets provided in `raster_list` are already imported into R.
- The `bilinear` argument determines the method of extraction. If `TRUE`, bilinear interpolation is used; otherwise, the nearest neighbor method is used.

---
























