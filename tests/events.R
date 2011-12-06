
library(Combinations) 
source(system.file("examples", "combinationEx.R", package = "Combinations")) 
z = rnorm(25)
f = streamingHist(z)
o = combinations(length(z), 4, f)

f$counts
f$bins

