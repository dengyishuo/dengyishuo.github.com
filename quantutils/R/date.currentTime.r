##' Convert time into a special format
##'
##' Convert time into a special format
##' @title Convert time into a special format
##' @return An time object
##' @export
##' @author Weilin Lin
date.currentTime <- function() {
    return(date.convert(Sys.time(), format = "YYYYMMDD.%H%M%S"))
}
