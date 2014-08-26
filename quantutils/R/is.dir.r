##' check whether x a valid direction 
##'
##' check whether x a valid direction 
##' @title check whether x a valid direction 
##' @param x any path
##' @return logical
##' @export
##' @author Weilin Lin
is.dir <- function(x) file.info(x)$isdir
