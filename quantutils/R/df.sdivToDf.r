##' transforms SDIV(stock,date,invernal,vale) to data frame
##'
##' transforms SDIV(stock,date,invernal,vale) to data frame
##' @title transforms SDIV(stock,date,invernal,vale) to data frame
##' @param arr array
##' @param verbose logical
##' @return arr
##' @export
##' @author Weilin Lin
df.sdivToDf <- function(arr, verbose = FALSE) {
    if (length(dim(arr)) != 4)
        stop("Input must be an SDIV array")
    names(dimnames(arr)) <- c("stock", "date", "interval", p("value", 1:(length(dim(arr)) -
        3)))
    arr <- df.arrayToDf(arr, valueDim = "value1")
    arr <- arr[order(arr$stock, arr$date, arr$interval), , drop = FALSE]
    return(arr)
}






