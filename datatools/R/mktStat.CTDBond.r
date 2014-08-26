##' Statistics of the deliverable bonds 
##'
##' Statistics of the deliverable bonds 
##' @title Statistics of the deliverable bonds 
##' @param startDate startDate of the data 
##' @param endDate endDate of the data
##' @param contract specify the contract 
##' @param region equal to CN
##' @param inDir 
##' @param jtids 
##' @param vars 
##' @param onlyCTD 
##' @param ... 
##' @return data frame
##' @importFrom quantutils p utils.readCSV df.rbindList
##' @export
##' @author Weilin Lin
mktStat.CTDBond <- function(startDate, endDate=startDate, contract=NULL, region="CN",inDir=NULL,jtids=NULL,vars=NULL,onlyCTD=FALSE,...){  
  if (is.null(inDir))
    inDir <- p(YTM.DATA.DIR,"/",tolower(region),"/daily/derived/mktStatCTD");
  dailyDf <- utils.readCSV(jtids, startDate=startDate, endDate=endDate, vars=vars, region=region, dataDir=inDir, filePrefix="mktStatCTD",...);
  dailyDf <- subset(dailyDf,!is.na(futureSettle));
  if(!is.null(contract)) dailyDf <- dailyDf[dailyDf$contract==contract,];
  if(onlyCTD){
    lst <- split(dailyDf, dailyDf$date);
    lst <- lapply(lst, function(df){
      df <- df[order(df$impliedRepo, decreasing=TRUE),];
      df <- df[1,];
      })
    dailyDf <- df.rbindList(lst);    
  }
  invisible(dailyDf);    
}
