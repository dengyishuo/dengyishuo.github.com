##' month to first Bus Date
##'
##' month to first Bus Date
##' @title month to first Bus Date
##' @param month month
##' @param region region 
##' @return null
##' @export
##' @author Weilin Lin
date.monthToFirstBusDate <- function(month, region) {
    date.toBusDate(p(month, "01"), region = region)
}