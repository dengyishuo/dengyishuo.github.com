##' load data for bond future HFT strategy
##'
##' load data for bond future HFT strategy
##' @title load data for bond future HFT strategy
##' @param cfgLst configuration list object for the backtesting
##' @return list
##' @export
##' @importFrom quantutils p utils.readCSV date.convert 
##' @author Weilin Lin
##' 
backtest.loadData.bondFuture <- function(cfgLst){
    sigDf         <- cfgLst$sigDf;
    dataStartDate <- min(sigDf$date);
    dataEndDate   <- max(sigDf$date);    
    mktDf         <- mktDataHFT(startDate = dataStartDate, endDate = dataEndDate, jtids =  "TF1312",vars=c("LastPx","LastVolumnTrade","ret"));    
    colnames(mktDf)  <- c("contract","date","time","LastPx","LastVolumnTrade","ret");
    cfgLst$mktDf     <- mktDf;
    
    ## adjust startDate and EndDate
    startDate     <- cfgLst$startDate;
    endDate       <- cfgLst$endDate;
    startDate     <- ifelse(is.null(startDate), dataStartDate ,startDate);
    endDate       <- ifelse(is.null(endDate),   dataEndDate,  endDate);
    startDate     <- date.convert(date.toBusDate(startDate, region="CN"), format = "YYYYMMDD");
    endDate       <- date.convert(date.toBusDate(endDate,   region="CN"), format = "YYYYMMDD");
    utils.checkCond(startDate>=dataStartDate, "startDate should be bigger than min of sigDf date");
    utils.checkCond(endDate<=dataEndDate, "endDate should be smaller than max of sigDf date");
    cfgLst$startDate <- startDate;
    cfgLst$endDate   <- endDate;
    return(cfgLst);
}
