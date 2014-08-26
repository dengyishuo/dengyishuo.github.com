##' backtest the stock selection strategy
##'
##' backtest the stock selection strategy
##' @title backtest the stock selection strategy
##' @param startDate startDate of backtest 
##' @param endDate endDate of backtest
##' @param cfgLst configuration list object for backtest
##' @return cfgLst contains market data
##' @export
##' @author Weilin Lin
##' 
backtest.loadData <- function(startDate=NULL,endDate=NULL, cfgLst)
{
  if (is.null(startDate))
    {
      startDate <- cfgLst$startDate;
    }
  
  if (is.null(endDate))
    {
      endDate <- cfgLst$endDate;
    }
  
  utils.checkCond(startDate <= endDate, paste("startDate(", startDate, ") must be no later than endDate(", endDate, ")"));
  startDate <- date.convert(startDate, format="YYYYMMDD");
  endDate   <- date.convert(  endDate, format="YYYYMMDD");
  dates     <- date.convert(date.range(date.toBusDate(startDate,-5, region=cfgLst$region),endDate, region=cfgLst$region), format="YYYYMMDD");


  if (is.null(cfgLst$dataLst))
    {
      cfgLst$dataLst <- list();
    }
  
  utils.log("Load dataLst Start:");
  for (date in dates)
    {
      cat(date);
      dateL1          <- date.convert(date.toBusDate(date, shift=-1, region=cfgLst$region),format="YYYYMMDD");
      betaDf          <- beta   (startDate=dateL1, endDate=dateL1,   region=cfgLst$region)[ ,c("jtid", "beta", "residStdErr")];
      mdDf            <- mktData(startDate=date,   endDate=date,     region=cfgLst$region, vars=c("prevClose", "close", "volume", "vwap", "value"));
      msDf            <- mktStat(startDate=dateL1, endDate=dateL1,   region=cfgLst$region)[, c("jtid", "mktCap", "atv5d", "mtv5.60d")];
      df              <- merge(mdDf, betaDf, by="jtid");
      df              <- merge(df, msDf, by="jtid");
      cfgLst$dataLst[[date]] <- df;
      cat("\b\b\b\b\b\b\b\b");
    }
  cat ("\n"); utils.log("Load Data Done!\n");
  invisible(cfgLst);
}
