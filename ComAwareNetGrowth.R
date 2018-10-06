# F. Gursoy and B. Badur, A Community-aware Network Growth Model for Synthetic Social Network Generation, 5th Int'l Management Information Systems Conference. 2018

# Note that, the reported probabilities in the paper are actual probabilities (i.e., summing up to 1). 
# This piece of software can work with relative chances since R automatically normalizes them to actual probabilities.
# The relative chances which are present in the input_(...).txt files in this repository correspond to the actual probabilities reported in the paper.

# Please refer to README file at https://github.com/furkangursoy/ComAwareNetGrowth
# For any issues you might still have, feel free to contact me at furkan.gursoy@boun.edu.tr or gursoyfurkan@gmail.com

# Feel free to use it with appropriate references to the original paper.

# Website: http://furkangursoy.github.io

###############

#install.packages("igraph")  #if not already installed, run this command
library(igraph)

addNode <- function()
{
  clusterId <- sample(1:numberOfClusters, size = 1, prob = clusterProb) #randomly select a cluster (i.e., community)
  return(G + vertex(vcount(G) + 1, cl = clusterId)) #add a new node with cluster
}

addLink <- function(i, j)
{
  return(G + edge(toString(i),toString(j)))
}

randomLink <- function(i){
  x <- i
  y <- sample(1:vcount(G), 1)
  if(are.connected(G, x, y) || x==y)
  {
    return(G)
  }
  else
  {
    return(addLink(x,y))
  }
}

randomLinkCl <- function(i){
  x <- i
  cG <- induced_subgraph(G, V(G)$cl == V(G)[i]$cl)
  y <- V(cG)[sample(V(cG), 1)]$name
  if(are.connected(cG, toString(x), toString(y)) || x==y)
  {
    return(G)
  }
  else
  {
    return(addLink(x,y))
  }
}

prefAttach <- function(i){
  x <- i
  y <- sample(1:vcount(G), size = 1, prob= degree(G)+1)
  if(are.connected(G, x, y) || x==y)
  {
    return(G)
  }
  else
  {
    return(addLink(x,y))
  }
}

prefAttachCl <- function(i){
  x <- i
  cG <- induced_subgraph(G, V(G)$cl == V(G)[i]$cl)
  y <- V(cG)[sample(V(cG), size = 1, prob=degree(cG)+1)]$name
  if(are.connected(cG, toString(x), toString(y)) || x==y)
  {
    return(G)
  }
  else
  {
    return(addLink(x,y))
  }
}

close <- function(i, ord){
  x <- i
  y <- sample(ego(G, order=ord, nodes=i)[[1]], 1)
  if(are.connected(G, x, y) || x==y)
  {
    return(G)
  }
  else
  {
    return(addLink(x,y))
  }
}

closeCl <- function(i, ord){ #ord is the order (e.g., third-order neighbor)
  x <- i
  cG <- induced_subgraph(G, V(G)$cl == V(G)[i]$cl)
  y <- V(cG)[sample(ego(cG, order=ord, nodes=toString(x))[[1]], 1)]$name
  if(are.connected(cG, toString(x), toString(y)) || x==y)
  {
    return(G)
  }
  else
  {
    return(addLink(x,y))
  }
}

nOfTests <- 10
input <- read.table("input.txt", header=TRUE, sep = "\t")
output <- data.frame(matrix(ncol = 7, nrow = nOfTests))
colnames(output) <- c("n","m","cc","pl", "mod", "diam", "alpha")

for(testno in 1:nOfTests){
  
  n <- input$n[testno]
  m <- input$m[testno]
  numberOfClusters <- input$numberOfClusters[testno]
  clusterProb <- input$clusterProb[testno]
  clusterProb <- as.numeric(unlist(strsplit(toString(clusterProb), split=",")))
  rp <- input$rp[testno]
  pp <- input$pp[testno]
  c3p <- input$c3p[testno]
  c4p <- input$c4p[testno]
  comp <- input$comp[testno]
  
  
  pr <- c((1-comp)*c(rp, pp, c3p, c4p), comp*c(rp, pp, c3p, c4p)) #relative chances for 8 link forming methods
  freq <- 0 #round counter
  mdn <- as.integer(m/n) #new node arrival period
  G <- make_empty_graph(directed=FALSE)
  
  while(ecount(G) < m){
    freq <- freq + 1
    i <- NA
    p <- NA
    
    if(freq%%mdn == 1 && vcount(G) < n) #if a new node should be arriving
    {
      G <- addNode()
      i <- toString(vcount(G))
      p <- sample(4,1, prob = pr[1:4]) #a new node cannot close a triangle or quadrangle since it has no link. thus, 4 probabilities
    }
    else{
      i <- toString(sample(V(G), size = 1))
      p <- sample(8,1, prob = pr) #an existing node might be suitable for all of the 8 methods
    }
    
    switch(p,
           G <- randomLink(i),
           G <- randomLinkCl(i),
           G <- prefAttach(i),
           G <- prefAttachCl(i),
           G <- close(i, 2),
           G <- closeCl(i, 2),
           G <- close(i, 3),
           G <- closeCl(i, 3)
    )
  }
  
  output$n [testno]<- vcount(G)
  output$m[testno] <- ecount(G)
  output$cc[testno] <- transitivity(G)
  output$pl[testno] <- average.path.length(G)
  output$mod [testno]<- modularity(G, V(G)$cl)
  output$diam [testno]<- diameter(G)
  fit1 <- fit_power_law(degree(G), xmin = 5, force.continuous = TRUE) #you can change xmin for different applications
  output$alpha[testno] <- fit1$alpha
}

write.table(output, file="output.txt")
