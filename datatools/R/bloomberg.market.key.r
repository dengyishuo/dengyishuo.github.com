##' show key stats of market
##'
##' show key stats of market
##' @title market key data
##' @param startDate 
##' @param endDate 
##' @param ... 
##' @return data frame
##' @export
##' @author Weilin Lin
bloomberg.market.key = function(startDate=NULL, endDate=NULL,...){      
        if(is.null(startDate)) startDate = 20130101;
        bloomberg.market("Yr10",startDate, endDate,...);
        bloomberg.market("Yr7",startDate, endDate,...);
        bloomberg.market("Yr5",startDate, endDate,...);
        bloomberg.market("Yr5_2a_drzp",startDate, endDate,...);
        bloomberg.market("Yr5_2ap_drzp",startDate, endDate,...);
        bloomberg.market("Yr5_2ap_qyz",startDate, endDate,...);
        bloomberg.market("r001",startDate,endDate,...);
        bloomberg.market("r007",startDate,endDate,...);
  }
