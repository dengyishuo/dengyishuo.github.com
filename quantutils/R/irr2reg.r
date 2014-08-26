##' Transfer irregular time series to regular
##' 
##' Transfer irregular time series to regular
##' @title Transfer irregular time series to regular
##' @param x An irregular time series
##' @param ... Other parameters
##' @return An regular time series
##' @export 
##' @author Yishuo Deng

irr2reg <- function(x,...){
	temp_zoo <- zoo(NULL,day_seq(date2num(first(index(x))),date2num(last(index(x)))));
	temp_zoo <- na.locf(merge(x,temp_zoo),fromLast = FALSE);
	return(temp_zoo)
}