###################### 
### GBM ####
################## 

Gbm_analysis <- function(df,response,
                         grid,params,test_predictors,
                         test_response) {
  
  gbm <- train(df, response,
               method="gbm",trControl=params, 
               verbose=F,tuneGrid=grid) 
  
  print(gbm)
  
  p_gbm <- predict(gbm,test_predictors) 
  
  RMSE_gbm <- RMSE(p_gbm,test_response) 
  
  print(RMSE_gbm)
  
  list <- list("GBM" = gbm, "predicted_gbm" = p_gbm, "RMSE" = RMSE_gbm)
  
  
  return(list)
  
}