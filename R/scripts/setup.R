# 
# 土屋 賢治 2022. 
# setup module  
install.packages(c("logger","stringr","dplyr","corpcor", "tidyverse", "broom", "glmnet","forecast", "smooth", "here"),
                   repos = "http://cran.us.r-project.org")
library(here)
here("scripts")
source("utils.R")
source("data_ingestion/factory.R")
source("data_analysis/exploration.R")
source("data_analysis/stats.R")
library(logger)
 

 setup_data <- function(){
     list_folders = c("../../data/final/", "../../data/forecast/", "../../data/summary/", "../../data/transformed/")
     log_info("Cleaning folders.")
     clean(list_folders)
     log_info("Running ingestion.")
     run_ingestion()
     log_info("Ingestion done.")


 }
 setup_data()


  setup_exploration <- function(){
    log_info("Run exploration.")

      run_exploration()
  }

 setup_exploration()


setup_stats <- function(){
log_info("Running the coefficients for social data.")
run_stats_analysis('social')
log_info("Running the coefficients for economic data.")
run_stats_analysis('economic')
log_info("Running the coefficients for aid data.")
run_stats_analysis('aid')
log_info("Running the coefficients for all data.")
run_stats_analysis('all')
log_info("Running Holt Winter.")
run_mass_holt_winter()

}

setup_stats()