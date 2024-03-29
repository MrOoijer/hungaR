# hungaR

Match N students to M advisers to supervise writing their (bachelors) thesis. This is subject to restictions and preferences.
This problem is translated into a maximization problem where the sum of the values of the matches is maximized. 

It is assumed that the data entry is in a spreadsheet and is exported into csv-files. Those files will be loaded and processed.

Basic Example
-------------

A working example is in the file *basic_example.Rmd*. The matching is done within the function *do_match.R* that needs the N*M weights matrix that we want to maximize, plus a vector with the maximum number of students each adviser wants to have. 

That function transforms it into a square matrix that is given to the hungarian algorithm function called *hungar.R*. 

Advanced Example
----------------

In the *advanced_example.Rmd* we prepare the weights matrix for a more real life situation with more than one topic per advisor and with language preferences for advisors ans students. The data preparation is a bit more elaborated but in the end we can use the same algotihm. 

NOTE on the algorithm
----------------------

The algorithm is a pure R implementation of the classical Hungarian method for the minimum cost optimal mathcing problem (Kuhn- Munkres 1957), with additional speed-ups from Edmonds and Karp ([1]). 

We found one version of this algorithm in an R library (geogrid), and even though that is written on C++, our version is 3-5 times faster on larger data sets. See the file *speedtest.pdf* for some examples of benchmarks. 

[1] https://en.wikipedia.org/wiki/Hungarian_algorithm
