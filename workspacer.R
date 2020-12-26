library(shiny)
library(tercen)
library(plotly)
library(tidyverse)
library(reshape2)

source("ui.R")
source("server.R")


#http://localhost:5402/admin/w/8f17d834dda49eba43ac822ed600aa7b/ds/fd18f330-e618-4679-aa2d-92cb819fccd1
############################################
#### This part should not be included in ui.R and server.R scripts
getCtx <- function(session) {
  ctx <- tercenCtx(workflowId = "8f17d834dda49eba43ac822ed600aa7b",
                   stepId = "706ac7cf-8dd6-41a9-83a7-b5802ea67031")
  return(ctx)
}
####
############################################




runApp(shinyApp(ui, server))  
