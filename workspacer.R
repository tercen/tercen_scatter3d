library(shiny)
library(tercen)
library(plotly)
library(tidyverse)
library(reshape2)

 
source("ui.R")
source("server.R")

options("tercen.workflowId"= "8f17d834dda49eba43ac822ed600aa7b")
options("tercen.stepId"= "706ac7cf-8dd6-41a9-83a7-b5802ea67031")

#runApp(shinyApp(ui, server))  
