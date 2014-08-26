##' check if the day is trading day
##'
##' check if the day is trading day
##' @title check if the day is trading day
##' @param date date in YYYYMMDD format 
##' @param region specify the market, CN or HK are supported
##' @return TRUE or FALSE
##' @export
##' @author Weilin Lin
date.isBusDate <- function(date, region="CN"){
  date <- date.convert(date);
  if(date==date.toBusDate(date, region=region)){
    return(TRUE)
  }else{
    return(FALSE)
  }
}
