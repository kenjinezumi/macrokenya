# 
# 土屋 賢治 2022. 
# Ingestion class for the CSV Kenya macro files 

source("ingestion.R")
source("validators.R")
library(dplyr)
library(logger)


refactor_unique_columns <- function(dataframe, 
                                    column_to_check, 
                                    date_index, 
                                    column_values){
  
  unique_values = unique(dataframe[,column_to_check])
  unique_years = sort(na.omit(
    as.numeric(unique(dataframe[,date_index]))
    ), decreasing=FALSE)
  df = data.frame(
      "year" = unique_years
  )
  for(i in unique_values){
    temp <- dataframe[dataframe[column_to_check]==i,]
    temp <- temp[c(date_index, column_values)]
    temp <- temp[order(temp[date_index]), c(date_index, column_values)]
    temp_final <- data.frame(
      "year" =  c(temp[date_index])
    )
    colnames(temp_final)[colnames(temp_final) == 'Year'] <- 'year'
    
    temp_final[i] <- temp[column_values]
    temp_final["year"] <-as.numeric(unlist(temp_final["year"]))
    temp_final <- temp_final[!duplicated(temp_final["year"]), ] 
    
    df <- merge(df, temp_final,by = "year", all.x = TRUE)  
  
    
  }
  return(df)
}
