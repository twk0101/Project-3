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
    
    graph_plot <- reactive({
      plot_type <- input$graphType
      variable <- input$graphVariable
      
      if(plot_type == "Histogram"){
        ggplot(data_raw, aes_string(x=variable)) + geom_histogram(stat = "count", fill = "coral")
      }
      else if(plot_type == "Density Chart"){
        ggplot(data_raw, aes_string(x=variable)) + geom_density(kernel = "gaussian", fill = "blue")
      }
      else if(plot_type == "QQ Plot"){
        ggplot(data_raw) + geom_qq(aes_string(sample = variable))
      }
    })
    
    num_summary <- reactive({
      summary_type <- input$numType
      variable_num <- input$numVariable
      
      if(summary_type == "Frequency Table"){
        ft <- as.data.frame(table(cut(data_raw[[variable_num]], breaks = 10)))
        colnames(ft) <- c(variable_num, "Frequency")
        ft
      }
      else if(summary_type == "Summary Statistics"){
        stats <-as.data.frame(data_raw[[variable_num]])
        colnames(stats) <- variable_num
        summary(stats)
      }
      
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
    }, deleteFile = FALSE)
    
    output$graphSummary <- renderPlot({
      graph_plot()
    })
    
    output$numSummary <- renderPrint({
      num_summary()
    })

})
