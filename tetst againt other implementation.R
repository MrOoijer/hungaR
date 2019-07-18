## test suite for my hubgaR vs geogrid
## ----- compare -----
if(! require(geogrid)) {
  print("requires library geogrid")
} else {
  source("my_hungarian.R")
  nr_times=50
  
  result<- matrix(0, nr_times, 3)
  ot<- system.time({
    for (i in 1:nr_times){
      N<- 400 # sample(450:550, 1)
      sqr.matrix<- matrix(sample((-N):N, N*N, replace=TRUE), N, N)
      
      a<- system.time(
        {
          
          aresult <- geogrid:::hungariansafe_cc(-sqr.matrix)}
      )
      b<- system.time(
        { 
          bresult<- my_hungarian(-sqr.matrix)
        })
      
      if(sum(aresult*sqr.matrix)-sum(bresult*sqr.matrix) != 0) {
        print("answer mismatch")
        stop
      }
      result[i, ] <- c(a[3] - b[3], a[3], b[3])
    }
    
    print(mean(result[,1]))
  })
  
  print(ot/(2*nr_times))
  ve <- max(c(result[,2], result[,3]))+0.1
  myLib::pretty_density(result[,3], lwd=2)
  myLib::pretty_density(result[,2], add=TRUE, kleur= 2, lw=2)
  
  myLib::pretty_density(result[,1], lwd=2)
}

## ----- speed curve -----
##    NB takes about 10 minutes to run

nr_times=2
endN = 1000
maxN= 10
Nrange= endN*(1: maxN)/maxN
source("my_hungarian.R")


if(! require(geogrid)) {
  print("requires library geogrid")
} else {
  so<- system.time({
    result<- matrix(0, nr_times, maxN)
    resultb<- matrix(0, nr_times, maxN)
    for(n in 1:maxN){
      N=Nrange[n]
      for(i in 1:nr_times){
        # sqr.matrix<- matrix(sample(c(0:5, -100,-1000), N*N, replace=TRUE), N, N)
        sqr.matrix<- matrix(sample((-N):N, N*N, replace=TRUE), N, N)
        a<- system.time(
          { aresult <- geogrid:::hungariansafe_cc(-sqr.matrix)}
        )
        result[i, n] <- a[3]
        a<- system.time(
          { bresult <- my_hungarian(-sqr.matrix)}
        )
        resultb[i, n] <- a[3]
        if(sum(aresult*sqr.matrix)-sum(bresult*sqr.matrix) != 0) {
          print("answer mismatch")
          stop
        }
        
      }
    }
  })
  print(so)
  myLib::pretty_plot(type="l", data.frame(Nrange, colMeans(result)), 
                     main="Geogrid - /MY hungarian \nrunning time", xlab= "N", 
                     ylab= "sec" , lwd=2, xlim=c(-50, endN+50), 
                     ylim=c(0, max(result)+5))
  myLib::pretty_plot(type="l", data.frame(Nrange, colMeans(resultb)), 
                     lwd=2, kleur=2, add=TRUE)
  for(i in 1:nr_times){
    myLib::pretty_plot(type="p", data.frame(Nrange, result[i, ]), 
                       cex=0.6, kleur=1, add=TRUE)
    myLib::pretty_plot(type="p", data.frame(Nrange, resultb[i, ]), 
                       cex=0.6, kleur=2, add=TRUE)
  }
  myLib::pretty_legend(lwd=4, kleur=1:2, c("Geogrid", "Mine"))
  
}

# ------ only mine

nr_times=7
endN = 3000
maxN= 8
Nrange= endN*(1: maxN)/maxN
source("my_hungarian.R")


if(FALSE) {
  print("requires library geogrid")
} else {
  so<- system.time({
    resultb<- matrix(0, nr_times, maxN)
    for(n in 1:maxN){
      N=Nrange[n]
      for(i in 1:nr_times){
        # sqr.matrix<- matrix(sample(c(1:5, rep(0, 5), -100,-1000), N*N, replace=TRUE), N, N)
        sqr.matrix<- matrix(sample((-N):N, N*N, replace=TRUE), N, N)
        a<- system.time(
          { bresult <- my_hungarian(-sqr.matrix)}
        )
        resultb[i, n] <- a[3]
      }
    }
  })
  print(so)
  myLib::pretty_plot(type="l", data.frame(Nrange, colMeans(resultb)), 
                     main="MY_hungarian \nrunning time", xlab= "N", 
                     ylab= "sec" , lwd=2, xlim=c(-50, endN+50), 
                     ylim=c(0,  1.1*max(resultb)))
  for(i in 1:nr_times){
    myLib::pretty_plot(type="p", data.frame(Nrange, resultb[i, ]), 
                       cex=0.7, kleur=2, add=TRUE)
  }
  
}
