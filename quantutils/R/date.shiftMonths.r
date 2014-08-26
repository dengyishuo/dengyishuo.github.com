##' shift months
##'
##' shift months
##' @title shift months
##' @param months original months
##' @param shift shift of months
##' @return a months shifted
##' @author Weilin Lin
##' @export
date.shiftMonths <- function(months, shift) {
    months <- as.numeric(months)
    julianMonths <- (months%/%100) * 12 + (months%%100)
    julianMonths <- julianMonths + shift

    mm <- (julianMonths - 1)%%12 + 1
    yyyy <- (julianMonths - mm)/12
    100 * yyyy + mm
}
