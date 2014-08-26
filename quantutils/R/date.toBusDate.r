##' Convert date to BusDate
##'
##' Convert date to BusDate
##' @title Convert date to BusDate
##' @param date date to be converted
##' @param region region for stocks or bonds
##' @param shift 0
##' @param forward logical
##' @return DATE.BUS.DATES
##' @export 
##' @author Weilin Lin
date.toBusDate <- function(date, region, shift = 0, forward = TRUE) {
    date <- date.date(date.convert(date));
    i <- approx(x = as.numeric(DATE.BUS.DATES[[region]]), y = 1:length(DATE.BUS.DATES[[region]]),
        xout = as.numeric(date), method = "constant", rule = 1, f = as.numeric(forward))$y
    i <- i + shift;
    is.na(i[which(i < 1 | i > length(DATE.BUS.DATES[[region]]))]) <- TRUE;
    return(DATE.BUS.DATES[[region]][i])
}
