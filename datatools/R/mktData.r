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
##' @param source
##' @param ... other parametres 
##' @return An OHLC files
##' @importFrom quantutils p utils.readCSV utils.readMySQL
##' @export 
##' @author Weilin Lin

mktData <- function(startDate, endDate = startDate, jtids = NULL, vars = NULL, region = "CN", inDir = NULL, source="MySQL", ...) {
    if(source=="CSV"){
        if (is.null(inDir)) {
             inDir <- p(DATA.DIR, "alpha",tolower(region), "daily/raw/mktData",sep="/")
             dailyDf <- utils.readCSV(jtids, startDate = startDate, endDate = endDate, vars = vars, region = region, dataDir = inDir, filePrefix = "mktData",stringsAsFactors=FALSE, ...)
		}
    }
    else 
         dailyDf <- utils.readMySQL(tablename = "daily.mktData", startDate = startDate, endDate = endDate, jtids = jtids, vars = vars, region = region, ...);
		 invisible(dailyDf)
}