 # 
 # 土屋 賢治 2022. 
 # Ingestion class for the CSV Kenya macro files 

source("ingestion.R")
source("validators.R")
source("transformation.R")
library(dplyr)
library(logger)


 sleep_func <- function() { Sys.sleep(5) } 
 startTime <- Sys.time()
 sleep_func()
 
 #Step 1: Ingestion of economic data
 
 log_info("Transforming the economic dataset.")
 
  economic_dataset <- refactor_unique_columns(
    dataframe=ingest_csv_factory('../../../data/raw/economics/economic_data.csv'),
    column_to_check="Indicator.Name",
    date_index="Year",
    column_values="Value"
    )
  
  log_info("Transforming the trade indicators dataset.")
  
  trade_indicators <- refactor_unique_columns(
    dataframe=ingest_csv_factory('../../../data/raw/economics/trade.csv'),
    column_to_check="Indicator.Name",
    date_index = "Year",
    column_values = "Value"
  )
  
  log_info("Transforming the deflator dataset.")
  
  deflator_dataset <- refactor_unique_columns(
    dataframe=ingest_csv_factory('../../../data/raw/economics/deflators_data_prices.csv'),
    column_to_check="Element",
    date_index = "Year",
    column_values = "Value"
  )
 
  log_info("Transforming the mining dataset.")
  
  mining_dataset <- refactor_unique_columns(
      dataframe=ingest_csv_factory('../../../data/raw/economics/energy_mining.csv'),
      column_to_check="Indicator.Name",
      date_index = "Year",
      column_values = "Value"
   )
 
  
  key_economic_indicators <- refactor_unique_columns(
       dataframe=ingest_csv_factory('../../../data/raw/economics/economic_indicators.csv'),
       column_to_check="Indicator.Name",
       date_index = "Year",
       column_values = "Value"
    )
 
  log_info("Transforming the external debt dataset.")
  
  external_debt_indicators <- refactor_unique_columns(
         dataframe=ingest_csv_factory('../../../data/raw/economics/external_debt.csv'),
         column_to_check="Indicator.Name",
         date_index = "Year",
         column_values = "Value"
      )
  
  log_info("Transforming the financial sector dataset.")
  
 
  financial_indicators <- refactor_unique_columns(
          dataframe=ingest_csv_factory('../../../data/raw/economics/financial_sector.csv'),
          column_to_check="Indicator.Name",
          date_index = "Year",
          column_values = "Value"
       )
 
  log_info("Transforming the patent technology dataset.")
  
  patent_indicators <- refactor_unique_columns(
    dataframe=ingest_csv_factory('../../../data/raw/economics/patent_technology.csv'),
    column_to_check="Indicator.Name",
    date_index = "Year",
    column_values = "Value"
  )
  
  log_info("Transforming the private sector dataset.")
  
 
  private_sector_indicators <- refactor_unique_columns(
    dataframe=ingest_csv_factory('../../../data/raw/economics/private_sector.csv'),
    column_to_check="Indicator.Name",
    date_index = "Year",
    column_values = "Value"
  )
  
  log_info("Transforming the public sector dataset.")
  
 
  public_sector_indicators <- refactor_unique_columns(
     dataframe=ingest_csv_factory('../../../data/raw/economics/public_sector.csv'),
     column_to_check="Indicator.Name",
     date_index = "Year",
     column_values = "Value"
   )
 
  log_info("Transforming the rural activity dataset.")
  
  
  rural_sector_indicators <- refactor_unique_columns(
     dataframe=ingest_csv_factory('../../../data/raw/economics/rural_activity.csv'),
     column_to_check="Indicator.Name",
     date_index = "Year",
     column_values = "Value"
    )
  
  log_info("Transforming the exchange rate dataset.")
  
 
  exchange_rate <- refactor_unique_columns(
    dataframe=ingest_csv_factory('../../../data/raw/economics/exchange_rate.csv'),
    column_to_check="Item",
    date_index = "Year",
    column_values = "Value"
  )
  
  
  #Step 1.b: Ingestion of economic data
  
  log_info("Merging files altogether.")
  
  economic_dataset <- merge(economic_dataset, trade_indicators ,by = "year", all.x = TRUE)  
  economic_dataset <- merge(economic_dataset, deflator_dataset ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset, trade_indicators ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset,  mining_dataset ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset,  key_economic_indicators ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset,  external_debt_indicators ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset,  patent_indicators ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset,  financial_indicators ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset,  private_sector_indicators ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset,  public_sector_indicators ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset,  rural_sector_indicators ,by = "year", all.x = TRUE) 
  economic_dataset <- merge(economic_dataset,  exchange_rate ,by = "year", all.x = TRUE) 
  
 
#Step 1.c: export of economic data
  
 log_info("Exporting economic data.")
  
 write.csv(  economic_dataset,'../../../data/transformed/data_economics.csv')
  endTime <- Sys.time()
  runtime <- endTime - startTime
  log_info(str_interp("Transformation of the economic dataset completed in ${runtime}"))

#Step 2: ingestion of social data

log_info("Starting ingestion of social data.")

sleep_func <- function() { Sys.sleep(5) } 
startTime <- Sys.time()
sleep_func()

log_info("Starting ingestion of the social develop dataset.")

social_development_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/social/social_development.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)

log_info("Starting ingestion of the social protection dataset.")


social_protection_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/social/social_protection.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)

log_info("Starting ingestion of the urban development dataset.")


urban_development_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/social/urban_development.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)

log_info("Starting ingestion of the education dataset.")


education_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/social/education.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)

log_info("Starting ingestion of the gender dataset.")


gender_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/social/gender.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)

log_info("Starting ingestion of the health dataset.")


health_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/social/health.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)

log_info("Starting ingestion of the infrastructure dataset.")


infrastructure_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/social/infrastructure.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)

log_info("Starting ingestion of the poverty dataset.")


poverty_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/social/poverty.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)

log_info("Starting ingestion of the environment dataset.")


environment_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/social/environment.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)


social_development_indicators <- merge( social_development_indicators, social_protection_indicators ,by = "year", all.x = TRUE)  
social_development_indicators <- merge( social_development_indicators, urban_development_indicators ,by = "year", all.x = TRUE)  
social_development_indicators <- merge( social_development_indicators, education_indicators,by = "year", all.x = TRUE)  
social_development_indicators <- merge( social_development_indicators, gender_indicators,by = "year", all.x = TRUE)  
social_development_indicators <- merge( social_development_indicators, health_indicators ,by = "year", all.x = TRUE)  
social_development_indicators <- merge( social_development_indicators, infrastructure_indicators ,by = "year", all.x = TRUE)  
social_development_indicators <- merge( social_development_indicators, poverty_indicators,by = "year", all.x = TRUE)  
social_development_indicators <- merge( social_development_indicators, environment_indicators,by = "year", all.x = TRUE)  


write.csv(  social_development_indicators,'../../../data/transformed/data_social.csv')


endTime <- Sys.time()
runtime <- endTime - startTime
log_info(str_interp("Transformation of the social dataset completed in ${runtime}"))

#Step 3: ingestion of aid data

log_info("Starting ingestion of aid data.")

sleep_func <- function() { Sys.sleep(5) } 
startTime <- Sys.time()
sleep_func()


health_indicators <- refactor_unique_columns(
  dataframe=ingest_csv_factory('../../../data/raw/aid/aid-effectiveness.csv.csv'),
  column_to_check="Indicator.Name",
  date_index = "Year",
  column_values = "Value"
)

write.csv(  social_development_indicators,'../../../data/transformed/aid_data.csv')

endTime <- Sys.time()
runtime <- endTime - startTime
log_info(str_interp("Transformation of the social dataset completed in ${runtime}"))


check_csv_file_not_empty('../../../data/transformed/aid_data.csv')
check_csv_file_not_empty('../../../data/transformed/data_social.csv')
check_csv_file_not_empty('../../../data/transformed/data_economics.csv')
