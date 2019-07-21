
## An R implementation of The Hungarian Method 
## input:  a square cost matrix of "jobs" and "tasks"
## output: place of minimum match (a 0-1 matrix)

## Although this is basically the classical 1953 algorithm, we 
## use use vector operations in R where possible

hungar <- function(cost){  
  # debug= FALSE
  co <- cost
  N <- nrow(co)

  ## Subtract row and column minima
  for (i in 1:N) co[i,] <- co[i,] - min(co[i,])
  for (i in 1:N) co[, i] <- co[, i] - min(co[, i])

  ## Find the (first) minimal vertex cover
  adj.matrix <-  ifelse(co==0, 1, 0) 
  result<- min_vertex_cover(adj.matrix, N)

  while(result$size < N){
    # if not yet ready, get min of the uncovered part
    # and adjust row and colmns weightsof the cover
    y<- result$y
    x<- result$x
    smallest <- min(co[!y, !x])
    co[!y, ] <- co[!y, ] - smallest
    co[,x] <- co[,x] + smallest
    # then try again
    adj.matrix <-  ifelse(co==0, 1, 0) 
    result<- min_vertex_cover(adj.matrix, N)
  }
  stars <- matrix(0, N, N)
  for(i in 1:N) stars[i, result$matchR[i]] <- 1
  return(stars)
}

# two aux routines on bipartite graphs

# (1) Finding a maximum size edge cover in a bipartite graph
# input: an adj. matrix (N*N)
# out:   a maximum edge cover (AKA max match)
#
# Well known is that this can be solved 
# using the Ford and Fulkerson max flow algorithm. 
# But here we have few edges so a recursive depth first is fast too
#
# Extra warning is that R does not fully support the use of 
# global variables (no pointers), so here we use the
# <<- operand that alters values in the parent environment. 

max_bpm <- function (adj.matrix, N){
  
  # recursive helper function for the bipartite max matching problem
  rec_bpm<- function(u){
    # globals matchR, matchC, seen
    # assume the matrix is square
    for (v in 1:N){ # try every row for column u
      if (adj.matrix[v, u] == 0  || seen[v]) next
      seen[v] <<- TRUE
      if (matchR[v] == 0 || rec_bpm(matchR[v])) { 
        matchR[v] <<- u 
        matchC[u] <<- v
        return(TRUE) 
      } 
    }
    return(FALSE)
  }
  
  # columnwise search for the bipartite max matching problem
  matchR <- rep(0, N);  matchC <- rep(0, N)
  result <- 0
  done <- FALSE
  while(!done){
    done <- TRUE
    seen<- rep(FALSE, N)
    for(i in 1:N){
      if(matchC[i]== 0 && rec_bpm(i)) {
        done = FALSE
      }
    }
    result= sum(matchC != 0)
  }
  return(list(size= result, matchC=matchC, matchR=matchR))
}

# (2) Find a minimum size vertex set that covers all edges
# in:  an adjacency matrix (N * M)
# out: the x and y for the minimal cover
#
# This is a dual to the above task, says Königs theorem
# 
# So first we apply (1) and then make alternating 
# trees from unmatched vertices and toggle the inclusion status of
# the vertices in the same level of the tree

min_vertex_cover <- function(adj.matrix, N){
  mm <- max_bpm(adj.matrix, N )
  if (mm$size ==N) {
    mm$x= rep(TRUE, N)
    mm$y= rep(FALSE, N)
    return(mm)
    }
  
  x<- rep(0, N); y <- rep(0, N) ## -1 excl 0 not yet seen 1 include
  S<- which(mm$matchC ==0 & x==0)
  while (length(S) > 0 ){
    x[S] <- -1
    T<- c()
    for(s in S){
      T <- c(T, which(adj.matrix[,s] == 1))
    }
    T<- unique(T)
    y[T] <- +1
    # next level are the "mates"
    S <- mm$matchR[T]
    S <- S[x[S] == 0]
  }
  
  T <- which(mm$matchR ==0 & y==0)
  while (length(T) > 0){
    y[T] <- -1
    S<- c()
    for(t in T){
      S <- c(S, which(adj.matrix[t,] == 1))
    }
    S<- unique(S)
    x[S] <- 1
    T<- mm$matchC[S]
    T<- T[y[T] == 0]
  }
  x <- ifelse(x >=0, TRUE, FALSE) ## there might be some dont cares left
  y <- ifelse(y==1, TRUE, FALSE)
  return(list(x=x, y=y, matchR= mm$matchR, size= sum(x) +sum(y)))
}

  