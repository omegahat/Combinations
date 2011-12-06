\name{CallbackFunction-class}
\docType{class}
\alias{CallbackFunction-class}
\alias{$,CallbackFunction-method}
\alias{names,CallbackFunction-method}

\title{Class "CallbackFunction" acting as an event handler or callback function. }
\description{
  The idea of this is to have a function that acts as an asynchronous
  event handler or a method for a mutable object
  in the sense of a Java, C++ or Python.
  We can use this as a regular function in R, but we can also use
  convenience functions (\code{\$} and \code{names})
  to access the environment of the function and the mutable, dynamic
  variables.
}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("CallbackFunction", function(...) # body)}.
These are regular function objects with the additional methods for accessing the
mutable values associated with them and their environment.
}
\section{Slots}{
  \describe{
    \item{\code{.Data}:}{Object of class \code{"function"}}
  }
}
\section{Extends}{
Class \code{"function"}, from data part.
Class \code{"OptionalFunction"}, by class \code{"function"}.
Class \code{"PossibleMethod"}, by class \code{"function"}.
}
\section{Methods}{
  \describe{
    \item{\$}{\code{signature(x = "CallbackFunction")}: access a particular variable in the function's environment.}
    \item{names}{\code{signature(x = "CallbackFunction")}: get a list of all the objects in the function's environment. }
  }
}
\references{S4 classes and methods.}
\author{Duncan Temple Lang <duncan@wald.ucdavis.edu>}
\note{}

\seealso{
 \code{\link[base]{names}}
 \code{\link[base]{$}}
}
\examples{

}
\keyword{classes}
