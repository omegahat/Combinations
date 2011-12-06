\name{permutations}
\alias{permutations}
\title{Enumerate all possible permutations of n items}
\description{
  This function enumerates all of the n! permutations
  (not combinations)  of the n numbers.
  The algorithm is in C and not R and so is relatively
  rapid.
  The number of permutations is gamma(n+1) and gets
  large very rapidly.
  So the algorithm only works for n < 12 as
  12! will exceed the size of the largest vector we can
  hold on 32 bit machines.

  We could arrange to hold these permutations not as a matrix,
  but as a list and that would avoid the contiquous memory problems.
  However, at present, we simply use a streaming data approach.
  The caller provides a function that is invoked for each
  permutation as it is generated. That function can perform
  any computations based on that permutation and any data to which it
  has access. When it returns, the permutation generator continues
  with the next permutation and reuses the memory. In this way,
  the collection of permutations is never held in memory.
}
\usage{
permutations(n, fun = NULL)
}

\arguments{
  \item{n}{the number of items to permute}
  \item{fun}{if specified, a function that is called with one argument
    which is a permutation of 1:n. The return value of this function
    is currently ignored.  (In the future, we may use the return value
    to signal a termination, but the function can raise an exception
    itself.)}
}
\details{

}
\value{
  If \code{fun} is missing, a matrix whose rows are the permutations.
  The dimension is n! x n.
}

\references{ 
Glen Rhoad's web site and code snippets - \url{http://remus.rutgers.edu/~rhoads/Code/comb_chase.c}
}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}

\note{This is similar to the combinations function \dQuote{by} Bill
 Venables Brian Ripley in Greg Warnes' \code{gtools} package. That is
 implemented in R, while this uses C code.  Accordingly, this should be
 faster.  Also, the callback mechanism for invoking R functions for each
 generator makes computations on a large collection of combinations
 feasible since they are not stored in memory before using them.

 As I found out after having created the package, of course others have
 hit on similar ideas in S.  An iterator approach
 where one could ask for the next permutation was posted by Bill
 Venables on the Snews mailing list on 30th, July, 1999. Scott Chaslow
 also provides a version of combinations that accepts a function.
 Without closures, things get a little trickier, but the idea is the
 same, and the primary difference is that we have reused 3rd party C
 code and provided an interface to that.  }

\seealso{
\code{\link{combinations}}
}
\examples{

 permutations(3)  # 6
 permutations(7)  # 5040


 # Executing a simple function for each permutation.
 # The function takes the permutation of indices and
 # turns them into strings. It stores them globally !!!!!!
 # This is very bad, but simplifies the example.
 strings = character()
 permutations(3, function(perm) strings <<- c(strings, paste(perm, collapse = "")))

 unique(strings) == strings


 # Permutation test.

 permMean =
 function(x, y, breaks = seq(-1, 1, length = 100)) {

   counts = integer(length(breaks))

   f =
   function(perm) {
      els = c(x, y)[perm]
      x.prime = els[1:length(x)]
      y.prime = els[seq(length(x), length = length(y))]

      val = (mean(x.prime) - mean(y.prime))/sqrt(var(x.prime)/5 +  var(y.prime)/5)

      i = which.min(val > breaks)
      counts[i] <<- counts[i] + 1

      TRUE
   }

   new("CombinationGeneratorCallback", f)
 }


 # 2 samples of size 2. Small number since this is an example.
 x = rnorm(2, 1)
 y = rnorm(2, .5)
 h = permMean(x, y)

 permutations(length(x) + length(y), h)

 h$counts


 # Generate the permutations in a list so as to be able to
 # avoid holding all of them in a contiguous block of memory
 # in a matrix.

 gen =
 function(n) {
     # Allocate the list with as many elements as there are permutations.
   perms = vector("list", gamma(n + 1))
   ctr <- 1

   # A function that is called each time 
   op =
   function(perm) {
     perms[[ctr]] <<- perm
     ctr <<- ctr + 1
     TRUE
   }

   new("CombinationGeneratorCallback", op)
 }

 f = gen(4)
 permutations(4, f)
 f$perms
 
}
\keyword{math}
\keyword{distribution} % permutation tests
\keyword{htest} % permutation tests
