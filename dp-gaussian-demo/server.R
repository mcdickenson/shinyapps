
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(MASS)
library(MCMCpack)

shinyServer(function(input, output){
  gmm_sampler = function(n, alpha, mu_0, lambda, S, v, legend=FALSE){
    # n: number of samples
    # alpha: scalar parameter for Dirichlet process
    # mu_0: p-length vector of hyperparams for mu
    # lambda: scalar for mu 
    # v: scalar for Inverse Wishart
    # S: pxp inverse scale matrix
    
    z = restaurant(alpha, n) # Dirichlet process table assignments
    K = length(unique(z))
    p = ncol(S)  
    
    # sample mu and Sigma from Normal-Inverse Wishart
    Sigma = array(NA, dim=c(p,p,K))
    mu = matrix(NA, nrow=K,ncol=p)
    for(k in 1:K){
      Sigma[,,k] = solve(rwish(v, solve(S)))
      mu[k,] = mvrnorm(1, mu_0, Sigma[,,k])
    }
    
    # sample each x from the Gaussian dist for its class 
    x = matrix(NA, nrow=n, ncol=p)
    for(i in 1:n){
      x[i,] = mvrnorm(1, mu[z[i],], Sigma[,,z[i]])
    }
    
    return(list(x=x, z=z))
  }
  
  
  restaurant = function(alpha, n){
    table_counts = c(1) # number of 'customers' at each 'table'
    # first customer at first table
    table_assignments = c(1, rep(NA, n-1))
    
    for(m in 2:n){
      tmp = c(table_counts, alpha)
      table_props = tmp/sum(tmp)
      
      table_m = sample(c(1:length(tmp)), 1, prob=table_props)
      if(table_m==length(tmp)){ table_counts[table_m] = 1}
      else{ table_counts[table_m] = table_counts[table_m] + 1}
      table_assignments[m] = table_m 
    }
    return(table_assignments) 
  }
  
  liststr=function(mylist){
    str = paste("(", mylist[1], sep="")
    for(i in mylist[2:length(mylist)]){
      str = paste(str, ", ", i, sep="")
    }
    str = paste(str, ")", sep="")
    return(str)
  }
  
  output$gaussPlot = renderPlot({
    n = 1000
    S = matrix(c(1,input$rho,input$rho,1), nrow=2, ncol=2)
    alpha = input$alpha
    v = input$v
    mu_0 = c(input$mu_x, input$mu_y)
    lambda = input$lambda
    data = gmm_sampler(n, alpha, mu_0, lambda, S, v, legend=TRUE)
    K = length(unique(data$z))
    print(unique(data$z))
    
    par(mfrow=c(2,1))
    plot(data$x[,1], data$x[,2], col=data$z,
      xlim=c(-10,10),
      ylim=c(-10, 10),
      xlab="X",
      ylab="Y",
      main=""
    )
    
    legend("topright", 
      legend=paste("Class ", seq(1:K), sep=""), 
      pch=16, 
      col=c(1:K)
    )
    
    if(K>1){
    
    hist(data$z,
         main="Class Assignments",
         xlab="",
         ylab="",
         col=c(1:K),
         right=FALSE
         )
    }
  }, height = 1000, width = 600 )
  # maybe switch to a ggplot scatterplot
})
