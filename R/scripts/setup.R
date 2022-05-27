# 
# 土屋 賢治 2022. 
# setup module  
install.packages(c("logger","stringr","dplyr","corpcor", "tidyverse", "broom", "glmnet","forecast", "smooth"),
                  repos = "http://cran.us.r-project.org")
  source("utils.R")
  source("data_ingestion/factory.R")
  
  setup_data <- function(){
    list_folders = c("../../data/final", "../../data/forecast/", "../../data/summary/", "../../data/transformed/")
    clean(list_folders)
    run_ingestion()
  
  }
  setup_data() 

  source("data_analysis/exploration.R")
  setup_exploration <- function(){
    run_exploration()
    
  }
  setup_exploration() 

source("data_analysis/stats.R")
run_stats_analysis('social')
run_stats_analysis('economic')
run_stats_analysis('aid')
run_stats_analysis('all')
run_mass_holt_winter()

