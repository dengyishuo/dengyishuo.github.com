##' load universe data
##'
##' load universe data
##' @title load universe data
##' @param startDate startDate for backtesting
##' @param endDate endDate for backtesting
##' @param cfgLst configuration list for backtesting
##' @return cfgLst
##' @export
##' @author Weilin Lin
backtest.loadUniv <- function(startDate=NULL, endDate=NULL,cfgLst)
{
   if (is.null(startDate))
    {
      startDate <- cfgLst$startDate;
    }
  
  if (is.null(endDate))
    {
      endDate <- cfgLst$endDate;
    }
  
   cfgLst$univLst <- univ(startDate=startDate, endDate=endDate, univType=cfgLst$univType, univRange=cfgLst$univRange, region=cfgLst$region);
   invisible(cfgLst);
}
