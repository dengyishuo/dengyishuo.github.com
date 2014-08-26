##' date range
##'
##' date range
##' @title date range
##' @param startDate start Date of date range
##' @param endDate end Date for date range
##' @param n dyes between startDate and endDate
##' @param region region for stocks or bonds
##' @return date range
##' @export
##' @author Weilin Lin Weilin  Lin
date.range <- function(startDate, endDate = NULL, n = NULL, region) {
    if ((is.null(endDate) && is.null(n)) || (!is.null(n) && n <= 0) || (!is.null(endDate) &&
        !is.null(n)))
        stop("must give startDate and exactly one of endDate >= startDate or n > 0")
    startDate <- date.toBusDate(date.convert(startDate), region = region)
    if (!is.null(endDate)) {
        endDate <- date.convert(endDate)
        if (endDate != date.toBusDate(endDate, region = region))
            endDate <- date.toBusDate(endDate, shift = -1, region = region)

        if (startDate > endDate)
            stop("No business dates between startDate and endDate")

        n <- date.busDiff(startDate, endDate, region = region) + 1
        if (n < 0)
            stop("must give startDate and exactly one of endDate >= startDate or n > 0")
    }
    dateRange <- date.convert(date.toBusDate(startDate, shift = 0:(n - 1), region = region))
    return(dateRange)
}
