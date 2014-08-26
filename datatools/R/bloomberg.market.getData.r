##' bloombereg get data
##'
##' bloombereg get data
##' @title bloombereg get data
##' @param names names of indicators
##' @param startDate 
##' @param endDate 
##' @param ... 
##' @return xts object
##' @export
##' @author Weilin Lin
bloomberg.market.getData = function(names, startDate=NULL, endDate=NULL,...){
    lst <- list();
    for(name in names){
        lst[[name]] <- bloomberg.market(name, startDate=startDate, endDate=endDate,ifPlot = FALSE);
        lst[[name]] <- lst[[name]][,1];
        colnames(lst[[name]]) <- name;
    }
    ## merge all the data
    data <- do.call(merge, lst);
    return(data);
}
