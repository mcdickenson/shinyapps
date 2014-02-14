
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Dirichlet Process Mixture of Gaussians"),
  
  sidebarPanel(
    sliderInput("alpha",
                "Alpha",
                value=1,
                min=0,
                max=1,
                step=0.2
    ),
    sliderInput("rho",
                "Correlation(X,Y)",
                value=0,
                min=-0.8,
                max=0.8,
                step=0.2
    ),
    sliderInput("mu_x",
                "Mean(X)",
                value=0,
                min=-5,
                max=5   
    ),
    sliderInput("mu_y",
                "Mean(Y)",
                value=0,
                min=-5,
                max=5   
    ),
    sliderInput("v",
                "Inverse Variance",
                value=5,
                min=2,
                max=10
    ),
    sliderInput("lambda",
                "Lambda",
                value=1,
                min=1,
                max=5   
    )
  ),
  
  mainPanel(
    plotOutput("gaussPlot", height="100%")
  )
))
