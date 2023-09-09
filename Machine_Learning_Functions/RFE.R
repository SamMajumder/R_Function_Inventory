##############################
##### RFE FUNCTION #########
############################## 

RFE <- function(df,response,subsets,params){
  features_rfe <- rfe(response~.,data = df,
                      sizes=subsets,rfeControl=params)
  
  ## these are the predictors in the optimal subset 
  
  optimal_subset_rfe <- data.frame(Features = predictors(features_rfe))
  
  #### Importance of each variable 
  
  Rfe_Imp <- data.frame(varImp(features_rfe))
  
  Rfe_Imp <- data.frame(Features = rownames(Rfe_Imp),
                        Overall = Rfe_Imp$Overall)
  
  Rfe_Imp_best_subset <- Rfe_Imp %>%
    dplyr::filter(Features %in% optimal_subset_rfe$Features)
  
  
  ### plotting the variation of accuracy with the removal of variables
  p_1 <- ggplot(features_rfe)  
  
  p_2 <- ggplot(data = Rfe_Imp_best_subset,
                aes(x=reorder(Features,Overall), y = Overall, fill = Features)) +
    geom_bar(stat = "identity") + labs(x= "Features", y= "Variable Importance") +
    coord_flip() + 
    theme_bw() + theme(legend.position = "none") + 
    ggtitle("Optimal subset of factors") +
    theme(text = element_text(size = 10))  
  
  list <- list("Plot of variation of accuracy with the removal of variables" = p_1,
               "Importance plot" = p_2,
               "optimal subset" = optimal_subset_rfe,
               "Importance values" = Rfe_Imp_best_subset
  ) 
  return(list)
  
  
}
