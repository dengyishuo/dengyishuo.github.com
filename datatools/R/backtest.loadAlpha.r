##' load alpha data for backtesting
##'
##' load alpha data for backtesting
##' @title load alpha data for backtesting
##' @param startDate startDate for backtesting
##' @param endDate endDate for backtesting
##' @param cfgLst configuration file for backtesting
##' @export 
##' @return cfgLst
##' @author Weilin Lin
backtest.loadAlpha <- function(startDate=NULL, endDate=NULL, cfgLst)
{    
  alphaFiles <- sort(list.files(cfgLst$alphaDir, pattern=p(cfgLst$alphaFilePrefix, "_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"), full.names=TRUE));
#  dates      <- sort(unique(utils.substring(alphaFiles, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]")));
  dates <- date.convert(date.range(cfgLst$startDate,cfgLst$endDate,region=cfgLst$region),format="YYYYMMDD")
  if (!is.null(cfgLst$tradingDatesFile))
    {
      tradingDates <- date.toString(read.csv(cfgLst$tradingDatesFile)[[1]]);
      tradingDates <- date.convert(date.toBusDate(tradingDates, region="CN"), format="YYYYMMDD");      
      dates        <- sort(intersect(dates, tradingDates));
    }
  
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
  dates     <- sort(dates[which(dates>=startDate & dates<=endDate)]);
 if (is.null(cfgLst$alphaLst))
    {
      cfgLst$alphaLst <- list();
    }

  cfgLst$alphaLst[dates]  <- utils.readCSVBus(startDate=startDate, endDate=endDate, dataDir=cfgLst$alphaDir, filePrefix=cfgLst$alphaFilePrefix, region=cfgLst$region, outClass="list")[dates];
  

  ## replicate alphas for dates not in the trading dates file
  if (!is.null(cfgLst$tradingDatesFile))
    {
      dates <- date.toString(date.range(startDate, endDate, region="CN"));
      for (date in dates)
        {
          lastTradingDate         <- tail(tradingDates[tradingDates<=date],1);
          df                      <- cfgLst$alphaLst[[lastTradingDate]];
          df$date                 <- date;
          cfgLst$alphaLst[[date]] <- df;
        }
    }
  invisible(cfgLst);
}
