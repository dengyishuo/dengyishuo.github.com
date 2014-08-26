##' convert date to strings
##'
##' convert date to strings
##' @title convert date to strings
##' @param time time to be converted
##' @return time converted
##' @export
##' @author Weilin Lin
date.toString <- function(time) {
    format(date.convert(time), "%Y%m%d", usetz = FALSE)
}
