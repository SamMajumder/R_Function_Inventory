######## 
### FUNCTION THAT COMPUTES ALE VALUES FROM TRAINING AND TEST ###
################ 

ALE_values <- function(predictors_train,
                       predictors_test,
                       response_train,
                       response_test,
                       model) { 
  
  Ale_train <- Predictor$new(model, 
                             data = predictors_train,
                             y = response_train) 
  
  Ale_test <- Predictor$new(model, 
                            data = predictors_test,
                            y = response_test) 
  
  
  ## computing the local effects on the training dataset
  ALE_train_effects <- FeatureEffects$new(Ale_train,
                                          method = "ale")
  
  
  ## computing the local effects on the test dataset
  ALE_test_effects <- FeatureEffects$new(Ale_test,
                                         method = "ale")
  
  
  ## extracting the local effects from the training dataset
  ALE_train_values <- ALE_train_effects[["results"]]
  
  
  ## extracting the local effects from the test dataset
  ALE_test_values <- ALE_test_effects[["results"]]
  
  
  
  ## put all the effects in one dataframe ### train
  ALE_train_values <- do.call(rbind,ALE_train_values) 
  
  ALE_train_values <- ALE_train_values %>% mutate(Dataset = "Train")
  
  
  ## put all the effects in one dataframe ### test
  ALE_test_values <- do.call(rbind,ALE_test_values) 
  
  ALE_test_values <- ALE_test_values %>% mutate(Dataset = "Test")
  
  
  ALE <- rbind(ALE_train_values,ALE_test_values) 
  
  return(ALE)
  
}