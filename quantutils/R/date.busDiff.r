##' Unconfirmed
##'
##' Unconfirmed
##' @title Diff between date and BusDate
##' @param fromDate start Date
##' @param toDate end Date
##' @param region region of stocks or bonds
##' @return out Diff between date and busDate
##' @export
##' @author Weilin Lin
date.busDiff <- function(fromDate, toDate, region) {
    fromDate <- date.convert(fromDate)
    toDate <- date.convert(toDate)
    L <- max(length(fromDate), length(toDate))
    if (length(fromDate) != L)
        fromDate <- rep(fromDate, length.out = L)
    if (length(toDate) != L)
        toDate <- rep(toDate, length.out = L)

    i <- which(!is.missing(fromDate) & !is.missing(toDate))

    if (any(date.toBusDate(fromDate[i], region = region) != fromDate[i]))
        stop("Input arg 'fromDate' to date.busDiff() was not all business dates")
    if (any(date.toBusDate(toDate[i], region = region) != toDate[i]))
        stop("Input arg 'toDate' to date.busDiff() was not all business dates")

    output <- rep(NA, L)
    output[i] <- match(toDate[i], DATE.BUS.DATES[[region]]) - match(fromDate[i],
        DATE.BUS.DATES[[region]])
    output
}
