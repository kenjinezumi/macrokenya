# 
# 土屋 賢治 2022. 
# Ingestion class for the CSV Kenya macro files 
install.packages(c('logger',
                   'stringr'),
                 repos = "http://cran.us.r-project.org")
library(logger)
library(stringr)

validate_file_exists <- function(file_path_string){
  if(file.exists(file_path_string)){
    return(TRUE)
  }else{
    return(FALSE)
  }
}

remove_nan <- function(dataframe){
  return(na.omit(dataframe))
}


check_csv_file_not_empty <-function(file_path_string){
  df <- read.csv(file_path_string)
  
  if(nrow(df) == 0){
    stop(str_interp("The file ${file_path_string} is empty"))
    
  }else{
    log_info("File successfully transformed!")
  }
  
  
}

