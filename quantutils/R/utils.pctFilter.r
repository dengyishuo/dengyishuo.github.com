##' filer stock return
##'
##' filer stock return
##' @title filer stock return
##' @param stockRet stock returns
##' @param probs probility
##' @return null
##' @export
##' @author Weilin Lin
utils.pctFilter <- function(stockRet, probs = c(0.01, 0.99)) {
    bounds <- quantile(stockRet, probs = probs, na.rm = TRUE)
    stockRet <- pmax(pmin(stockRet, bounds[2]), bounds[1])
    invisible(stockRet)
}
