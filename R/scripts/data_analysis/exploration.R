# 
# 土屋 賢治 2022. 
# exploration module
source("data_analysis/commons.R")
library("dplyr")
library("logger")

run_exploration <- function(){
#Step1 : data loading

  
  economic_data <- ingest_csv_file("../../data/transformed/data_economics.csv")
  social_data <- ingest_csv_file("../../data/transformed/data_social.csv") 
  aid_data <- ingest_csv_file("../../data/transformed/aid_data.csv")
  
  
  #Step 2: get basic summary for each files and write to logs summary report
  #Keep track of the missing data as well 
  
  get_logs_summary(economic_data, 'economic_summary.csv')
  get_logs_summary(social_data, 'social_summary.csv')
  get_logs_summary(aid_data, 'aid_summary.csv')
  
  
  
    #Step 3: generate the final dataframe for statistical analysis data 
  
  
    economic_data_summary <- ingest_csv_file("../../data/summary/economic_summary.csv")
    social_data_summary <- ingest_csv_file("../../data/summary/social_summary.csv")
    aid_data_summary <- ingest_csv_file("../../data/summary/aid_summary.csv")
    
    
    log_info("Step 1: Getting features.")
    
    features_economic <- get_features_based_on_missing_data(economic_data_summary, "Data_completion",
                                                            c('X'),
                                                            0.4)
    features_social <-get_features_based_on_missing_data(social_data_summary, "Data_completion",
                                                         c('X'),
                                                         0.4)
    features_aid <-get_features_based_on_missing_data(aid_data_summary, "Data_completion",
                                                      c('X'),
                                                      0.4)
    log_info("Step 2: Filtering by  features.")
    
    

    dataframe_economic <- economic_data[,which(names(economic_data) %in% features_economic)] 
    dataframe_social <- social_data[,which(names(social_data) %in% features_social)] 
    dataframe_aid <- aid_data[,which(names(aid_data) %in% features_aid)] 
    original_cols <- colnames(dataframe_economic)
    colnames(dataframe_economic)[colnames(dataframe_economic) != 'year'] =  paste("ECONOMIC" ,original_cols,sep="_")
    original_cols_socials<- colnames(dataframe_social)
    colnames(dataframe_social)[colnames(dataframe_social) != 'year'] =  paste("SOCIAL" ,original_cols_socials,sep="_")
    original_cols_aid <- colnames(dataframe_aid)
    colnames(dataframe_aid)[colnames(dataframe_aid) != 'year']  = paste("AID" ,original_cols_aid,sep="_")

    log_info("Step 3: Creating the main universe.")
    
    dataframe_economic <- merge(dataframe_economic, dataframe_social ,by = "year", all.x = TRUE)  
    dataframe_economic <- merge(dataframe_economic,dataframe_aid  ,by = "year", all.x = TRUE)  
    print(dataframe_economic)
    dataframe_economic <- remove_categorical_data(dataframe_economic)
    dataframe_economic<- replace_nan_with_zeros(dataframe_economic)
    dataframe_economic <- remove_categorical_data(dataframe_economic)
    
    write.csv(dataframe_economic ,str_interp('../../data/final/main_universe.csv'))
  

}