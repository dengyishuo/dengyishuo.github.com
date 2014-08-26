##' time series to data frame
##'
##' time series to data frame
##' @title time series to data frame
##' @param ts 
##' @return data frame
##' @export
##' @author Weilin Lin
df.tsTodf <- function(ts){
      vars  = colnames(ts);
        dates = as.character(time(ts));
        ts    = as.data.frame(ts);
        lst = list();
        for(var in vars){
                lst[[var]] = data.frame(name=var, date=dates, value=ts[[var]], updateTime=as.character(Sys.time()));
            }
        return(df.rbindList(lst));
  }
