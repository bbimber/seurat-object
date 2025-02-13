#' @include zzz.R
#' @include generics.R
#' @importFrom methods setClass slot slot<- new
#'
NULL

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Class definitions
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#' The SpatialImage class
#'
#' The \code{SpatialImage} class is a virtual class representing spatial
#' information for Seurat. All spatial image information must inherit from this
#' class for use with \code{Seurat} objects
#'
#' @slot assay Name of assay to associate image data with; will give this image
#' priority for visualization when the assay is set as the active/default assay
#' in a \code{Seurat} object
#' @slot key Key for the image
#'
#' @name SpatialImage-class
#' @rdname SpatialImage-class
#' @exportClass SpatialImage
#'
#' @seealso \code{\link{SpatialImage-methods}} for a list of required and
#' provided methods
#'
SpatialImage <- setClass(
  Class = 'SpatialImage',
  contains = 'VIRTUAL',
  slots = list(
    'assay' = 'character',
    'key' = 'character'
  )
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Functions
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Methods for Seurat-defined generics
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#' \code{SpatialImage} methods
#'
#' Methods defined on the \code{\link{SpatialImage}} class. Some of these
#' methods must be overridden in order to ensure proper functionality of the
#' derived classes (see \strong{Required methods} below). Other methods are
#' designed to work across all \code{SpatialImage}-derived subclasses, and
#' should only be overridden if necessary
#'
#' @param x,object A \code{SpatialImage}-derived object
#' @param ... Arguments passed to other methods
#' @param value Depends on the method:
#' \describe{
#'  \item{\code{DefaultAssay<-}}{Assay that the image should be
#'  associated with}
#'  \item{\code{Key<-}}{New key for the image}
#' }
#' @inheritParams RenameCells
#'
#' @section Provided methods:
#' These methods are defined on the \code{SpatialImage} object and should not
#' be overridden without careful thought
#' \itemize{
#'   \item \code{\link{DefaultAssay}} and \code{\link{DefaultAssay<-}}
#'   \item \code{\link{Key}} and \code{\link{Key<-}}
#'   \item \code{\link{GetImage}}; this method \emph{can} be overridden to
#'   provide image data, normally returns empty image data. If overridden,
#'   should default to returning a  \code{\link[grid]{grob}} object
#'   \item \code{\link{IsGlobal}}
#'   \item \code{\link{Radius}}; this method \emph{can} be overridden to
#'   provide a spot radius for image objects
#'   \item \code{\link[base:Extract]{[}}; this method \emph{can} be overridden
#'   to change default subset behavior, normally returns
#'   \code{subset(x = x, cells = i)}. If overridden, should only accept \code{i}
#' }
#'
#' @section Required methods:
#' All subclasses of the \code{SpatialImage} class must define the following
#' methods; simply relying on the \code{SpatialImage} method will result in
#' errors. For required parameters and their values, see the \code{Usage} and
#' \code{Arguments} sections
#' \describe{
#'   \item{\code{\link{Cells}}}{
#'    Return the cell/spot barcodes associated with each position
#'   }
#'   \item{\code{\link{dim}}}{
#'    Return the dimensions of the image for plotting in \code{(Y, X)} format
#'   }
#'   \item{\code{\link{GetTissueCoordinates}}}{
#'    Return tissue coordinates; by default, must return a two-column
#'    \code{data.frame} with x-coordinates in the first column and
#'    y-coordinates in the second
#'   }
#'   \item{\code{\link{Radius}}}{
#'    Return the spot radius; returns \code{NULL} by default for use with
#'    non-spot image technologies
#'   }
#'   \item{\code{\link{RenameCells}}}{
#'    Rename the cell/spot barcodes for this image
#'   }
#'   \item{\code{\link{subset}}}{
#'    Subset the image data by cells/spots
#'   }
#' }
#' These methods are used throughout Seurat, so defining them and setting the
#' proper defaults will allow subclasses of \code{SpatialImage} to work
#' seamlessly
#'
#' @name SpatialImage-methods
#' @rdname SpatialImage-methods
#'
#' @concept spatialimage
#'
NULL

#' @describeIn SpatialImage-methods Get the cell names from an image
#' (\strong{[Override]})
#'
#' @return \strong{[Override]} \code{Cells}: should return cell names
#'
#' @method Cells SpatialImage
#' @export
#'
Cells.SpatialImage <- function(x, ...) {
  stop(
    "'Cells' must be implemented for all subclasses of 'SpatialImage'",
    call. = FALSE
  )
}

#' @describeIn SpatialImage-methods Get the associated assay of a
#' \code{SpatialImage}-derived object
#'
#' @return \code{DefaultAssay}: The associated assay of a
#' \code{SpatialImage}-derived object
#'
#' @method DefaultAssay SpatialImage
#' @export
#'
#' @seealso \code{\link{DefaultAssay}}
#'
DefaultAssay.SpatialImage <- function(object, ...) {
  CheckDots(...)
  return(slot(object = object, name = 'assay'))
}

#' @describeIn SpatialImage-methods Set the associated assay of a
#' \code{SpatialImage}-derived object
#'
#' @return \code{DefaultAssay<-}: \code{object} with the associated assay
#' updated
#'
#' @method DefaultAssay<- SpatialImage
#' @export
#'
"DefaultAssay<-.SpatialImage" <- function(object, ..., value) {
  CheckDots(...)
  slot(object = object, name = 'assay') <- value
  return(object)
}

#' @describeIn SpatialImage-methods Get the image data from a
#' \code{SpatialImage}-derived object
#'
#' @inheritParams GetImage
#'
#' @return \strong{[Override]} \code{GetImage}: The image data from a
#' \code{SpatialImage}-derived object
#'
#' @method GetImage SpatialImage
#' @export
#'
#' @seealso \code{\link{GetImage}}
#'
GetImage.SpatialImage <- function(
  object,
  mode = c('grob', 'raster', 'plotly', 'raw'),
  ...
) {
  return(NullImage(mode = mode))
}

#' @describeIn SpatialImage-methods Get tissue coordinates for a
#' \code{SpatialImage}-derived object (\strong{[Override]})
#'
#' @return \strong{[Override]} \code{GetTissueCoordinates}: ...
#'
#' @method GetTissueCoordinates SpatialImage
#' @export
#'
#' @seealso \code{\link{GetTissueCoordinates}}
#'
GetTissueCoordinates.SpatialImage <- function(object, ...) {
  stop(
    "'GetTissueCoordinates' must be implemented for all subclasses of 'SpatialImage'",
    call. = FALSE
  )
}

#' @describeIn SpatialImage-methods Globality test for
#' \code{SpatialImage}-derived object
#'
#' @return \code{IsGlobal}: returns \code{TRUE} as images are, by default,
#' global
#'
#' @method IsGlobal SpatialImage
#' @export
#'
#' @seealso \code{\link{IsGlobal}}
#'
IsGlobal.SpatialImage <- function(object, ...) {
  return(TRUE)
}

#' @describeIn SpatialImage-methods Get the key for a
#' \code{SpatialImage}-derived object
#'
#' @return \code{Key}: The key for a \code{SpatialImage}-derived object
#'
#' @method Key SpatialImage
#' @export
#'
#' @seealso \code{\link{Key}}
#'
Key.SpatialImage <- function(object, ...) {
  CheckDots(...)
  # object <- UpdateSlots(object = object)
  return(slot(object = object, name = 'key'))
}

#' @describeIn SpatialImage-methods Set the key for a
#' \code{SpatialImage}-derived object
#'
#' @return \code{Key<-}: \code{object} with the key set to \code{value}
#'
#' @method Key<- SpatialImage
#' @export
#'
"Key<-.SpatialImage" <- function(object, ..., value) {
  CheckDots(...)
  object <- UpdateSlots(object = object)
  value <- UpdateKey(key = value)
  slot(object = object, name = 'key') <- value
  return(object)
}

#' @describeIn SpatialImage-methods Get the spot radius size
#'
#' @return \code{Radius}: The spot radius size; by default, returns \code{NULL}
#'
#' @method Radius SpatialImage
#' @export
#'
Radius.SpatialImage <- function(object) {
  return(NULL)
}

#' @describeIn SpatialImage-methods Rename cells in a
#' \code{SpatialImage}-derived object (\strong{[Override]})
#'
#' @return \strong{[Override]} \code{RenameCells}: \code{object} with the new
#' cell names
#'
#' @method RenameCells SpatialImage
#' @export
#'
#' @seealso \code{\link{RenameCells}}
#'
RenameCells.SpatialImage <- function(object, new.names = NULL, ...) {
  stop(
    "'RenameCells' must be implemented for all subclasses of 'SpatialImage'",
    call. = FALSE
  )
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Methods for R-defined generics
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#' @describeIn SpatialImage-methods Subset a \code{SpatialImage}-derived object
#'
#' @param i,cells A vector of cells to keep
#'
#' @return \code{[}, \code{subset}: \code{x}/\code{object} for only the cells
#' requested
#'
#' @method [ SpatialImage
#' @export
#'
"[.SpatialImage" <- function(x, i, ...) {
  return(subset(x = x, cells = i))
}

#' @describeIn SpatialImage-methods Get the plotting dimensions of an image
#' (\strong{[Override]})
#'
#' @return \strong{[Override]} \code{dim}: The dimensions of the image data in
#' (Y, X) format
#'
#' @method dim SpatialImage
#' @export
#'
dim.SpatialImage <- function(x) {
  stop(
    "'dim' must be implemented for all subclasses of 'SpatialImage'",
    call. = FALSE
  )
}

#' @describeIn SpatialImage-methods Subset a \code{SpatialImage}-derived object
#' (\strong{[Override]})
#'
#' @method subset SpatialImage
#' @export
#'
subset.SpatialImage <- function(x, cells, ...) {
  stop("'subset' must be implemented for all subclasses of 'SpatialImage'")
}

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# S4 methods
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#' @describeIn SpatialImage-methods Overview of a \code{SpatialImage}-derived
#' object
#'
#' @return \code{show}: Prints summary to \code{\link[base]{stdout}} and
#' invisibly returns \code{NULL}
#'
#' @importFrom methods show
#'
#' @export
#'
setMethod(
  f = 'show',
  signature = 'SpatialImage',
  definition = function(object) {
    object <- UpdateSlots(object = object)
    cat(
      "Spatial data from the",
      class(x = object),
      "technology for",
      length(x = Cells(x = object)),
      "samples\n"
    )
    cat("Associated assay:", DefaultAssay(object = object), "\n")
    cat("Image key:", Key(object = object), "\n")
    return(invisible(x = NULL))
  }
)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Internal
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#' Return a null image
#'
#' @inheritParams GetImage
#'
#' @return Varies by value of \code{mode}:
#' \describe{
#'  \item{\dQuote{grob}}{a \code{\link[grid]{nullGrob}}}
#'  \item{\dQuote{raster}}{an empty \code{\link[grDevices:as.raster]{raster}}}
#'  \item{\dQuote{plotly}}{a list with one named item: \code{value = FALSE}}
#'  \item{\dQuote{raw}}{returns \code{NULL}}
#' }
#'
#' @importFrom grid nullGrob
#' @importFrom grDevices as.raster
#'
#' @keywords internal
#'
#' @noRd
#'
NullImage <- function(mode = c('grob', 'raster', 'plotly', 'raw')) {
  mode <- mode[1]
  mode <- match.arg(arg = mode)
  image <- switch(
    EXPR = mode,
    'grob' = nullGrob(),
    'raster' = as.raster(x = new(Class = 'matrix')),
    'plotly' = list('visible' = FALSE),
    'raw' = NULL,
    stop("Unknown image mode: ", mode, call. = FALSE)
  )
  return(image)
}
