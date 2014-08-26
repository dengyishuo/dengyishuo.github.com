##' volatility of stocks 
##'
##' volatility of stocks 
##' @title volatility of stocks 
##' @param startDate 
##' @param endDate 
##' @param jtids 
##' @param vars 
##' @param region 
##' @param inDir 
##' @param ... 
##' @return data framme
##' @importFrom quantutils p utils.readCSV
##' @export
##' @author Weilin Lin
volatility <- function(startDate, endDate=startDate, jtids=NULL, vars=NULL,region="CN",inDir=NULL,...)
  {
   if (is.null(inDir))
    inDir <- p(DATA.DIR, "/alpha/", tolower(region), "/daily/derived/volatility");
   dailyDf <- utils.readCSV(jtids, startDate=startDate, endDate=endDate, vars=vars, region=region, dataDir=inDir, filePrefix="vol",...);   
    invisible(dailyDf);  
  }
