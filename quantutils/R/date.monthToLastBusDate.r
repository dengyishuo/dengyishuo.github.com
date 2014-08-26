##' month to last BusDate
##'
##' month to last BusDate
##' @title month to last BusDate
##' @param month month
##' @param region region for month
##' @return null
##' @export
##' @author Weilin Lin
date.monthToLastBusDate <- function(month, region) {
    month <- date.shiftMonths(as.numeric(month), 1)
    date.toBusDate(p(month, "01"), -1, region = region)
}
