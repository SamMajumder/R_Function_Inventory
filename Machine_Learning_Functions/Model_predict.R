#####
### Predict ###
#######


Model_predict <- function(predictors_train,predictors_test,
                          Model,Reference_train,
                          Reference_test,df_sf,seed) {
  
  #### making predictions on the training set
  seed 
  predictions_train <- predict(Model,predictors_train) 
  
  #### Adding the predictions to the Reference train dataframe
  Reference_train <- cbind(Reference_train,predictions_train)
  
  Reference_train <- Reference_train %>% 
    dplyr::mutate(Dataset = "Train") %>% 
    dplyr::rename(Predictions = predictions_train)
  
  
  ### making predictions on the test set 
  seed
  predictions_test <- predict(Model,predictors_test) 
  
  ##### Adding the predictions to the Reference test dataframe
  Reference_test <- cbind(Reference_test,predictions_test) 
  
  Reference_test <- Reference_test %>% 
    dplyr::mutate(Dataset = "Test") %>% 
    dplyr::rename(Predictions = predictions_test)
  
  
  Predictions <- rbind(Reference_train,Reference_test) 
  
  Predictions <- dplyr::inner_join(df_sf,Predictions)
  
  return(Predictions)
  
}
