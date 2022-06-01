# 
# 土屋 賢治 2022. 
# R Shiny UI
library(shiny)
library(shinydashboard)
library(dplyr)
library(plotly)
source("helpers.R")


forecasted_data = ingest_csv_file("../data/forecast/forecasted_DAT.csv")
colnames_data = colnames(forecasted_data)

header <- 
  dashboardHeader(
    title= HTML("Kenya macro-economic factors (1960-2018)"),
    titleWidth = 550
    )

sidebar <-
  dashboardSidebar(
    width=500,
    h4("Simulator"),

    selectInput(
      inputId="factors_selector",
                label="Select a factor category:",
                choices=c("Social factors",
                          "Economic factors",
                          "Aid factors",
                          "All"), 
                multiple = TRUE, 
      selected="All"),
    
    selectInput(
      width=500,
      inputId="feature_selector",
      label="Select a variable:",
      choices = NULL, 
      multiple = TRUE),
  
    
    sliderInput(width=400,
  inputId="delta", 
    label="Select the amount to reduce or increase", min=-100, max=100, value=0))



body <-   
  dashboardBody(
    #First group of graphs

        fluidRow(box(width=12, plotlyOutput("plot1"))),
        fluidRow(
          box(width=6, plotlyOutput("plot2")),
          box(width=6, plotlyOutput("plot3")))
        
        
  )
   
    
    

  
ui <- dashboardPage(header, sidebar, body)
