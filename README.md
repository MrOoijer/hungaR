# hungaR

Match N students to M advisers to supervise writing their (bachelors) thesis. 

This is asimple three step precoess.

(1) Read in the data about students, advisers, preference and non-prefered combinations. The software will expect the data in csv files.

(2) Prepare the data in a matrix with weights. Weights can be changed via a parameter file. 

(3) From the matrix of weights we calculate the matching with the highest sum of weights. The result is exported into a csv file. If you do not like the end results, the weights in the parameter file need to be adjusted. The the process in step 2 can be repeated.

The algorithm used is a pure R implementation of the Hungarian method for the
minimum cost optimal mathcing problem. The method is deterministic, so you will always get the same solution with the same data and weights. 

The runtime is 10-25 seconds on 1000 students. 
