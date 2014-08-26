##' Extract the month of date
##'
##' Extract the month of date
##' @title Extract the month of date
##' @param date any date 
##' @return the year and month as numeric
##' @export
##' @author Weilin Lin
date.month <- function(date) {
    return(as.numeric(substring(p(date.convert(date, format = "YYYYMMDD")), 1,6)))
}
