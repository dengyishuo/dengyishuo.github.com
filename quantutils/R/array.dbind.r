##' Change the dimnames and dimensions of an array
##'
##' Change the dimnames and dimensions of an array
##' @title Change the dimnames and dimensions of an array
##' @param ... other parametres needed
##' @param overwrite Logical
##' @return An array with an new dimnames and dimensions
##' @export
##' @author Weilin Lin
array.dbind <- function(..., overwrite = FALSE) {
    L <- list(...)
    array.dbindList(L, overwrite = overwrite)
}
