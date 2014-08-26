##' Caculates dates bases date.R.ORIGIN
##'
##' Caculates dates bases date.R.ORIGIN
##' @title Caculates dates bases date.R.ORIGIN
##' @param julian Julian time (days since some origin)
##' @return a date 
##' @author Weilin Lin
##' @export
##' @examples date.fromJulian(100)
date.fromJulian <- function(julian) {
    date.convert(date.R.ORIGIN + julian)
}
