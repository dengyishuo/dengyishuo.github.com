##' Convert date to format "YYYYMMDD"
##'
##' Convert date to format "YYYYMMDD"
##' @title Convert date to format "YYYYMMDD"
##' @param time time to be converted
##' @return time converted
##' @export
##' @author Weilin Lin
date.date <- function(time) {
    date.convert(date.convert(time, format = "YYYYMMDD"))
}
