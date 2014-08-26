##' transfer date to number
##' 
##' transfer date to number
##' @title transfer date to number
##' @param x Datetime
##' @return An number
##' @export
##' @examples date2num("2013-01-01")
##' @author Yishuo Deng

date2num <- function(x){
  gsub("-","",as.character(x))
}