##' convert date format to POSIXct
##'
##' Convert date format to POSIXct
##' @title Convert date format to POSIXct
##' @param time time to be converted
##' @param format Time format
##' @export
##' @return An formated time
##' @author Weilin Lin 
dot.date.convert <- function(time, format = "%Y%m%d") {
    if (!inherits(time, "Date") && !inherits(time, "POSIXt") && is.numeric(time)) {
        time <- as.character(time)
    }
    if (is.character(time)) {
        time <- as.POSIXct(strptime(time, format), tz = "")
    }
    return(time)
}
