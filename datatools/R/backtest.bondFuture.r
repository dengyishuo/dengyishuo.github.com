##' backtest main function for the bondfuture
##'
##' backtest main function for the bondfuture
##' @title backtest main function for the bondfuture
##' @param cfgLst configuration file
##' @return list
##' @importFrom quantutils p utils.readCSV date.convert df.rbindList
##' @importFrom zoo na.locf 
##' @export
##' @author Weilin Lin
##' 
backtest.bondFuture <- function(cfgLst){  
     mktDf  <- cfgLst$mktDf;
     sigDf  <- cfgLst$sigDf;
     dataDf <- merge(sigDf[,c("contract","date","time",cfgLst$signalVar)], mktDf[,c("contract","date","time","LastPx","ret")], all=TRUE);
     ## append the signal NA     
     dataDf[[cfgLst$signalVar]] <- na.locf(dataDf[[cfgLst$signalVar]], na.rm=FALSE);
     dataDf[[cfgLst$signalVar]][is.na(dataDf[[cfgLst$signalVar]])] <- 0;
     
     # make EOD signal zero
     dataLst <- split(dataDf, dataDf$date);
     dataLst <- lapply(dataLst, function(dailyDf){
         dailyDf <- dailyDf[order(dailyDf$time),];
         dailyDf[nrow(dailyDf),cfgLst$signalVar] <- 0;
         return(dailyDf);
     })     
     dataDf        <- df.rbindList(dataLst);
     dataDf$ret[is.na(dataDf$ret)] <- 0;     
     ## calculate the return
     dataDf$cumRet      <- cumsum(dataDf$ret*dataDf[[cfgLst$signalVar]]);
     dataDf$indexCumRet <- cumsum(dataDf$ret);
     sumDf              <- dataDf[,c("contract","date","time",cfgLst$signalVar,
                                     "ret","cumRet","indexCumRet")];
     cfgLst$sumDf       <- sumDf;
     return(cfgLst);
}
