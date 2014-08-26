##' Add variable to an array
##'
##' Add variable to an array
##' @title Add variable to an array
##' @param a An array
##' @param var Variable needs to added to the array
##' @return An array included the variable added
##' @export
##' @author Weilin Lin

array.addVar <- function(a, var) {
    if (length(dim(a))!= 4) {
        stop("Input must be an SDIV array")
    }
    dn <- dimnames(a)
    dn[[4]] <- c(dn[[4]], var)
    a <- array(c(a, rep(NA, prod(dim(a)) * length(var))), dim = c(dim(a)[1:3],
        length(dn[[4]])), dimnames = dn)
    invisible(a)
}
