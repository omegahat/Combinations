\name{combinations}
\alias{combinations}
\title{Combinations of r items from n}
\description{
 This generates all the combinations of k items from n.
 For \dQuote{small} values of n, the result can be returned as a matrix.
 As n and k increase and the number of elements in the resulting
 matrix exceeds \code{2^31/4}, then we can no longer return the results.
 One can use this interface to call a function for each combination
 and can store the result of using the combination appropriately.
 When/if the limit on the size of R's vectors/matrices is lifted, this
 code will work with only minimal typedef changes. 
}
\usage{
combinations(n, r, fun = NULL)
}
\arguments{
  \item{n}{the number of items to choose from}
  \item{r}{the number of items to choose}
  \item{fun}{if specified, a function that is called for each combination generated. This is called with one
   argument which is a logical vector of length \code{n}, and whose elements indicate whether the
   corresponding element of the set is in this particular combination.}
}
\details{
  The algorithm is implemented in C code using 
  an algorithm  of Donald Knuth and implemented
  by  Glen Rhoads. 
}
\value{
 If \code{f} is missing, the result is a matrix whose dimensions
 are choose(n, r) by r, and each row list the identifiers/indices of the elements
 included in that combination.
}
\references{ 
Glen Rhoad's web site and code snippets - \url{http://remus.rutgers.edu/~rhoads/Code/comb_chase.c}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\note{This is similar to the combinations function \dQuote{by} Bill
 Venables and Brian Ripley in Greg Warnes' \code{gtools} package. That is
 implemented in R, while this uses C code.  Accordingly, this should be
 faster.  Also, the callback mechanism for invoking R functions for each
 generator makes computations on a large collection of combinations
 feasible since they are not stored in memory before using them.  }

\seealso{
  \code{\link[gtools]{combinations}}
  \code{\link{permutations}}
  \code{\link{CombinationGeneratorCallback-class}}
}

\examples{

 x = combinations(3, 2)

  # A more challenging one with choose(30, 4), 
  # i.e.  27405 combinations.
 x = combinations(30, 4)

\dontrun{
  # This is too big. We cannot return the elements as rows of a matrix
  # since there are choose(50, 10) (10,272,278,170) elements.
  # The matrix is limited to 2^31 - 1/ 8 elements.
   
 x = combinations(50, 10)
}

# To deal with large numbers of combinations, we can use a callback
# for each combination.
#  Suppose we have a population of size 10000

breaks = 
function(data, range = 3, n = 10,  by  = sigma/(n))
{
  mu = mean(data)
  sigma = range * sd(data)
  seq(mu - sigma, mu + sigma, by = by)
}

streamingHist = 
function(data, bins = breaks(data))
{
  counts <- integer(length(bins))

 list(handler = 
  function(x) {
     m = mean(data[as.logical(x)])
     i = which.max(m < bins)
     counts[i] <<- counts[i] + 1
     NULL  
  },
  counts = function() counts,
  bins = function() bins)
}

 z = rnorm(50)

 f = streamingHist(z)

 combinations(length(z), 4, f$handler)
 f$counts()
 f$bins()


# Same idea, but using CallbackFunction objects to avoid
# providing explicit accessors to the bins and counts "fields"


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

    # Now f is a function with a specialized class.
   f = streamingHist(z)

   combinations(length(z), 4, f)

   # Now we can access the mutable values "directly".
   f$counts
   f$bins
}
\keyword{math}
\keyword{distribution} % permutation tests
\keyword{htest} % permutation tests
