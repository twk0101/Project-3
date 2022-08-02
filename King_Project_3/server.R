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
      
      list(train = train, test = test)
    })
    
    #Reactive context for training the mlr model
    train_mlr <- reactive({
      MLR <- train(wOBA~., data = train_test()$train,
                   method = "lm",
                   preProcess = input$prepros,
                   trControl = trainControl(method = "cv", number = input$cv))
      MLR
    })
    
    #Reactive context for training the regression tree model
    train_tree <- reactive({
      tree <- train(wOBA~., data = train_test()$train,
                    method = "rpart",
                    preProcess = input$prepros,
                    trControl = trainControl(method = "cv", number = input$cv))
      tree
    })
    
    #Reactive context for training the random forest model
    train_forest <- reactive({
      forest <- train(wOBA~., data = train_test()$train,
                      method = "rf",
                      preProcess = input$prepros,
                      trControl = trainControl(method = "cv", number = input$cv))
      forest
    })
    
    #Output the model printouts with stats on training data
    output$MLR_model <- renderPrint({
      train_mlr()
    })
    
    output$tree_model <- renderPrint({
      train_tree()
    })
    
    output$forest_model <- renderPrint({
      train_forest()
    })

    #Reactive context for computing performance on test data
    test_perf <- reactive({
      pred_mlr <- predict(train_mlr(), newdata = train_test()$test)
      pred_tree <-  predict(train_tree(), newdata = train_test()$test)
      pred_forest <-  predict(train_forest(), newdata = train_test()$test)
      
      perf_mlr <- postResample(pred_mlr, obs = train_test()$test$wOBA)
      perf_tree <- postResample(pred_tree, obs = train_test()$test$wOBA)
      perf_forest <- postResample(pred_forest, obs = train_test()$test$wOBA)
      
      list(MLR = perf_mlr, Tree = perf_tree, Forest = perf_forest)
    })
    
    output$performance_mlr <- renderPrint({
      test_perf()$MLR
    })
    
    output$performance_tree <- renderPrint({
      test_perf()$Tree
    })
    
    output$performance_forest <- renderPrint({
      test_perf()$MForest
    })
    
})
