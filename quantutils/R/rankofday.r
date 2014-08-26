##' Calulates the rank of a Date
##' 
##' Calulates the rank of a Date
##' @title Calulates the rank of a Date
##' @param Date A date.
##' @param ... Other parameters.
##' @return The rank of the date
##' @export 
##' @examples rankofday("2013-01-25");rankofday(as.Date("2013-01-25"))
##' @author Yishuo Deng

rankofday <- function(x,...){
    as.numeric(as.Date(x)-as.Date(paste(substr(x,1,4),"01-01",sep="-")))+1;
	}