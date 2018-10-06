# ComAwareNetGrowth
This repository contains the source code and datasets employed in the following study.

F. Gursoy and B. Badur, A Community-aware Network Growth Model for Synthetic Social Network Generation, 5th Int'l Management Information Systems Conference. 2018

#### File descriptions
*ComAwareNetGrowth.R*: the code file  
*karate.txt*: karate network (appropriate references are given in the paper)  
*caltech.txt*: caltech network (appropriate references are given in the paper)  
*input_orig.txt*: input parameters for our different scenario experiments  
*input_karate.txt*: input parameters for mimicking karate network  
*input_caltech.txt*: input parameters for mimicking caltech network  
*output_(..).txt*: output files corresponding to the input files

#### Input attributes
*n*: number of nodes  
*m*: number of links  
*numberOfClusters*: number of clusters (i.e., communities)  
*clusterProb*: probabilities of belonging to each cluster  
*rp*: a probability for making a random link  
*pp*: a probability for making a link based on preferential attachment  
*c3p*: a probability for making a link that closes a triangle  
*c4p*: a probability for making a link that closes a quadrangle  
*comp*: a probability for making the link within community  

Note that, the probabilities described above are not actual probabilities but relative chances (automatically normalized by the R application when necessary). However, in the published paper, actual probabilities (i.e., those summing up to 1) are reported. Moreover, please briefly study the code to see how *comp* is multiplied with other four parameters to result in total of 8 probabilities for 8 link-making methods.

#### Output attributes
*n*: number of nodes  
*m*: number of links 
*cc*: clustering coefficient  
*pl*: average path length  
*mod*: modularity  
*diam*: diameter  
*alpha*: power law exponent


### Before you run the code
* Check & modify the names of input and output files.  
* Set *nOfTests* to the number of test cases you have in your input file (or number of them you want to experiment with).
* Set the *xmin* parameter for *fit_power_law()* function to a desired value.

For any issues you might have, feel free to contact me at furkan.gursoy@boun.edu.tr or gursoyfurkan@gmail.com

For synthetic networks generated using this algorithm, please visit http://furkangursoy.github.io/datasets.

Feel free to use the generated networks or the source code, with appropriate references to the original paper.
