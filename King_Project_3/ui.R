library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
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
      tabItem(tabName = "about"),
      tabItem(tabName = "exploration"),
      tabItem(tabName = "modeling",
              tabsetPanel(
                tabPanel("Modeling Info","content"),
                tabPanel("Model Fitting", "content"),
                tabPanel("Prediction","content")
              )
              ),
      tabItem(tabName = "data")
      )
      
      
    )
    
    
    
  )
)
