library(ggplot2)

set.seed(123)
ibp = function(alpha, N){
  assignments = matrix(NA, nrow=N, ncol=N*alpha) # upper bound on expected number of columns

  dishes = rpois(1, alpha)
  zeroes = ncol(assignments) - dishes

  assignments[1,] = c(rep(1, dishes), rep(0, zeroes))

  for(i in 2:N){
    last_previously_sampled_dish = max(which(assignments==1, arr.ind=T)[, 'col'])

    dishes_from_previously_sampled = matrix(NA, nrow=1, ncol=last_previously_sampled_dish)
    for(k in 1:last_previously_sampled_dish){
      m_k = sum(assignments[1:i-1,k])
      prob = m_k / i
      dishes_from_previously_sampled[1,k] = rbinom(1,1, prob)
    }

    new_dishes = rpois(1, alpha/i)
    zeroes = ncol(assignments) - (last_previously_sampled_dish + new_dishes)
    assignments[i,] = c(dishes_from_previously_sampled, rep(1,new_dishes), rep(0, zeroes))
  }

  last_sampled_dish = max(which(assignments==1, arr.ind=T)[, 'col'])
  assignments = assignments[1:N, 1:last_sampled_dish]

  return(assignments)
}

x = ibp(10, 20)
dim(x)
sum(x)


[r, c] = size(x)

plot(x)

binary = as.data.frame(as.table(t(x[N:1,]) ))

plot = ggplot(binary)
plot + geom_tile(aes(x=Var1, y=Var2, fill=Freq)) + 
  scale_x_discrete(name="Dishes", labels=c(1:ncol(x))) + 
  scale_y_discrete(name="Customers", labels=c(nrow(x):1)) + 
