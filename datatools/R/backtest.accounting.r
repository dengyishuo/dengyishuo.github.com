##' backtest.accounting
##'
##' backtest.accounting
##' @title backtest.accounting
##' @param hldDf hldDf
##' @param dataDf dataDf
##' @param cfgLst cfg list
##' @export
##' @return data frame  
##' @author Weilin Lin
backtest.accounting <- function(hldDf, dataDf, cfgLst)
{
  date              <- unique(hldDf$date);  
  indexDf           <- mktData(startDate=date, endDate=date, jtids=cfgLst$indexID, vars="ret",region=cfgLst$region);

  ## load data and handle missing
  hldDf             <- merge(hldDf, dataDf[, c("jtid", "prevClose", "close", "vwap", "value", "volume","beta")], all.x=TRUE);
  hldDf$indexRet    <- indexDf$ret;
  hldDf$close       <- ifelse(is.na(hldDf$close),       hldDf$ntnlHldBOD/hldDf$shsHldBOD, hldDf$close);
  hldDf$avgTrdPrc   <- ifelse(is.na(hldDf$vwap),        hldDf$close, hldDf$vwap);
  hldDf$volume      <- ifelse(is.na(hldDf$volume),      0, hldDf$volume);
  hldDf$prevClose   <- ifelse(is.na(hldDf$prevClose),   hldDf$ntnlHldBOD/hldDf$shsHldBOD, hldDf$prevClose);
  hldDf$beta        <- ifelse(is.na(hldDf$beta),        1, hldDf$beta);

  ## create shsTrd and EOD positions
  hldDf$shsTrd      <- hldDf$shsHldEOD - hldDf$shsHldBOD;  
  # NOTICE: if volume==0, we will not be able to sell out that stock!
  #hldDf$shsTrd      <- sign(hldDf$shsTrd) * pmin(abs(hldDf$shsTrd), hldDf$volume * cfgLst$volumeParticipationLimit);  
  hldDf$shsTrd      <- round(hldDf$shsTrd/cfgLst$tradeLot)*cfgLst$tradeLot;                                                  ## round lot shares traded
  hldDf$shsTrd      <- ifelse(abs(hldDf$shsHldBOD + hldDf$shsTrd) < cfgLst$tradeLot, -hldDf$shsHldBOD, hldDf$shsTrd);        ## clear small stock positions from the book (i.e, less than tradeLot many shares)
  
  hldDf$shsHldEOD   <- hldDf$shsHldBOD   + hldDf$shsTrd;
  hldDf$ntnlHldEOD  <- hldDf$shsHldEOD   * hldDf$close;
  hldDf$ntnlTrd     <- hldDf$shsTrd      * hldDf$avgTrdPrc;
  hldDf$hldPnL      <- hldDf$shsHldBOD   * (hldDf$close - hldDf$prevClose);
  hldDf$trdPnL      <- hldDf$shsTrd      * (hldDf$close - hldDf$avgTrdPrc);
  hldDf$PnL         <- hldDf$hldPnL      + hldDf$trdPnL;
  hldDf$ntnlBetaBOD <- hldDf$ntnlHldBOD  * hldDf$beta;
  hldDf$ntnlBetaEOD <- hldDf$ntnlHldEOD  * hldDf$beta;
  hldDf$betaPnL     <- hldDf$ntnlBetaBOD * hldDf$indexRet;
  hldDf$betaAdjPnL  <- hldDf$PnL - hldDf$betaPnL;
  hldDf             <- hldDf[order(hldDf$jtid),];
  hldDf             <- hldDf[which(abs(hldDf$ntnlHldBOD)>0 | abs(hldDf$ntnlHldEOD)>0),];
  invisible(hldDf);
}
