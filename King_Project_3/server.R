library(shiny)
library(caret)
library(DT)
library(tidyverse)

shinyServer(function(input, output) {

    #Read in data
    data_raw <- read.csv("baseball_data.csv")
  
    data_selected <- reactive({
      cols <- input$columns
      data_selected <- data_raw[,cols]
    })
    
    output$dataTable <- DT::renderDataTable({
      data_selected()
    })
    
    output$downloadData <- downloadHandler(
      filename = "baseball.csv",
      content = function(file) {
        write.csv(data_selected(), file, row.names = FALSE)
      }
    )
    
    output$baseballPic <- renderImage({
      list(src = "./baseball.jpg")
    })

})
