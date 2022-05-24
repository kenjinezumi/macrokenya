# 
# 土屋 賢治 2022. 
# Ingestion class for the CSV Kenya macro files 

source("utils.R")


#Step1 : data loading

economic_data <- ingest_csv_file("../../../data/transformed/aid_data.csv")
social_data <- ingest_csv_file("../../../data/transformed/data_social.csv")
aid_data <- ingest_csv_file("../../../data/transformed/data_economics.csv")


#Step 2: get basic summary for each files and write to logs summary report
#Keep track of the missing data as well 

get_logs_summary(economic_data, 'economic_summary.csv')
get_logs_summary(social_data, 'social_summary.csv')
get_logs_summary(aid_data, 'aid_summary.csv')



#Step 3: regression to get beta-coefficients