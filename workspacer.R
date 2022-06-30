library(shiny)
library(tercen)
library(plotly)
library(tidyverse)
library(reshape2)

source("ui.R")
source("server.R")

options("tercen.workflowId"= "0844af3c27bc4f1fd354e37fa800aa8e")
options("tercen.stepId"= "bd77e430-6e3c-4542-956e-dd8e6458aaa3")

runApp(shinyApp(ui, server))  
