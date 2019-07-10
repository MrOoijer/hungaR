# hungaR

Match N students to M advisers to supervise writing their (bachelors) thesis. This is subject to restictions and preferences. 

This is a simple four step process.

(1) Fill in an matrix with N rows and M columns, with each cell having a positive number (prefered combination), a 0 (don't care), or a negative value for unwanted or impossible combinations.

This process can be automated, but it depends on how the base data will be supplied. 

(2) Once this matrix is ready, the rest can be automated. In the second step the columns will be duplicated as many times as the maximum number of students is willing to supervise. Some extra columns with negativ values will be added to ensure the existence of a solution, and some dummy students might be added to make the matrix square.

(3) This maximum weight matching problem is turned around into a minimum weight matching problem for the Hungarian algorithm. A solution is alwauys found, what is more, the algorithm is deterministic: it will always give the same solution even though many more might exist.

(4) The found matching is saved in a tabular form. The only way to get another matching is to change some f the weights in setp 1 or 2. 


NOTE on the algorithm
----------------------


The algorithm used here is a pure R implementation of the Hungarian method for the minimum cost optimal mathcing problem. 

The runtime is 10-25 seconds on 1000 students. The run time is cubic, so 200 students can be handled in less than a second, but 2500 students would take 5-10 minutes. 

We found one version of this algorithm in an R library (geogrid), and even though that is written on C++, our version is 3-5 times faster on the larger data sets. This discrepancy is probably explained by the fact that our weights are assumed to be integers, not floats. 
