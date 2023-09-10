
calculate_yearly_avg_raster <- function(raster_brick) {
  # Calculate the number of years based on the number of layers in the raster brick
  num_years <- ceiling(nlayers(raster_brick) / 12)
  
  yearly_avg_list <- list()
  
  # Initialize a progress bar
  pb <- progress_bar$new(total = num_years, format = "[:bar] :percent :elapsedfull")
  
  for (i in 1:num_years) {
    start_layer <- (i-1)*12 + 1
    
    # If it's the last iteration and there are less than 12 layers left, adjust the end_layer
    if (i == num_years) {
      end_layer <- nlayers(raster_brick)
    } else {
      end_layer <- start_layer + 11
    }
    
    yearly_layers <- raster_brick[[start_layer:end_layer]]
    
    # Calculate the mean for each cell across the selected layers
    yearly_avg <- raster::mean(yearly_layers)
    
    yearly_avg_list[[i]] <- yearly_avg
    
    # Update the progress bar
    pb$tick()
  }
  
  # Convert the list of raster layers to a raster stack
  yearly_avg_stack <- stack(yearly_avg_list)
  
  return(yearly_avg_stack)
}

# Example usage:
# yearly_avg_result <- calculate_yearly_avg_raster(temp_data_subset)
