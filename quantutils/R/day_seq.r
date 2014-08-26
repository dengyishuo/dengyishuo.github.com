##' Generate a time series 
##' 
##' Generate a time series 
##' @title Generate a time series 
##' @param startdate startdate of time series
##' @param enddate endDate of time series
##' @return xts object
##' @export 
##' @examples day_seq(20120302,20130405)
##' @author Yishuo Deng

day_seq <- function(startdate,enddate,...){
	seq.POSIXt(from=strptime(startdate,format="%Y%m%d"),to=strptime(enddate,format="%Y%m%d"),by="day");
}