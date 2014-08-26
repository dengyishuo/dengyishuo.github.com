##' transfer datetime to POSIXlt
##' 
##' transfer datetime to POSIXlt
##' @title transfer datetime to POSIXlt
##' @param x Datetime
##' @return An POSIXlt object
##' @export
##' @author Yishuo Deng
datetime2POSIXlt <- function(x){
  strptime(as.character(x),format="%Y%m%d%H%M%S",tz = "EST5EDT")
}
