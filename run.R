install.packages(c("shiny","shinydashboard", "ggplot2", "dplyr","reshape2", "plotly"),
                 repos = "http://cran.us.r-project.org")
library(shiny)
library(here)

runApp("shiny", 
       port=8080, host='127.0.0.1')