library(shiny)
library(shinydashboard)
library(shinythemes)
library(mathjaxr)

shinyUI(dashboardPage(skin = "purple",
  dashboardHeader(title = "StatCast Data"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about", icon = icon("globe")),
      menuItem("Data Exploration", tabName = "exploration", icon = icon("th")),
      menuItem("Modeling", tabName = "modeling", icon = icon("arrow-up-right-dots")),
      menuItem("Data", tabName = "data", icon = icon("dashboard"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "about",
                fluidPage(
                  h2("Hit the Ball Hard"),
                  br(),
                  p("While baseball is by no means a simple game, it should be noted that unlike in many other sports, the baseball    player's main objective can be described quite simply - hit the ball hard. Baseball is also unique in the fact that so many of its on-field events can be isolated which leads to increased opportunities for analysis. The game has undergone several iterations of adding complexity levels by way of new advanced statistics designed to take in data from the discrete events on the diamond and provide insight on overall player value. Baseball has become a game of matriculating simple data points into complex analysis. Perhaps the best example of this process is the one that revolves around the fundamental aim of the game - hit the ball hard. A few simple measurements, namely the exit velocity (EV) at which a batter hits the ball and the launch angle (LA) at which it flies off their bat, form the base of player evaluation metrics league-wide. Even in light of all of the sabermetrics and advanced modeling techniques now found in the game, exit velocity and launch angle are the bedrock of it all."),
                  p("In this application, we will provide the tools necessary to take a peek under the hood at some of the batted ball data over the past several seasons in the MLB and use the measurements as a predictor for weighted on base average (wOBA), which is an advanced metric used to quantify a hitter’s overall value. An important distinction here is that wOBA is calculated based on what outcomes a player amassed during the season (hitting home runs, walking, striking out, etc.) whereas the metrics we’ll be looking at as predictors like exit velocity and launch angle are considered more indicative of ability level amongst the players which (as most sports fans have no doubt learned painfully) doesn’t always translate to on-field success. We want to predict how well a player is going to do in terms of tangible success based on how hard and how high they hit the ball."),
                  HTML("<p>The data used in this app was pulled from FanGraphs, which is an amazing repository of all types of baseball information and has always been at the forefront of the game’s data-driven analytics. The data used in this app is StatCast (a batted ball tracking system) data from individual player seasons from 2015-2022 where a player accumulated at least 100 plate appearances. The specific dataset can be found <a href ='https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=100&type=24&season=2022&month=0&season1=2015&ind=1&team=0&rost=0&age=0&filter=&players=0&startdate=&enddate=', target = '_blank'>here</a> on FanGraph’s site and more general information about the resources they offer can be found at their homepage <a href ='https://www.fangraphs.com/', target = '_blank'>here</a>.</p>"),
                  p("Below is a brief overview of the functionality of all the other pages of the app:"),
                  tags$ul(tags$li("Data Exploration: This page allows the user to get a sense for what’s included in the dataset and generate some customized visualizations for the variables"),
                          tags$li("Modeling: This page has three tabs. The first tab describes the various model types that we’re going to be using to make predictions and their general methodology. The second tab goes over fitting the models and allows for user input on various parameters. The third and final tab covers predictions by the models and has functionality for making a prediction from an observation input by the user."),
                          tags$li("Data: This page allows for hands-on access to the dataset itself, the user can scroll through the data rows in a table, view a subset of the available columns and export the subset as a .csv.")),
                  imageOutput("baseballPic")
                )
              
              ),
      tabItem(tabName = "exploration",
                fluidPage(
                  titlePanel("Explore and Summarize the Data"),
                  sidebarLayout(
                    sidebarPanel(
                      h4("Variable Definitions:"),
                      tags$ul(
                        tags$li("EV (Exit Velocity) - the average velocity at which the baseball leaves a player's bat in mph"),
                        tags$li("maxEV (Maximum Exit Velocity) - the maximum exit velocity a player has generated in a season in mph"),
                        tags$li("LA (Launch Angle) - the average angle at which the baseball leaves a player's bat in degrees"),
                        tags$li("Barrel Percent - the percentage of batted balls on which a player generates what's called a 'barrel' which is considered to be an optimal batted ball event. Barrels are defined as batted-ball events whose comparable hit types have led to a minimum .500 batting average and 1.500 slugging percentage."),
                        tags$li("Hard Hit Percent - the percentage of batted balls on which a player generates an exit velocity of 95 mph or higher"),
                        tags$li("wOBA (Weighted on Base Average) - a composite measure of player success based on hit types and league averages.")
                      ),
                      selectInput("graphType", "Select a type of graphical summary to generate", choices = list("Histogram", "Density Chart", "QQ Plot")),
                      br(),
                      selectInput("graphVariable", "Select a variable to show in the graphical summary", choices = list("EV", "maxEV", "LA", "BarrelPercent", "HardHitPercent","wOBA")),
                      br(),
                      selectInput("numType", "Select a type of numerical summary to generate", choices = list("Frequency Table", "Summary Statistics")),
                      br(),
                      selectInput("numVariable", "Select a variable to show in the numerical summary", choices = list("EV", "maxEV", "LA", "BarrelPercent", "HardHitPercent","wOBA")),
                      br(),
                      submitButton("Generate Summaries")
                    ),
                    mainPanel(plotOutput("graphSummary"),
                              verbatimTextOutput("numSummary")
                      
                    )
                  )
                )
              ),
      tabItem(tabName = "modeling",
              tabsetPanel(
                tabPanel("Modeling Info",
                          fluidPage(
                            titlePanel("Model Information and Descriptions"),
                            br(),
                            h4("Multiple Linear Regression"),
                            br(),
                            p("Multiple linear regression is a modeling technique where a single variable is predicted using more than one factor. Multiple linear regression has several benefits, including being able to compare the relative influence of several factors as predictors and being able to tune the model very granularly. However, multiple linear regression also runs the risk of generating incomplete conclusions on large data sets and can make spotting interactions between variables difficult"),
                            p("Multiple linear regression equations follow the form below:"),
                            withMathJax('$$\\hat{Y}=b_{0}+b_{1}X_{1}+b_{2}X_{2}+...+b_{n}X_{n}$$'),
                            br(),
                            h4("Regression Tree"),
                            br(),
                            p("A regression tree is a tree model that is built through a series of recursive partitions on the different factors that continually divide the data and eventually return a single numerical prediction (as opposed to a classification in decision trees.) Regression trees are good at handeling interactions between factors because they handle their splits independently but they're also sensitive to outliers in the data."),
                            br(),
                            h4("Random Forest"),
                            br(),
                            p("Random forest is an ensamble modeling technique that involves training many smaller decision trees on the data and then taking a consensus amongst the individual trees to arrive at an overall conclusion. This method irons out some of the difficulties with single decision trees by (hopefully) ensuring that even if a few trees make mistakes the overall consensus of the model is still correct. However, since they are an ensamble method, random forest models are more computationally expensive than the other two types.")
                          )
                        ),
                tabPanel("Model Fitting",
                          fluidPage(
                            titlePanel("Customize Parameters for Model Fitting"),
                            sidebarLayout(
                              sidebarPanel(
                                h4("Note - models have already been run with default parameters, enter values to re-run"),
                                numericInput("testP", "Select the proportion of the data to be used for the test set", value = .2, min = .05, max = .95, step = .05),
                                selectInput("modelvars","Select variables to use in the models", choices=list("EV", "maxEV", "LA", "BarrelPercent", "HardHitPercent"), multiple = TRUE, selected = list("EV", "LA")),
                                numericInput("cv", "Select the number of folds used in cross validation", value = 5, min = 2, max = 10, step = 1),
                                selectInput("prepros", "Select pre-processing options", choices = list("center", "scale"), multiple = TRUE, selected = list("center", "scale")),
                                submitButton("Re-Run Models")
                              ),
                              mainPanel(
                                verbatimTextOutput("MLR_model"),
                                verbatimTextOutput("tree_model"),
                                verbatimTextOutput("forest_model"),
                                br(),
                                h4("Performance on test set: "),
                                br(),
                                strong("MLR"),
                                verbatimTextOutput("performance_mlr"),
                                br(),
                                strong("Regression Tree"),
                                verbatimTextOutput("performance_tree"),
                                br(),
                                strong("Random Forest"),
                                verbatimTextOutput("performance_forest")
                                
                              )
                            )
                          )
                         
                         
                        ),
                tabPanel("Prediction","content")
              )
              ),
      tabItem(tabName = "data",
                fluidPage(
                  titlePanel("View the Data Set"),
                  sidebarLayout(
                    sidebarPanel(
                      selectInput("columns","Select Columns to View", choices=list("Season", "Name", "EV", "maxEV", "LA", "BarrelPercent", "HardHitPercent","wOBA"), multiple = TRUE, selected = list("Season", "Name")),
                      submitButton("Generate Table"),
                      br(),
                      p("Download a .csv with the columns you've selected:"),
                      downloadButton("downloadData", "Download")
                    ),
                    mainPanel(
                      dataTableOutput("dataTable")
                    )
                  )
                  
                
                )
              )
      )
      
      
    )
    
    
    
  )
)
