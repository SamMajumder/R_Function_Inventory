####################
### XGBOOST ####
################

XGB_analysis <- function(df,response,grid,params,test_predictors,
                         test_response){
  
  xgb <- train(df,response,method="xgbTree",trControl=params,verbose=F,
               tuneGrid=grid)
  
  print(xgb)
  
  p_xgb <- predict(xgb,test_predictors) 
  
  RMSE_xgb <- RMSE(p_xgb,test_response) 
  
  print(RMSE_xgb)
  
  list <- list("XGB" = xgb, "predicted_xgb" = p_xgb,"RMSE" = RMSE_xgb)
  
  
  return(list)
  
}