# 
# 土屋 賢治 2022. 
# Helpers
library(logger)
library(stringr)

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