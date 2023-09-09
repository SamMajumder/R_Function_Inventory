################
### RANDOM FOREST ###
##############  

Random_forest_analysis <- function(df,response,params,
                                   test_predictors,
                                   test_response){
  
  Rf <- train(df, response,method="rf",trControl=params,verbose=F)  
  
  print(Rf)
  
  p_rf <- predict(Rf,test_predictors) 
  
  RMSE_rf <- RMSE(p_rf,test_response) 
  
  print(RMSE_rf)
  
  list <- list("Rf" = Rf, "predicted_rf" = p_rf,"RMSE" = RMSE_rf)
  
  return(list)
  
}  
