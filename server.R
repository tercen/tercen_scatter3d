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

server <- function(input, output, session) {
  ctx = getCtx(session)
  clist = ctx$cselect() %>% 
    unite("clist") %>% 
    mutate(cname = as.character( (1:n())-1))
  
  updateSelectInput(session, "X", choices = clist$clist, selected = clist$clist[1])
  updateSelectInput(session, "Y", choices = clist$clist, selected = clist$clist[2])
  updateSelectInput(session, "Z", choices = clist$clist, selected = clist$clist[3])
  
  if(length(ctx$colors) > 0){
    clr = data.frame(clist = unlist(ctx$colors)) %>%
      mutate(cname = as.character( (1:n())-1))
    updateSelectInput(session, "ColourBy", choices = clr$clist, selected = clr$clist[1])
  }
  
  whatx = reactive({
    if (input$X == ""){
      clist$cname[1]
    } else {
      slist = clist %>% filter(input$X == clist)
      slist$cname
    }
  })
  
  whaty = reactive({
    if (input$Y == ""){
      clist$cname[2]
    } else {
      slist = clist %>% filter(input$Y == clist)
      slist$cname
    }
  })
  
  whatz = reactive({
    if (input$Z == ""){
      clist$cname[3]
    } else {
      slist = clist %>% filter(input$Z == clist)
      slist$cname
    }
  })
  
  whatclr = reactive({
    if (input$ColourBy == ""){
      clr$clist[1]
    } else {
      input$ColourBy
    }
  })
  
  xyz = reactive({
    if(length(ctx$colors) > 0){
      df = ctx %>%
        select(.ri,.ci,.y) %>%
        bind_cols(ctx$select(ctx$colors))
      val = df %>%
        dcast(.ri ~ .ci, value.var = ".y") %>% 
        select(X = whatx(), Y = whaty(), Z = whatz())
      clr = df %>% 
        dcast(.ri ~ .ci, value.var = whatclr()) %>%
        select(clr = "0")
      result = val %>%bind_cols(clr)
    } else {
      result = ctx %>%
        select(.ri,.ci,.y) %>%
        dcast(.ri ~ .ci, value.var = ".y") %>% 
        select(X = whatx(), Y = whaty() , Z = whatz()) %>%
        mutate(clr = ".")
    }
  })
  
  output$sp <- renderPlotly({
    df = xyz()
    fig = plot_ly(df, x = ~X, y = ~Y, z = ~Z, color = ~clr)
    fig = fig %>% add_markers()
  })
}