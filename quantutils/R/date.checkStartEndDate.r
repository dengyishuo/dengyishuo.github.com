##' Check start and end date
##'
##' Check start and end date
##' @title Check start and end date
##' @param startDate start Date
##' @param endDate End Date
##' @param region region 
##' @return StartDate and endDate
##' @export
##' @author Weilin Lin
date.checkStartEndDate <- function(startDate, endDate, region) {
    startDate <- date.convert(startDate)
    endDate <- date.convert(endDate)
    if (startDate > endDate)
        stop("startDate=", p(startDate), " can't be later than endDate=", p(endDate))
    dateBound <- date.toBusDate(date.currentTime(), shift = 1, region = region)
    if (startDate > dateBound)
        stop("startDate = ", startDate, " can't be later than ", dateBound)
    if (endDate > dateBound)
        stop("  endDate = ", endDate, " can't be later than ", dateBound)
    return(list(startDate = startDate, endDate = endDate))
}
