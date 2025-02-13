% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{CheckDots}
\alias{CheckDots}
\title{Check the Use of Dots}
\usage{
CheckDots(..., fxns = NULL)
}
\arguments{
\item{...}{Arguments passed to a function that fall under \code{...}}

\item{fxns}{A list/vector of functions or function names}
}
\value{
Emits either an error or warning if an argument passed is unused;
invisibly returns \code{NULL}
}
\description{
Function to check the use of unused arguments passed to \code{...}; this
function is designed to be called from another function to see if an
argument passed to \code{...} remains unused and alert the user if so. Also
accepts a vector of function or function names to see if \code{...} can be
used in a downstream function
}
\details{
Behavior of \code{CheckDots} can be controlled by the following option(s):
\describe{
 \item{\dQuote{\code{Seurat.checkdots}}}{Control how to alert the presence
 of unused arguments in \code{...}; choose from
 \itemize{
  \item \dQuote{\code{warn}}: emit a warning (default)
  \item \dQuote{\code{error}}: throw an error
  \item \dQuote{\code{silent}}: no not alert the presence of unused
  arguments in \code{...}
 }
 }
}
}
\examples{
\dontrun{
f <- function(x, ...) {
  CheckDots(...)
  return(x ^ 2)
}
f(x = 3, y = 9)
}

}
\keyword{internal}
