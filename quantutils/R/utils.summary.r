##' Calculates the summary information of an vector
##'
##' Calculates the summary information of an vector
##' @title Calculates the summary information of an vector
##' @param x Any objects
##' @return The Stdev,Skewness and kurtosis of the data
##' @export
##' @author Weilin Lin
utils.summary <- function(x) {
    x <- as.vector(x)
    a <- c(NonNAs = sum(!is.na(x)), Stdev = 0 + sd(x, na.rm = TRUE), Skewness = 0 +
        skewness(x, na.rm = TRUE), Kurtosis = 0 + kurtosis(x, na.rm = TRUE))
    if (sum(is.na(x)) == 0)
        a <- c(`NA's` = 0, a)
    return(c(summary(x), 0 + round(a, 5)))
}
