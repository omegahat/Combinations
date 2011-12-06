breaks = 
function(data, range = 3, n = 10,  by  = sigma/(n))
{
  mu = mean(data)
  sigma = range * sd(data)/sqrt(length(data))
  seq(mu - sigma, mu + sigma, by = by)
}

streamingHist = 
function(data, bins = breaks(data))
{
  counts <- integer(length(bins))

  new("CombinationGeneratorCallback",  
        function(x) {
	     m = mean(data[as.logical(x)])
	     i = which.max(m < bins)
	     counts[i] <<- counts[i] + 1
	     NULL  
	  })
}
