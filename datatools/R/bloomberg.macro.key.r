##' key stats for macro
##'
##' key stats for macro
##' @title key stats for macro
##' @param name 
##' @param startDate 
##' @param endDate 
##' @param ... 
##' @return data frame
##' @export
##' @author Weilin Lin
bloomberg.macro.key = function(name, startDate=NULL, endDate=NULL,...){
      countries = c("BZ","CN","RU","US");
        names = p(countries,"_",name);
        par(mfrow=c(2,2));
        bloomberg.macro(names[1],startDate=startDate,...);
        bloomberg.macro(names[2],startDate=startDate,...);
        bloomberg.macro(names[3],startDate=startDate,...);
        bloomberg.macro(names[4],startDate=startDate,...);
  }
