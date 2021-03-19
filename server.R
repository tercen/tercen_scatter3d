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

server <- shinyServer( 
  function(input, output, session) {
    
    dataInput <- reactive({
      getValues(session)
    })  
    
    observe({
      df = dataInput()
      cnames = levels(df$cnames)
      
      whatx = reactive({
        name = ifelse (input$X == "", cnames[1], input$X)
        data = df %>% filter(cnames == name) %>% arrange(.ri, .ci)
        return(data$.y)
      })
      
      whaty = reactive({
        name = ifelse (input$Y == "", cnames[1], input$Y)
        data = df %>% filter(cnames == name) %>% arrange(.ri, .ci)
        return(data$.y)
      })
      
      whatz = reactive({
        name = ifelse (input$Z == "", cnames[1], input$Z)
        data = df %>% filter(cnames == name) %>% arrange(.ri, .ci)
        return(data$.y)
      })
      
      whatclr = reactive({
        data = df %>% filter(cnames == cnames[1]) %>% 
          arrange(.ri, .ci) %>%
          select(clr = all_of(input$ColourBy))
        return(data$clr)
      })
      
      xyz = reactive({
        xyz = data.frame(X = whatx(), Y = whaty(), Z = whatz(), clr = whatclr())
      })
      
      output$sp <- renderPlotly({
        plot.df = xyz()
        fig = plot_ly(plot.df, x = ~X, y = ~Y, z = ~Z ,color = ~clr)
        fig = fig %>% add_markers()
      })
      
    })
  })

getValues <- function(session){
  ctx <- getCtx(session)
  df <- ctx %>% 
    select(.y, .ri, .ci)
  if(length(ctx$colors)) df = df %>% bind_cols(ctx$select(ctx$colors))
  if(length(ctx$labels)) df = df %>% bind_cols(ctx$select(ctx$labels))
  
  cnames = ctx$cselect()[[1]]
  updateSelectInput(session, "X", choices = cnames, selected = cnames[1])
  updateSelectInput(session, "Y", choices = cnames, selected = cnames[2])
  updateSelectInput(session, "Z", choices = cnames, selected = cnames[3])
  updateSelectInput(session, "ColourBy", choices = unlist(ctx$colors))
  
  df = df %>% 
    left_join(data.frame(.ci = 0:(length(cnames)-1), cnames), by = ".ci") %>%
    mutate( across(!where(is.numeric), as.factor)) 
  return(df)
}

