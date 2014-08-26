##' Discompose an Date to day,month and year
##' 
##' Discompose an Date to day,month and year
##' @title Discompose an Date to day,month and year
##' @param x The Date object needed to be discomposed
##' @param ... Other parameters
##' @return An dataframe contains the day, month and year
##' @export 
##' @examples des_date(as.Date("2013-03-04"))
##' @author Yishuo Deng

des_date <- function(x,...){
	df <- as.data.frame(do.call(rbind,strsplit(as.character(x),"-")));
	colnames(df) <- c("year","month","day");
	df
	}