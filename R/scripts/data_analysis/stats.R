# 
# 土屋 賢治 2022. 
# Stats module for the CSV Kenya macro files 
setwd(paste(getwd(),"/data_analysis/", sep=""))
source("commons.R")
library(dplyr) 
library(corpcor)
library(tidyverse)
library(broom)
library(glmnet)
library(forecast)
require(smooth)


run_stats_analysis <- function(type_of_data){
  if(type_of_data == 'social'){
    exclusion <- c('ECONOMIC', 'AID')
  }else if(type_of_data == 'aid'){
    exclusion <- c('ECONOMIC', 'SOCIAL')
  } else if(type_of_data == 'economic'){
    exclusion <- c('SOCIAL', 'AID')
  } else {exclusion <- "completelyrandomandinappropriatename"}
  
  df <- ingest_csv_file("../../../data/final/main_universe.csv") 
  rownames(df) <- df$year
  df <- select(df,-c('year', 'X'))

  lambdas = 10^seq(3, -2, by = -.1)
  X_predictors <- df %>% select(-contains("GDP"))
  X_predictors <-X_predictors %>% select(-contains("GNI"))
  X_predictors <-X_predictors %>% select(-contains("year"))
  X_predictors <-X_predictors %>% select(-contains(exclusion))
  

  y  <- df["ECONOMIC_GNI..current.US...x"] 
  x <-  df %>% select(colnames(X_predictors))
  fit <- glmnet(data.matrix(x)
, data.matrix(y), alpha = 1, lambda = lambdas)
  cv_fit <- cv.glmnet(data.matrix(x), data.matrix(y), alpha = 1, lambda = lambdas)
  optlambda <- cv_fit$lambda.min
  y_predicted <- predict(fit, s = optlambda, newx = data.matrix(x))
  sst <- sum(y^2)
  sse <- sum((y_predicted - y)^2)
  rsq <- 1 - sse / sst
  coef <- coef(cv_fit, s = optlambda)
  coef[which(coef != 0 ) ]           
  coef@Dimnames[[1]][which(coef > 0 ) ] 
  coef <- data.frame(
    features = coef@Dimnames[[1]][ which(coef > 0 ) ], #intercept included
    coef    = coef[ which(coef> 0 ) ]  #intercept included
  )
  
  write.csv(as.data.frame(coef), str_interp('../../../data/forecast/coefficients_${type_of_data}.csv'))
}

holt_winter <- function(data, i){
  
  temp_results = data.frame()
  temp <- HoltWinters(data,  beta=TRUE, gamma=FALSE)
  results <- predict(temp, n.ahead = 10, prediction.interval = FALSE,
                     level = 0.95)
  results <- as.data.frame(results)
  names(results)[names(results) == 'fit'] <- i
  return(results)
  
}

run_mass_holt_winter <- function(){
  
  social_coefficients <- ingest_csv_file("../../../data/forecast/coefficients_social.csv") 
  economic_coefficients <- ingest_csv_file("../../../data/forecast/coefficients_economic.csv") 
  aid_coefficients <-  ingest_csv_file("../../../data/forecast/coefficients_aid.csv") 
  df <- ingest_csv_file("../../../data/final/main_universe.csv") 
  features <- c(colnames(social_coefficients), colnames(economic_coefficients),colnames(aid_coefficients))
  num_col <-length(colnames(social_coefficients)) + length(colnames(aid_coefficients)) + length(colnames(economic_coefficients))
  output <- data.frame(matrix(ncol=num_col, nrow=nrow(df) + 10))
  complete <- dplyr::bind_rows(social_coefficients, economic_coefficients)
  complete <- dplyr::bind_rows(complete, aid_coefficients)
  write.csv(complete, str_interp('../../../data/forecast/check_DAT.csv'))
  
  #Step 1:  running holt winter on all data
  
  for(i in complete$features){
    
    results<- holt_winter(df[i], i)
    output[i] <- dplyr::bind_rows(df[i], results)

  }
  
  #We add the GNI data
  
  results <- holt_winter(df["ECONOMIC_GNI..current.US...x"], "ECONOMIC_GNI..current.US...x")
  output["ECONOMIC_GNI..current.US...x"] <- dplyr::bind_rows(df["ECONOMIC_GNI..current.US...x"], results)
  output["year"] <- 1960:2028
  output['X1'] <- NULL
  output['X2'] <- NULL
  output['X3'] <- NULL
  output['X4'] <- NULL
  output['X5'] <- NULL
  output['X6'] <- NULL
  output['X7'] <- NULL
  output['X8'] <- NULL
  output['X9'] <- NULL
  
  write.csv(output, str_interp('../../../data/forecast/forecasted_DAT.csv'))
  
}


run_arima <- function(x){
  
}
