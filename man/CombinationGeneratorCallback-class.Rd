\name{CombinationGeneratorCallback-class}
\docType{class}
\alias{CombinationGeneratorCallback-class}

\title{A callback type for processing combinations}
\description{
  This function type extends \code{\link{CallbackFunction-class}}
  and is used to specify that the particular function
  needs to be invoked to obtain the actual function
  used as the callback. In this way, the object
  is a generator function that returns the actual callback function.
  This class acts as a form of stronger type checking than simply
  allowing functions or \code{\link{CallbackFunction-class}} objects.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("CombinationGeneratorCallback", ...)}.

}
\section{Slots}{
  \describe{
    \item{\code{.Data}:}{the function object}
  }
}
\section{Extends}{
Class \code{"CallbackFunction"}, directly.
Class \code{"function"}, by class \code{"CallbackFunction"}.
Class \code{"OptionalFunction"}, by class \code{"CallbackFunction"}.
Class \code{"PossibleMethod"}, by class \code{"CallbackFunction"}.
}
\section{Methods}{
No methods defined with class "CombinationGeneratorCallback" in the signature.
}
\references{S4 classes and methods.}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}
\note{}

\seealso{
  \code{\link{CallbackFunction-class}}
  \code{\link{combinations}}
}
\examples{
SampledMean =
  function(data) {
    function(idx)
        mean(data[idx])
  }

myData = rnorm(10)
f = SampledMean(myData)
new("CombinationGeneratorCallback", f)

vals = sapply(1:100, function(i) f(sample(1:10, replace = TRUE)))
summary(vals)
}
\keyword{classes}
