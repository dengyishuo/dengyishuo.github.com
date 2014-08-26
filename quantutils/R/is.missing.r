##' Is an object missing
##'
##' Is an object missing
##' @title Is an object missing
##' @param x any object
##' @return Logical
##' @export
##' @author Weilin Lin
is.missing <- function(x) {
if (length(x)) {is.na(x) 
}
else 
{T}
}