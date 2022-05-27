# 
# 土屋 賢治 2022. 
# utils module
library(stringr)
library(logger)
library(forecast)

check_folder_is_empty <- function(directory_path_name){
  log_info(str_interp("Checking if directory: ${directory_path_name} is empty."))
  if(length(list.files(directory_path_name)) > 0){
    log_info(str_interp("Directory: ${directory_path_name} is not empty."))
    return(FALSE)
  }else{
    log_info(str_interp("Directory: ${directory_path_name} is empty."))
    return(TRUE)
  }
  
}

delete_folder_if_empty <- function(directory_path_name){
  if(check_folder_is_empty(directory_path_name) == FALSE){
    list_files = list.files(directory_path_name)
    for(i in list_files){
      file.remove(paste(directory_path_name, i, sep=""))
      log_info(str_interp("Removing file: ${i}."))
      
    }
    if(check_folder_is_empty(directory_path_name) == FALSE){
      stop(str_interp(
        "There has been an error cleaning the directory: ${directory_path_name}")
        )
    }
    else{
      log_info(str_interp("Successful cleaning of the directory: ${directory_path_name}"))
      
    }
  }
}

clean <- function(list_directory){
  log_info("Starting the cleaning")
  
  for(i in list_directory){
    if(check_folder_is_empty(i) == FALSE){
      delete_folder_if_empty(i)
    }
  }
}
