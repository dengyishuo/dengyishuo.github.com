##' Padding string
##'
##' Padding string
##' @title Padding string
##' @param string Any string
##' @param lengthOut lenthOut
##' @param padChar Padding string
##' @param leading Logical
##' @return x
##' @export
##' @author Weilin Lin
utils.pad <- function(string, lengthOut = 2, padChar = "0", leading = TRUE) {
    n <- nchar(string)
    nas <- which(is.na(string) | string == "NA")
    padString <- sapply(pmax(0, lengthOut - n), function(numPadChars) p(rep(padChar,
        numPadChars), collapse = ""))
    x <- if (leading)
        p(padString, string) else p(string, padString)
    x[nas] <- NA
    x
}
