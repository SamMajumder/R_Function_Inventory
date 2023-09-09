## `Missing_data_insights`

### Description:
The `Missing_data_insights` function provides insights into missing data within a dataframe. It returns a list containing the count of missing values for each variable, the percentage of missing values for each variable, and a bar plot visualizing the percentage of missing values.

### Parameters:
- **df**: A dataframe for which you want to analyze missing data.
- **columns_to_remove**: A vector of column names that you want to exclude from the analysis. Default is `NULL`, meaning no columns are excluded.

### Returns:
A list containing:
- **Missing_data_count**: A dataframe showing the count of missing values for each variable.
- **Missing_data_percent**: A dataframe showing the percentage of missing values for each variable.
- **Missing_Valu_plot**: A ggplot object visualizing the percentage of missing values for each variable.

**Example Usage:**

data_insights <- Missing_data_insights(my_dataframe, columns_to_remove = c("column1", "column2"))

## Notes:
- The function uses the gather function from the tidyverse package to reshape the dataframe for analysis. Ensure that the tidyverse package is installed and loaded.
- The function returns a ggplot object for the missing value plot. To view the plot, you can simply print the Missing_Valu_plot element from the returned list.
- If you provide column names in the columns_to_remove parameter, those columns will be excluded from the analysis.
