##' Mask of Paste
##'
##' Mask of Paste
##' @title Mask of Paste
##' @param ... Any objects in R
##' @return Paseted objects
##' @export
##' @author Weilin Lin
p <- function(...) {
    if (hasArg("sep")) {
        return(paste(...))
    } else {
        return(paste(sep = "", ...))
    }
}
