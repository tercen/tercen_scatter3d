library(shiny)
library(plotly)
library(tidyr)

ui = shinyUI(fluidPage(
  
  titlePanel("Scatter 3D"),
  
  sidebarPanel(
    selectInput("X", "X", choices = ""),
    selectInput("Y", "Y", choices = ""),
    selectInput("Z", "Z", choices = ""),
    selectInput("ColourBy", "Colour by", choices = ""),
    width = 3
  ),
  mainPanel(
    plotlyOutput("sp", height = "600px")
  )
  
))