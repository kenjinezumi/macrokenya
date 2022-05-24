# 
# 土屋 賢治 2022. 
# Ingestion class for the CSV Kenya macro files 
install.packages(c('logger',
                   'stringr', 
                   'EnvStats'),
                 repos = "http://cran.us.r-project.org")
library(logger)
library(stringr)
library(EnvStats)


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

get_nan_distribution <- function(dataframe){
  distribution <- quantile(dataframe, probs = seq(.1, .9, by = .1))
  return(distribution)
}

get_outliers_count <- function(dataframe){
  tryCatch(
    error = function(e){
      return(FALSE)
    },
  if (length(dataframe) < 10){
    return(FALSE)
  }else{
  test <- rosnerTest(dataframe,
             k = length(dataframe) - 2
  )
  if(any(test$all.stats['Outlier'] == TRUE) ){
    return(TRUE)

  } else {
    return(FALSE)
  }
  
  }
  )
  
}

get_logs_summary <- function(dataframe, output_filename){
  metrics <- c('median', 'mean', 'min', 'max', 'std', 'NaN_count', "Data_completion", "Potential_outlier")
  df <- data.frame(matrix(NA,    # Create empty data frame  
                          nrow = length(metrics),
                          ncol = length(colnames(dataframe))))
  
  row.names(df) <- metrics
  colnames(df) <- colnames(dataframe)
  for(i in colnames(df)){
    
    df["median", i] = median(as.numeric(na.omit(unlist(dataframe[i]))))
    df["mean", i] = mean(as.numeric(na.omit(unlist(dataframe[i]))))
    df["min", i] = min(as.numeric(na.omit(unlist(dataframe[i]))))
    df["max", i] = max(as.numeric(na.omit(unlist(dataframe[i]))))
    df["std", i] = sd(as.numeric(na.omit(unlist(dataframe[i]))))
    df["NaN_count", i] = sum(is.na(dataframe[i]))
    df["Data_completion", i] = df["NaN_count", i] / nrow(dataframe)
    df["Potential_outlier", i] = get_outliers_count(as.numeric(na.omit(unlist(dataframe[i]))))
  }
  df <- t(df)
  
  write.csv(df ,str_interp('../../../logs/summary/${output_filename}'))
}