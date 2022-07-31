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
                  p("While baseball is by no means a simple game, it should be noted that unlike in many
                    other sports, the baseball player's main objective can be described quite simply - hit the ball hard.
                    Baseball is also unique in the fact that so many of its on-field events can be isolated which leads to 
                    increased opporunities for (sometimes over-) analyization. ")
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
