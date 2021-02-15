library(shiny)
library(tercen)
library(plotly)
library(tidyverse)
library(reshape2)
 
source("ui.R")
source("server.R")

# http://127.0.0.1:5402/admin/w/0612c2394fcb749bb65db387fd0069f6/ds/850b44ed-c0a7-4976-8723-4d74f3c28693
#http://localhost:5402/admin/w/8f17d834dda49eba43ac822ed600aa7b/ds/fd18f330-e618-4679-aa2d-92cb819fccd1
############################################
#### This part should not be included in ui.R and server.R scripts
getCtx <- function(session) {
  ctx <- tercenCtx(workflowId = "0612c2394fcb749bb65db387fd0069f6",
                   stepId = "850b44ed-c0a7-4976-8723-4d74f3c28693")
  return(ctx)
}
####
############################################




runApp(shinyApp(ui, server))  
