
# Machine Learning functions #

## `RFE`

### Description:
The `RFE` (Recursive Feature Elimination) function performs feature selection on a given dataframe to identify the optimal subset of predictors for a response variable. The function returns a list containing plots visualizing the variation of accuracy with the removal of variables and the importance of each variable, as well as dataframes detailing the optimal subset of predictors and their importance values.

### Parameters:
- **df**: A dataframe containing the predictors and the response variable.
- **response**: The response variable from the dataframe.
- **subsets**: A vector of integers specifying the subset sizes to be evaluated.
- **params**: Control parameters for the `rfe` function.

### Returns:
A list containing:
- **Plot of variation of accuracy with the removal of variables**: A ggplot object visualizing the variation of accuracy as variables are removed.
- **Importance plot**: A ggplot object visualizing the importance of each variable in the optimal subset.
- **optimal subset**: A dataframe listing the predictors in the optimal subset.
- **Importance values**: A dataframe detailing the importance values of each predictor in the optimal subset.

### Note: 
- The function uses the rfe and varImp functions from the caret package. Ensure that the caret package is installed and loaded.
- The function returns two ggplot objects for visualization. To view the plots, you can simply print the corresponding elements from the returned list.
- The subsets parameter specifies the subset sizes to be evaluated by the rfe function. For example, if subsets = c(5, 10, 15), the function will evaluate subsets of sizes 5, 10, and 15.
- The params parameter provides control parameters for the rfe function. This can be set using the rfeControl function from the caret package.

### Example Usage:

rfe_results <- RFE(my_dataframe, my_response, c(5, 10, 15), rfeControl = my_params)



## `Random_forest_analysis`

### Description:
The `Random_forest_analysis` function applies the Random Forest algorithm on a given dataframe to predict a response variable. It trains a Random Forest model using the provided training data and then predicts the response on a test dataset. The function returns the trained model, the predictions on the test dataset, and the Root Mean Square Error (RMSE) of the predictions.

### Parameters:
- **df**: A dataframe containing the predictors for training.
- **response**: The response variable from the training dataframe.
- **params**: Control parameters for the `train` function.
- **test_predictors**: A dataframe containing the predictors for testing.
- **test_response**: The response variable from the test dataframe.

### Returns:
A list containing:
- **Rf**: The trained Random Forest model.
- **predicted_rf**: Predictions on the test dataset using the trained model.
- **RMSE**: The Root Mean Square Error of the predictions on the test dataset.

### Note: 
- The function uses the train and predict functions from the caret package. Ensure that the caret package is installed and loaded.
- The params parameter provides control parameters for the train function. This can be set using the trainControl function from the caret package.
- The function prints the summary of the trained Random Forest model and the RMSE of the predictions on the test dataset.
  

### Example Usage:

rf_results <- Random_forest_analysis(train_dataframe, train_response, trainControl_params, test_predictors, test_response)


## `Gbm_analysis`

### Description:
The `Gbm_analysis` function applies the Gradient Boosting Machine (GBM) algorithm on a given dataframe to predict a response variable. It trains a GBM model using the provided training data and then predicts the response on a test dataset. The function returns the trained model, the predictions on the test dataset, and the Root Mean Square Error (RMSE) of the predictions.

### Parameters:
- **df**: A dataframe containing the predictors for training.
- **response**: The response variable from the training dataframe.
- **grid**: A data frame with tuning parameters for the GBM model.
- **params**: Control parameters for the `train` function.
- **test_predictors**: A dataframe containing the predictors for testing.
- **test_response**: The response variable from the test dataframe.

### Returns:
A list containing:
- **GBM**: The trained Gradient Boosting Machine model.
- **predicted_gbm**: Predictions on the test dataset using the trained model.
- **RMSE**: The Root Mean Square Error of the predictions on the test dataset.

### Note: 
- The function uses the train and predict functions from the caret package. Ensure that the caret package is installed and loaded.
- The params parameter provides control parameters for the train function. This can be set using the trainControl function from the caret package.
- The grid parameter provides the tuning parameters for the GBM model. This can be set using a custom data frame or using the expand.grid function.
- The function prints the summary of the trained GBM model and the RMSE of the predictions on the test dataset.

### Example Usage:

gbm_results <- Gbm_analysis(train_dataframe, train_response, tuning_grid, trainControl_params, test_predictors, test_response)


## `XGB_analysis`

### Description:
The `XGB_analysis` function applies the eXtreme Gradient Boosting (XGBoost) algorithm on a given dataframe to predict a response variable. It trains an XGBoost model using the provided training data and then predicts the response on a test dataset. The function returns the trained model, the predictions on the test dataset, and the Root Mean Square Error (RMSE) of the predictions.

### Parameters:
- **df**: A dataframe containing the predictors for training.
- **response**: The response variable from the training dataframe.
- **grid**: A data frame with tuning parameters for the XGBoost model.
- **params**: Control parameters for the `train` function.
- **test_predictors**: A dataframe containing the predictors for testing.
- **test_response**: The response variable from the test dataframe.

### Returns:
A list containing:
- **XGB**: The trained eXtreme Gradient Boosting model.
- **predicted_xgb**: Predictions on the test dataset using the trained model.
- **RMSE**: The Root Mean Square Error of the predictions on the test dataset.

### Note: 
- The function uses the train and predict functions from the caret package. Ensure that the caret package is installed and loaded.
- The params parameter provides control parameters for the train function. This can be set using the trainControl function from the caret package.
- The grid parameter provides the tuning parameters for the XGBoost model. This can be set using a custom data frame or using the expand.grid function.
- The function prints the summary of the trained XGBoost model and the RMSE of the predictions on the test dataset. 

### Example Usage:

xgb_results <- XGB_analysis(train_dataframe, train_response, tuning_grid, trainControl_params, test_predictors, test_response)


## `Model_predict`

### Description:
The `Model_predict` function takes in training and test predictors, a trained model, and reference dataframes for both training and test datasets. It makes predictions on both datasets using the provided model and appends these predictions to the reference dataframes. The function then combines the training and test reference dataframes and joins them with a spatial dataframe (`df_sf`). The final combined dataframe with predictions and spatial data is returned.

### Parameters:
- **predictors_train**: A dataframe containing the predictors for the training dataset.
- **predictors_test**: A dataframe containing the predictors for the test dataset.
- **Model**: A trained model object used for making predictions.
- **Reference_train**: A reference dataframe corresponding to the training dataset.
- **Reference_test**: A reference dataframe corresponding to the test dataset.
- **df_sf**: A spatial dataframe (`sf` object) to be joined with the combined predictions dataframe.
- **seed**: A seed value for reproducibility.

### Returns:
A dataframe containing:
- The combined training and test reference data.
- Predictions made on both datasets.
- Spatial data from `df_sf`.

### Notes: 
- The function uses the predict function to make predictions on both training and test datasets.
- The seed parameter ensures reproducibility when making predictions.
- The function appends a "Dataset" column to the reference dataframes to indicate whether the data belongs to the training or test dataset.
- The function performs an inner join between the combined predictions dataframe and the spatial dataframe (df_sf) based on common columns.

### Example Usage:

final_predictions <- Model_predict(train_predictors, test_predictors, trained_model, train_reference, test_reference, spatial_df, 123)

## `ALE_values`

### Description:
The `ALE_values` function computes the Accumulated Local Effects (ALE) for both training and test datasets using a given model. ALE provides a way to understand the effect of a predictor on the model's prediction by considering the local changes in the predictor. The function returns the ALE values for each predictor in both datasets.

### Parameters:
- **predictors_train**: A dataframe containing the predictors for the training dataset.
- **predictors_test**: A dataframe containing the predictors for the test dataset.
- **response_train**: A vector or dataframe column containing the response variable for the training dataset.
- **response_test**: A vector or dataframe column containing the response variable for the test dataset.
- **model**: A trained model object used for computing ALE values.

### Returns:
A dataframe containing:
- ALE values for each predictor in both the training and test datasets.
- A "Dataset" column indicating whether the data belongs to the training or test dataset.

### Notes: 
- The function uses the Predictor$new function to initialize the predictor object for both training and test datasets.
- The FeatureEffects$new function is used to compute the ALE values for each predictor.
- The results are extracted and combined into a single dataframe with an additional "Dataset" column to differentiate between training and test data.
- Ensure that the necessary packages and functions (Predictor$new, FeatureEffects$new) are installed and loaded before using this function.

### Example Usage:

ale_results <- ALE_values(train_predictors, test_predictors, train_response, test_response, trained_model)







