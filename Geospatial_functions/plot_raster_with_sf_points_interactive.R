

### This function creates an interactive map with a raster and point data overlayed on the raster

plot_raster_with_sf_points_interactive <- function(mean_raster, df_sf, 
                                                   hovertext_columns, 
                                                   plot_title = "Interactive Plot") {
  
  # Extract coordinates from sf object and add them as regular columns
  coords <- st_coordinates(df_sf)
  df_sf$Longitude <- coords[, "X"]
  df_sf$Latitude <- coords[, "Y"]
  
  # Create hovertext
  hovertext <- apply(df_sf[, hovertext_columns], 1, function(row) {
    paste(names(row), row, sep = ": ", collapse = "<br>")
  })
  
  # Convert raster to dataframe for plotting
  df_raster <- as.data.frame(mean_raster, xy = TRUE)
  
  # Plot using ggplot2
  p <- ggplot() +
    geom_raster(data = df_raster, aes(x = x, y = y, fill = layer)) +
    scale_fill_viridis_c(name = "Value", option = "C", direction = -1) +
    geom_point(data = df_sf, aes(x = Longitude, 
                                 y = Latitude, 
                                 text = hovertext), 
               color = "red", size = 3) +
    coord_equal() +
    theme_minimal() +
    xlab("Longitude") + 
    ylab("Latitude") +
    theme(panel.background = element_rect(fill = "white")) +
    labs(title = plot_title)  # Add title here
  
  # Convert to plotly for interactivity
  interactive_plot <- ggplotly(p, tooltip = "text") 
  
  return(interactive_plot)
}


