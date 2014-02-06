library(shiny)
library(MASS)

shinyServer(function(input, output){
  output$gaussPlot = renderPlot({
    # x = rnorm(1000, mean=input$mu_x, sd=input$sigma_x)
    # y = rnorm(1000, mean=input$mu_y, sd=input$sigma_y)
    data = mvrnorm(n=1000,
      mu=c(input$mu_x, input$mu_y),
      Sigma=matrix(c(input$sigma_x, input$rho, input$rho, input$sigma_y), nrow=2, ncol=2)
    )
    plot(data[,1], data[,2],
      xlab="X",
      ylab="Y",
      xlim=c(-10, 10),
      ylim=c(-10, 10)
    )
  })
})