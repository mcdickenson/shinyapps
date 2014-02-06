library(shiny)
library(ggplot2)

shinyUI(pageWithSidebar(

  headerPanel("Indian Buffet Process"),

  sidebarPanel(
     sliderInput("alpha",
        "Average number of dishes (alpha):",
        value=10,
        min=1,
        max=20,
        step=1
      ),

     numericInput("n", "Number of customers (N):", 10),

     submitButton("Update")
    ),

  mainPanel(
    plotOutput("ibpPlot")
  )
))