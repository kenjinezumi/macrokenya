# 
# 土屋 賢治 2022. 
# R Shiny server
library(tidyverse)
library(ggplot2)
library(reshape2)
library(plotly)

source("helpers.R")


server <- function(input, output, session){
  
    
  
forecasted_data = ingest_csv_file("../data/forecast/forecasted_DAT.csv")
coefficients_all = ingest_csv_file("../data/forecast/coefficients_all.csv")


colnames_data = colnames(forecasted_data)
colnames_data = colnames_data[! colnames_data %in% c('year', 'X', 'ECONOMIC_GNI..current.US...x')]


feature_selection <- function(x){
  res <- rep()
  if("All" %in% x){
    return(colnames_data)
  }else{
    for(i in x){
      if(i == "Social factors"){
        res <- append(res, "SOCIAL_")
      }else if(i == "Aid factors"){
        res <- append(res, "AID_")
      }else if (i == "Economic factors"){
        res <- append(res, "ECONOMIC_")
      }
  filter_res <-rep()
  for(i in colnames_data){
    for(j in res){
      if(grepl(j ,i, fixed = TRUE)){
        filter_res <- append(filter_res, i)
      }
        
      
    }
  }

  return(filter_res)
      
    }
  }
}

observe({
  x <- input$factors_selector

  # Can use character(0) to remove all choices
  if (is.null(x))
    x <- character(0)
  
  # Can also set the label and select items
  updateSelectInput(session, "feature_selector",
                    label = "Select your variables:",
                    choices = feature_selection(x),
                    selected = ""
  )
})  


observe({
  
  x <- input$feature_selector
  if(length(x)>0){
  x <- append(x, 'year')
  selected_data <- forecasted_data[,x]
  output$plot1 <- renderPlotly({
    
    meltdf <- melt(selected_data,id.vars="year")
    to_be_melted_y <- forecasted_data %>% select(c('year', 'ECONOMIC_GNI..current.US...x'))
    melt_y <- melt(to_be_melted_y,id.vars="year")

    ggplot(data=meltdf, aes(x=year, y=value, group=variable, label = variable)) + geom_line() + 
       geom_vline(xintercept = 2018)  + 
      ggtitle("Time series of selected factor(s)")
    
  })
  }
})


observe({
  
  x <- input$feature_selector
  df <- subset(coefficients_all, features %in% x)

  print(df)
  output$plot2 <- renderPlotly({
  ggplot(data=df, aes(x=features, y=coef)) +
    geom_bar(stat="identity", fill="steelblue") +
      theme(legend.position="none") + ggtitle("Contribution of selected factor(s")
  })
  
  
})


observe({
  
  x <- input$feature_selector
  x <- append(x, 'year')
  y <- input$delta / 100
  
  if(is.null(input$feature_selector)) {    
    
    showNotification("var changed to null")    
    
  }

  to_be_melted_y <- forecasted_data %>% select(c('year', 'ECONOMIC_GNI..current.US...x'))
  forecast_data <- to_be_melted_y[to_be_melted_y["year"] > 2018,]
  initial_data <- to_be_melted_y[to_be_melted_y["year"] <= 2018,]
  year <- rep()
  year <- forecast_data['year']
  temp <- forecast_data[ , !(names(forecast_data) %in% 'year')]
 
  

  selected_data <-  forecasted_data %>% select(c(x))
  features_forecast_data <- selected_data[selected_data["year"] > 2018,]
  new_forecast <- forecast_data
  initial_features_forecast_data <- selected_data[selected_data["year"] <= 2018,]
  year_features <- features_forecast_data["year"]
  for(i in colnames(features_forecast_data)){
    if(i != 'year'){
    temp_diff <- features_forecast_data[i]
    features_forecast_data[i] = features_forecast_data[i] * (1 +  y)
    }
  }

  
  difference <- features_forecast_data
  
  
  for(i in colnames(features_forecast_data)){
    if(i != "year"){
      for(j in unique((coefficients_all[,"features"]))){
        if(i==j){
          temp_ = filter(coefficients_all, coefficients_all["features"] == j)
          difference[j] = difference[j] * temp_[,"coef"]
          if(y >= 0){
            new_forecast["ECONOMIC_GNI..current.US...x"] = new_forecast["ECONOMIC_GNI..current.US...x"]  + difference[i] - features_forecast_data[i]
          }else{
            new_forecast["ECONOMIC_GNI..current.US...x"] = new_forecast["ECONOMIC_GNI..current.US...x"]  - difference[i] - features_forecast_data[i]
            
            
          }
        }
      }
    }
  }
  new_forecast <- rbind(initial_data, new_forecast)

  
  output$plot3 <- renderPlotly({
    new_forecast <- new_forecast[new_forecast["year"] > 2015,]
    to_be_melted_y <- to_be_melted_y[to_be_melted_y["year"] > 2015,]
    
    meltdf <- melt(new_forecast,id.vars="year")
    melt_y <- melt(to_be_melted_y,id.vars="year")

    ggplot(data=meltdf, aes(x=year, y=value, group=variable, label = variable)) + geom_line() + 
      geom_vline(xintercept = 2018)  + 
      ggtitle("Impact on GNI (in trillion current USD") +
      geom_line(data = melt_y, aes(x=year, y=value, group=variable, label = variable), color = "blue") 
    
  })
})

}