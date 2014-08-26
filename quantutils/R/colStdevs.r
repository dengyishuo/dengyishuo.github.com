##' Calculate the sd of a matrix by column
##'
##' Calculate the sd of a matrix by column
##' @title Calculate the sd of a matrix by column
##' @param x Matix
##' @param na.rm Logical
##' @return An vector contains the sds.
##' @export
##' @author Weilin Lin
colStdevs <- function(x, na.rm = F) {
    apply(x, 2, function(x) sd(x, na.rm))
}
