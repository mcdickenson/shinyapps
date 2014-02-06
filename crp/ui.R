library(shiny)

shinyUI(pageWithSidebar(

  headerPanel("Bivariate Gaussian"),

  sidebarPanel(
     sliderInput("alpha",
        "Alpha:",
        value=1,
        min=1,
        max=10
      )
    ),

  mainPanel(
    plotOutput("ibpPlot")
  )
))