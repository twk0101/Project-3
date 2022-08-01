library(shiny)
library(shinydashboard)
library(shinythemes)
library(mathjaxr)

shinyUI(dashboardPage(skin = "purple",
  dashboardHeader(title = "Baseball Stuff"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("About", tabName = "about", icon = icon("globe")),
      menuItem("Data Exploration", tabName = "exploration", icon = icon("th")),
      menuItem("Modeling", tabName = "modeling", icon = icon("dashboard")),
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
                          tags$li("Data: This page allows for hands-on access to the dataset itself, the user can scroll through the data rows in a table, view a subset of the available columns and export the subset as a .csv."))
                )
              
              ),
      tabItem(tabName = "exploration"),
      tabItem(tabName = "modeling",
              tabsetPanel(
                tabPanel("Modeling Info",
                          fluidPage(
                            titlePanel("Model Information and Descriptions"),
                            br(),
                            h4("Multiple Linear Regression"),
                            br(),
                            p("Multiple linear regression is a modeling technique where "),
                            br(),
                            h4("Regression Tree"),
                            br(),
                            p("A regression tree is a tree that does "),
                            br(),
                            h4("Random Forest"),
                            br(),
                            p("Random forest is an ensamble modeling technique that "),
                            withMathJax(sprintf('$$3^2+4^2=5^2$$')),
                           
                          )
                        ),
                tabPanel("Model Fitting", "content"),
                tabPanel("Prediction","content")
              )
              ),
      tabItem(tabName = "data",
                fluidPage(
                  titlePanel("Explore the Data Set"),
                  sidebarLayout(
                    sidebarPanel(
                      selectInput("columns","Select Columns to View", choices=list("Season", "Name", "EV", "maxEV", "LA", "BarrelPercent", "HardHitPercent","wOBA"),
                                   multiple = TRUE, selected = list("Season", "Name")),
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
