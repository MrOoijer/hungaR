# do_match
# in: N rows, M columns cost matrix
#     vector of size M with max # of students per advisor
# out: N rows, 3 columns matching matrix with values
#
# to do: add 4th column with diagnostics
#

id__ <- function(x) {x}

do_match <- function(cost, max_adv
                     , from_elsewhere= FALSE
                     , penalty = -100
                     , weight_fun = id__
                     , squeeze_power= 1){
  N<- nrow(cost)
  M<- ncol(cost)
  sqr.matrix<- matrix(rep(cost[,1], max_adv[1]), nrow=N)
  
  for (i in 2:M) sqr.matrix<- cbind(
    sqr.matrix, 
    matrix(rep(cost[,i], max_adv[i]), nrow=N)
  )
  
  # make some penalized overflow columns
  overflow <- max(3, floor(1+(N - sum(max_adv))/M))
  for (i in 1:overflow)
    sqr.matrix <- cbind(sqr.matrix, cost +i*penalty)
  
  # add dummy students to compensate
  to_do <- ncol(sqr.matrix) - nrow(sqr.matrix)   # should be >0
  values <- rep(0, ncol(sqr.matrix))
  for(i in 1:to_do) sqr.matrix<- rbind(sqr.matrix, x=values)
  
  #transform matrix
  sq <- (sign(sqr.matrix > 0) * weight_fun(abs(sqr.matrix)^(1/squeeze_power))) +
    + (sign(sqr.matrix < 0) * sqr.matrix)

  # so now its square and do the match
  if(from_elsewhere && require(geogrid))
    result <- geogrid:::hungariansafe_cc(-sq) else
      result<- hungar(-sq)
  
  # which advisor belongs to which column
  which_adviser<- c(
    unlist( sapply(1:M, function(i)
      rep(i, max_adv[i]))),
    rep(1:M, overflow))
  
  # make end result table
  match <- unlist(sapply(1:N, function(i)
    return(which_adviser[which(result[i,] >0)])))
  
  values <- unlist(sapply(1:N, function(i)
    return(sqr.matrix[i, which(result[i,] >0)])))
  
  final.result<- data.frame(
    nr= 1:N, 
    adviser= match,
    value= values
  )
  
  final.result
  
  
}