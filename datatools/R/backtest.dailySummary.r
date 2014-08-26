##' daily summary for backtest result
##'
##' daily summary for backtest result
##' @title daily summary for backtest result
##' @param hldDf hldDf
##' @return data frame
##' @export
##' @author Weilin Lin
backtest.dailySummary <- function(hldDf)
{
  navLst <- list()
  for (date in sort(unique(hldDf$date)))
    {        
      df                  <- hldDf[which(hldDf$date==date),];
      navDf               <- data.frame(date=date);
      navDf$numStocks     <- sum(df$shsHldEOD!=0);      
      navDf$ntnlHldBOD    <- sum(abs(df$ntnlHldBOD));
      navDf$netNtnlHldBOD <- sum(df$ntnlHldBOD);
      navDf$ntnlBetaBOD   <- sum(df$betaNtnlBOD);
      navDf$ntnlHldEOD    <- sum(abs(df$ntnlHldEOD));
      navDf$ntnlBetaEOD   <- sum(df$ntnlBetaEOD);
      navDf$ntnlTrd       <- sum(abs(df$ntnlTrd));
      navDf$netNtnlTrd    <- sum(df$ntnlTrd);
      navDf$indexRet      <- mean(df$indexRet);
      navDf$hldPnL        <- sum(df$hldPnL);
      navDf$trdPnL        <- sum(df$trdPnL);
      navDf$PnL           <- sum(df$PnL);
      navDf$betaPnL       <- sum(df$betaPnL);
      navDf$betaAdjPnL    <- sum(df$betaAdjPnL);
      navLst[[date]]      <- navDf;
    }

  navDf <- df.rbindList(navLst);
  navDf <- navDf[order(navDf$date),];
  invisible(navDf);
}
