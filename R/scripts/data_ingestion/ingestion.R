# 
# 土屋 賢治 2022. 
# ingestion module
library(logger)
library(stringr)
source("validators.R")

ingest_csv_file <- function(file_path_string){
  log_info(str_interp("Ingesting the file ${file_path_string}"))
  tryCatch(
    df <- read.csv(file_path_string),
    error = function(e){
      message(str_interp("There was an error with the file ${file_path_string}"))
    },
    
    warning = function(e){
      message(str_interp("There was a warning  with the file ${file_path_string}"))
      
    },
    
    finally = {
      message(str_interp("The ingestion attempt of the file ${file_path_string}
      is complete"))
    }
    
  )
  return(df)
  
}

ingest_csv_factory <- function(file_path_string){
  log_info(str_interp("Starting the task factory for data-ingestion"))
  if(validate_file_exists(file_path_string)){
      return(ingest_csv_file(file_path_string))
    }else{
      log_info(str_interp("Skipping the file ${file_path_string}")) 
    }
}
  
