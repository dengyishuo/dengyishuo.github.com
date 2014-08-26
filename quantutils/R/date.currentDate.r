##' Gets the current time and date, optionally for the specified zone or region.
##'
##' Gets the current time and date, optionally for the specified zone or region.
##' @title Gets the current time and date, optionally for the specified zone or region.
##' @return date in format of "YYYYMMDD"
##' @export
##' @author Weilin Lin
date.currentDate <- function() {
    date <- date.convert(Sys.Date(), format = "YYYYMMDD")
    return(date)
}
