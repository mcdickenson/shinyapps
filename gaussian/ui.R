library(shiny)

shinyUI(pageWithSidebar(

  headerPanel("Bivariate Gaussian"),

  sidebarPanel(
     sliderInput("rho",
        "Correlation(X,Y):",
        value=0,
        min=-1,
        max=1,
        step=0.1
      ),
      sliderInput("mu_x",
        "Mean(X):",
        value=0,
        min=-5,
        max=5   
      ),
      sliderInput("sigma_x",
        "StdDev(X):",
        value=1,
        min=1,
        max=5   
      ),
      sliderInput("mu_y",
        "Mean(Y):",
        value=0,
        min=-5,
        max=5   
      ),
      sliderInput("sigma_y",
        "StdDev(Y):",
        value=1,
        min=1,
        max=5   
      )
    ),

  mainPanel(
    plotOutput("gaussPlot")
  )
))