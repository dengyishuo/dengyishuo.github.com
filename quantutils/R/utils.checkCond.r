##' check condition
##'
##' check condition
##' @title check condition
##' @param cond conditon
##' @param msg stop message
##' @return Logical
##' @export
##' @author Weilin Lin
utils.checkCond <- function(cond, msg) {
    if (is.na(cond) || cond == FALSE)
        stop(msg)
}
