##' Calculates the skewness of a distribution
##'
##' Calculates the skewness of a distribution
##' @title Calculates the skewness of a distribution
##' @param x Data
##' @param na.rm Logical
##' @param method menthod usded to calculates skewness
##' @return skewness
##' @export
##' @author Weilin Lin
skewness <- function(x, na.rm = F, method = "fisher") {
    method <- char.expand(method, c("fisher", "moment"), stop("argument 'method' must match either \"fisher\" or \"moment\""))
    if (na.rm) {
        wnas <- which.na(x)
        if (length(wnas))
            x <- x[-wnas]
    } else if (length(which.na(x)))
        return(NA)
    n <- as.double(length(x))
    if (method == "fisher" && n < 3)
        return(NA)
    x <- x - mean(x)
    if (method == "moment")
        (sum(x^3)/n)/(sum(x^2)/n)^1.5 else ((sqrt(n * (n - 1))/(n - 2)) * (sum(x^3)/n))/((sum(x^2)/n)^1.5)
}
