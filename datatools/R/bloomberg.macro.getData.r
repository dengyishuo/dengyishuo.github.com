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
bloomberg.macro.getData = function(names, startDate=NULL, endDate=NULL,...){
    lst <- list();
    for(name in names){
        lst[[name]] <- bloomberg.macro(name, startDate=startDate, endDate=endDate,verbose=FALSE);
        lst[[name]] <- lst[[name]][,"released"];
        colnames(lst[[name]]) <- name;
    }
    ## merge all the data
    data <- do.call(merge, lst);
    return(data);
}
