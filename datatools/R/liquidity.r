##' Read liquidity data of bond
##'
##' Read liquidity data of bond
##' @title Read liquidity data of bond
##' @param startDate The startDate of Data
##' @param endDate The endDate of Data
##' @param jtids symbols
##' @param vars variables in data
##' @param region region for data
##' @param inDir file direction for writing in  
##' @param ... other params
##' @return data frame
##' @importFrom quantutils p utils.readCSV utils.readMySQL
##' @export 
##' @author Weilin Lin
liquidity <- function(startDate, endDate=startDate, jtids=NULL, vars=NULL, region="CN", inDir=NULL, ...){
  if (is.null(inDir))
    inDir <- p(YTM.DATA.DIR, "/", tolower(region), "/daily/derived/liquidity");
  dailyDf <- utils.readCSV(jtids, startDate=startDate, endDate=endDate, vars=vars, region=region, dataDir=inDir, filePrefix="liquidity",...);
  invisible(dailyDf);    
}
