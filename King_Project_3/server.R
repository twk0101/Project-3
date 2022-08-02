library(shiny)
library(caret)
library(DT)
library(tidyverse)

shinyServer(function(input, output) {

    #Read in data
    data_raw <- read.csv("baseball_data.csv")
  
    #Use reactive context to subset the data based on selection
    data_selected <- reactive({
      cols <- input$columns
      data_selected <- data_raw[,cols]
    })
    
    #Generate graphical plot in a reactive context from user input
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
    
    #Generate the numerical summary in a reactive context from user input
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
    
    #This is the output on our final tab where the data can be viewed and exported
    output$dataTable <- DT::renderDataTable({
      data_selected()
    })
    
    #This snippet handles the downloadable aspect of the data
    output$downloadData <- downloadHandler(
      filename = "baseball.csv",
      content = function(file) {
        write.csv(data_selected(), file, row.names = FALSE)
      }
    )
    
    #Renders our high quality baseball image for the front page of the app (and doesn't delete it afterwards)
    output$baseballPic <- renderImage({
      list(src = "./baseball.jpg")
    }, deleteFile = FALSE)
    
    #Renders the graphical summary plot using the reactive context above
    output$graphSummary <- renderPlot({
      graph_plot()
    })
    
    #Renders the numerical summary using the reactive context above
    output$numSummary <- renderPrint({
      num_summary()
    })
    
    
    
    #Reactive context for splitting the training and testing data based on the user-inputted proportion
    train_test <-reactive({
      set.seed(1024)
      model_cols <- input$modelvars
      dataSubset <- data_raw[,model_cols]
      dataSubset$wOBA <- data_raw$wOBA
      
      train_index <- createDataPartition(dataSubset$wOBA, p = (1 - input$testP), list = FALSE)
      
      train <- dataSubset[train_index, ]
      test <- dataSubset[-train_index, ]
    })
    
    output$test_set <- renderPrint({
      train_test()
    })

})
