

Missing_data_insights <- function(df,columns_to_remove = NULL){
  
  df_1 <- df %>% 
    select(-c(columns_to_remove)) 
  
  Missing_values <- df_1 %>%
    gather(key = "key", value = "val") %>%
    mutate(is.missing = is.na(val)) %>%
    group_by(key, is.missing) %>%
    summarise(num.missing = n()) %>%
    filter(is.missing==T) %>%
    select(-is.missing) %>%
    arrange(desc(num.missing))  
  
  
  Missing_percent <- df_1 %>%
    gather(key = "key", value = "val") %>%
    mutate(isna = is.na(val)) %>%
    group_by(key) %>%
    mutate(total = n()) %>%
    group_by(key, total, isna) %>%
    summarise(num.isna = n()) %>%
    mutate(pct = num.isna / total * 100) %>%
    mutate(Type = case_when(isna == "FALSE" ~ "Not Missing",
                            isna == "TRUE" ~ "Missing"))  
  
  
  p <-  ggplot(Missing_percent, aes(fill=Type, y=pct, x=key)) + 
    geom_bar(position='stack', stat='identity') +
    labs(x = "Variable", y = "Percent Missing") +
    coord_flip() +
    ggtitle("Percent Missing Value from each variable") +
    theme(text = element_text(size = 10))  
  
  
  Insights <-  list("Missing_data_count" = Missing_values,
                    "Missing_data_percent" = Missing_percent, 
                    "Missing_Valu_plot" = p) 
  
  return(Insights)
}
