##' Find the index of NAs in a vector
##' 
##' Find the index of NAs in a vector
##' @title Find the index of NAs in a vector
##' @param x A vector
##' @return The index of NAs in the vector
##' @export
##' @author Weilin Lin Weilin Lin
which.na <- function(x) which(is.na(x))
