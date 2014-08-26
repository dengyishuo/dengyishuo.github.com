##' Compare tow arrays
##'
##' Compare two arrays and plot the correlation between them
##' @title Compare two arrays and plot the correlation between them
##' @param arr.o Old arrays
##' @param arr.n New arrays
##' @return correlation plot between arr.o and arr.n
##' @export
##' @author Weilin Lin
array.compareSDIV <- function(arr.o, arr.n) {
    stocks <- intersect(dimnames(arr.o)[[1]], dimnames(arr.n)[[1]])
    dates <- intersect(dimnames(arr.o)[[2]], dimnames(arr.n)[[2]])
    ivals <- intersect(dimnames(arr.o)[[3]], dimnames(arr.n)[[3]])
    vars <- intersect(dimnames(arr.o)[[4]], dimnames(arr.n)[[4]])
    nVars <- length(vars)
    m <- round(sqrt(nVars))
    n <- ceiling(nVars/m)

    par(mfrow = c(m, n))

    for (var in vars) {
        old <- as.vector(arr.o[stocks, dates, ivals, var])
        new <- as.vector(arr.n[stocks, dates, ivals, var])
        corCoef <- cor(old, new, use = "pair")
        plot(old, new, xlab = "old", ylab = "new", main = p(var, ": ", round(corCoef,
            3)))
    }
    invisible
}
