calculate_yearly_avg <- function(raster_brick) {
  require(purrr)
  require(progress)
  
  # Calculate yearly averages
  num_years <- ceiling(nlayers(raster_brick) / 12)
  
  # Create a progress bar
  pb <- progress_bar$new(total = num_years, format = "[:bar] :percent Year :current/:total (:eta/:elapsed)")
  
  yearly_avg_list <- map(1:num_years, function(i) {
    start_layer <- (i-1)*12 + 1
    
    # If it's the last iteration and there are less than 12 layers left, adjust the end_layer
    if (i == num_years) {
      end_layer <- nlayers(raster_brick)
    } else {
      end_layer <- start_layer + 11
    }
    
    yearly_layers <- raster_brick[[start_layer:end_layer]]
    
    # Calculate the mean without using calc
    yearly_avg <- mean(getValues(yearly_layers), na.rm = TRUE)
    
    # Update progress bar
    pb$tick()
    
    return(yearly_avg)
  })
  
  return(yearly_avg_list)
}


