library(shiny)
library(plotly)
library(tidyr)

shinyUI(fluidPage(
  
  titlePanel("Scatter 3D"),
  
  sidebarPanel(
    selectInput("X", "X", choices = ""),
    selectInput("Y", "Y", choices = ""),
    selectInput("Z", "Z", choices = "")
    
  ),
  
  mainPanel(
    plotlyOutput("sp", height = "600px")
  )
  
))