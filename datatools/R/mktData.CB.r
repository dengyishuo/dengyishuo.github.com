##' Read data from our server
##'
##' Read market data of A share and HK market stock data from server
##' @title Read data from our server
##' @param startDate The startDate of Data
##' @param endDate The endDate of Data
##' @param jtids symbols 
##' @param vars variables in data
##' @param region region for data
##' @param inDir file direction for writing in  
##' @param ... other parametres 
##' @return An OHLC files
##' @importFrom quantutils p utils.readCSV
##' @export 
##' @author Weilin Lin

mktData.CB <- function(startDate, endDate=startDate, jtids=NULL, vars=NULL, region="CN",inDir=NULL, ...)
{
  if (is.null(inDir))
    inDir <- p(CB.DATA.DIR, "/", tolower(region), "/daily/raw/mktData");
  dailyDf <- utils.readCSV(jtids, startDate=startDate, endDate=endDate, vars=vars, region=region, dataDir=inDir, filePrefix="mktData",...);
  invisible(dailyDf);
}


