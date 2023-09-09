### It creates a bunch of raster plots ### 
### it plots points on the maps based on the id ### and colors them based on their values ##


#######################
#####
################ 

plot_rasters_with_sf_points_interactive_multi <- function(raster_list, df_sf, id_column, 
                                                          hovertext_columns, title_strings, 
                                                          color_column = NULL, 
                                                          color_ramp = "YlOrRd",
                                                          color_direction = 1) {
  
  # Extract coordinates from sf object and add them as regular columns
  coords <- st_coordinates(df_sf)
  df_sf$Longitude <- coords[, "X"]
  df_sf$Latitude <- coords[, "Y"]
  
  # Split the dataframe based on the id_column
  df_list <- split(df_sf, df_sf[[id_column]])
  
  # Generate color palette
  color_palette <- colorRampPalette(brewer.pal(9, color_ramp))(100)
  if (color_direction == -1) {
    color_palette <- rev(color_palette)
  }
  
  # Initialize a list to store the plots
  plot_list <- list()
  
  # Loop through each raster and corresponding dataframe
  for (i in seq_along(raster_list)) {
    current_raster <- raster_list[[i]]
    current_df <- df_list[[i]]
    
    # Create hovertext for the current dataframe
    hovertext <- apply(current_df[, hovertext_columns], 1, function(row) {
      paste(names(row), row, sep = ": ", collapse = "<br>")
    })
    
    # Convert raster to dataframe for plotting
    df_raster <- as.data.frame(current_raster, xy = TRUE)
    
    # Base plot
    p <- ggplot() +
      geom_raster(data = df_raster, aes(x = x, y = y, fill = layer)) +
      scale_fill_viridis_c(name = "Value", option = "C", direction = -1) +
      coord_equal() +
      theme_minimal() +
      xlab("Longitude") + 
      ylab("Latitude") +
      theme(panel.background = element_rect(fill = "white")) +
      labs(title = title_strings[i])  # Add title here
    
    # Conditionally add geom_point based on the type of color_column
    if (!is.null(color_column)) {
      p <- p + geom_point(data = current_df, aes(x = Longitude, y = Latitude, color = !!sym(color_column), text = hovertext), size = 3) +
        scale_color_gradient(low = color_palette[1], high = tail(color_palette, 1), guide = "none")
    } else {
      p <- p + geom_point(data = current_df, aes(x = Longitude, y = Latitude, text = hovertext), color = "red", size = 3)
    }
    
    # Convert to plotly for interactivity
    interactive_plot <- ggplotly(p, tooltip = "text")
    
    # Append to the plot list
    plot_list[[i]] <- interactive_plot
  }
  
  return(plot_list)
}

