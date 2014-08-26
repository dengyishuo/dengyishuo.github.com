##' simple rebalance function for backtesting
##'
##' simple rebalance function for backtesting
##' @title simple rebalance function for backtesting
##' @param hldDf holding data frame
##' @param alphaDf alpha data frame
##' @param dataDf data frame
##' @param univVec univ vector
##' @param cfgLst configuration 
##' @return cfgLst
##' @export
##' @author Weilin Lin
backtest.simpleRebalance <- function(hldDf, alphaDf, dataDf, univVec, cfgLst)
{    
  date          <- sort(unique(alphaDf$date));  
  tmpDf         <- na.exclude(alphaDf[which(alphaDf$jtid %in% univVec | alphaDf$jtid %in% hldDf$jtid), c("jtid", "date", cfgLst$alphaVar)]);
  tmpDf         <- tmpDf[which(tmpDf$jtid %in% dataDf$jtid[dataDf$volume>0]),];   ## get rid non-tradable stocks for the given date
  tmpDf         <- tmpDf[order(tmpDf[[cfgLst$alphaVar]]), ];  
  nStocks       <- nrow(tmpDf);
  nInStocks     <- cfgLst$tradeInThreshold;  
  nOutStocks    <- cfgLst$tradeOutThreshold;
  
  if (cfgLst$portType=="LS")
    {
      mustLongIDs   <- tmpDf[(nStocks - nInStocks+1) : nStocks,                "jtid"];
      keepLongIDs   <- tmpDf[ (nStocks-nOutStocks+1) : (nStocks - nInStocks),  "jtid"];
      reduceZeroIDs <- tmpDf[         (nOutStocks+1) : (nStocks - nOutStocks), "jtid"];
      keepShortIDs  <- tmpDf[          (nInStocks+1) : nOutStocks,             "jtid"];
      mustShortIDs  <- tmpDf[                      1 : nInStocks,              "jtid"];
    }
  else if (cfgLst$portType=="L")
    {
      utils.checkCond((nInStocks>=1) & (nInStocks<nOutStocks), "Wrong tradeInThreshold or tradeOutThreshold setting");  
      mustLongIDs   <- tmpDf[(nStocks - nOutStocks+1) : (nStocks - nInStocks+1), "jtid"];
      
      if(nInStocks>1){
          topExtraIDs   <-  tmpDf[(nStocks-nInStocks+2):nStocks,"jtid"];          
      }else if(nInStocks==1){
          topExtraIDs <- NULL;
      }else{
          stop("ERROR: Wrong tradeInThreshold setting");
      }
      
      reduceZeroIDs <- c(tmpDf[1:(nStocks - nOutStocks), "jtid"],topExtraIDs);      
      keepShortIDs  <- NULL;
      mustShortIDs  <- NULL;
    }
  else if (cfgLst$portType=="S")
    {
      mustLongIDs   <- NULL;
      keepLongIDs   <- NULL;
      reduceZeroIDs <- tmpDf[         (nOutStocks+1) : nStocks,                "jtid"];
      keepShortIDs  <- tmpDf[          (nInStocks+1) : nOutStocks,             "jtid"];
      mustShortIDs  <- tmpDf[                      1 : nInStocks,              "jtid"];
    }
  reduceZeroIDs <- sort(unique(c(reduceZeroIDs, setdiff(hldDf$jtid, tmpDf$jtid),setdiff(hldDf$jtid,mustLongIDs))));   ## get rid of position if the stock is not in the universe AND those not on the top.

  if (cfgLst$portType=="L")
    {
      newIDs    <- setdiff(mustLongIDs, hldDf$jtid);
    }
  else if (cfgLst$portType=="S")
    {
      newIDs    <- setdiff(mustShortIDs, hldDf$jtid);
    }
  else if (cfgLst$portType=="LS")
    {
      newIDs    <- setdiff(c(mustLongIDs, mustShortIDs), hldDf$jtid);
    }
  else
    stop("ERROR: unsupported portfolio type:", cfgLst$portType);

  hldDf <- rbind(hldDf, data.frame(jtid=newIDs, date=rep(date, length(newIDs)), shsHldBOD=rep(0, length(newIDs)), ntnlHldBOD=rep(0, length(newIDs))));
  hldDf <- merge(hldDf, dataDf[, c("jtid", "prevClose",  "beta", "residStdErr", "mktCap", "atv5d", "mtv5.60d", "vwap")] , by="jtid",  all.x=TRUE);
  hldDf <- merge(hldDf, alphaDf[, c("jtid", cfgLst$alphaVar)], by="jtid", all.x=TRUE);

  ## handle missing data
  hldDf$prevClose   <- ifelse(is.na(hldDf$prevClose),   hldDf$ntnlHldBOD/hldDf$shsHldBOD, hldDf$prevClose);
  hldDf$vwap        <- ifelse(is.na(hldDf$vwap),        hldDf$ntnlHldBOD/hldDf$shsHldBOD, hldDf$vwap);
  hldDf$beta        <- ifelse(is.na(hldDf$beta),        1, hldDf$beta);
  hldDf$residStdErr <- ifelse(is.na(hldDf$residStdErr), max(hldDf$residStdErr, na.rm=TRUE), hldDf$residStdErr);
  hldDf$mktCap      <- ifelse(is.na(hldDf$mktCap),      0, hldDf$mktCap);
  hldDf$atv5d       <- ifelse(is.na(hldDf$atv5d),       0, hldDf$atv5d);
  hldDf$mtv5.60d    <- ifelse(is.na(hldDf$mtv5.60d),    0, hldDf$mtv5.60d);
  hldDf$multiplier  <- rep(1, nrow(hldDf));
  
  ## create weights
  if (cfgLst$portWgt=="alpha*mktCap/residStdErr^2")
    {
      multiplier <- hldDf[[cfgLst$alphaVar]] * hldDf$mktCap / hldDf$residStdErr^2;
    }
  else if (cfgLst$portWgt=="alpha*log(mktCap)/residStdErr^2")
    {
      multiplier <- hldDf[[cfgLst$alphaVar]] * log(hldDf$mktCap) / hldDf$residStdErr^2;
    }
  else if (cfgLst$portWgt == 'log(mktCap)')
  {
     multiplier <- log(hldDf$mktCap);
  }
   else if (cfgLst$portWgt == 'mktCap')                                                                                                                                        
   {                                                                                                                                                                                
          multiplier <- hldDf$mktCap;                                                                                                                                              
   }          
  else if (cfgLst$portWgt=="eq")
    {
      multiplier <- rep(1, nrow(hldDf));
    }
  else
    stop("ERROR: unsupported weighting scheme:", cfgLst$portWgt);

  ## set target EOD positions
  row.names(hldDf) <- hldDf$jtid;
  if (cfgLst$portType=="L")
    {
      ii <- which(hldDf$jtid %in% mustLongIDs);
      hldDf[ii, "multiplier"] <- multiplier[ii] / sum(multiplier[ii], na.rm=T) * length(ii);
      hldDf$shsHldEOD  <- ifelse(hldDf$jtid %in% mustLongIDs & hldDf$shsHldBOD<=0, floor(cfgLst$investSizePerStock * hldDf$multiplier/hldDf$vwap), hldDf$shsHldBOD);      
      hldDf$shsHldEOD  <- ifelse(hldDf$jtid %in% c(reduceZeroIDs, keepShortIDs, mustShortIDs), 0, hldDf$shsHldEOD);
    }
  else if (cfgLst$portType=="S")
    {
      ii <- which(hldDf$jtid %in% mustShortIDs);
      hldDf[ii, "multiplier"] <- multiplier[ii] / sum(multiplier[ii], na.rm=T) * length(ii);
      hldDf$shsHldEOD  <- ifelse(hldDf$jtid %in% mustShortIDs & hldDf$shsHldBOD>=0, -floor(cfgLst$investSizePerStock * hldDf$multiplier/hldDf$vwap), hldDf$shsHldBOD);
      hldDf$shsHldEOD  <- ifelse(hldDf$jtid %in% c(mustLongIDs, keepLongIDs, reduceZeroIDs), 0, hldDf$shsHldEOD);
    }
  else if (cfgLst$portType=="LS")
    {
      ii <- which(hldDf$jtid %in% mustLongIDs);
      hldDf[ii, "multiplier"] <- multiplier[ii] / sum(multiplier[ii], na.rm=T) * length(ii);
      hldDf$shsHldEOD  <- ifelse(hldDf$jtid %in% mustLongIDs & hldDf$shsHldBOD<=0, floor(cfgLst$investSizePerStock * hldDf$multiplier/hldDf$vwap), hldDf$shsHldBOD);
      
      ii <- which(hldDf$jtid %in% mustShortIDs);
      hldDf[ii, "multiplier"] <- multiplier[ii] / sum(multiplier[ii], na.rm=T) * length(ii);
      hldDf$shsHldEOD  <- ifelse(hldDf$jtid %in% mustShortIDs & hldDf$shsHldBOD>=0, -floor(cfgLst$investSizePerStock * hldDf$multiplier/hldDf$vwap), hldDf$shsHldEOD);

      hldDf$shsHldEOD <- ifelse(hldDf$jtid %in% reduceZeroIDs, 0, hldDf$shsHldEOD);
      hldDf$shsHldEOD <- ifelse(hldDf$jtid %in% keepLongIDs    & hldDf$shsHldBOD<0,  0, hldDf$shsHldEOD);
      hldDf$shsHldEOD <- ifelse(hldDf$jtid %in% keepShortIDs   & hldDf$shsHldBOD>0,  0, hldDf$shsHldEOD);
    }

  hldDf               <- hldDf[order(hldDf$jtid), c("jtid", "date", "shsHldBOD", "ntnlHldBOD", "shsHldEOD", cfgLst$alphaVar)];
  invisible(hldDf);
}
