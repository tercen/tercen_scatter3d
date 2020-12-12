library(shiny)
library(tercen)
library(plotly)
library(tidyverse)
library(reshape2)

############################################
#### This part should not be modified
getCtx <- function(session) {
  # retreive url query parameters provided by tercen
  query <- parseQueryString(session$clientData$url_search)
  token <- query[["token"]]
  taskId <- query[["taskId"]]
  
  # create a Tercen context object using the token
  ctx <- tercenCtx(taskId = taskId, authToken = token)
  return(ctx)
}
####
############################################

server <- shinyServer(function(input, output, session) {
  
  what_cols = reactive({
    c("0", "1", "2")
  })
  
  xyz = reactive({
    cxyz = what_cols()
    ctx = getCtx(session)
    if(length(ctx$colors) > 0){
      df = ctx %>%
        select(.ri,.ci,.y) %>%
        bind_cols(ctx$select(ctx$colors))
      val = df %>%
        dcast(.ri ~ .ci, value.var = ".y") %>% 
        select(X = any_of(cxyz[1]), Y = any_of(cxyz[2]), Z = any_of(cxyz[3]))
      clr = df %>% 
        dcast(.ri ~ .ci, value.var = ctx$colors[[1]]) %>%
        select(clr = any_of("0"))
      result = val %>%bind_cols(clr)
    } else {
      result = ctx %>%
        select(.ri,.ci,.y) %>%
        dcast(.ri ~ .ci, value.var = ".y") %>% 
        select(X = any_of(cxyz[1]), Y = any_of(cxyz[2]), Z = any_of(cxyz[3])) %>%
        mutate(clr = ".")
    }
  })
  
  output$sp <- renderPlotly({
    df = xyz()
    fig = plot_ly(df, x = ~X, y = ~Y, z = ~Z, color = ~clr)
    fig = fig %>% add_markers()
  })
  
})

