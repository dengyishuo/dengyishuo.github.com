##' universe
##'
##' universe
##' @title univ
##' @param startDate 
##' @param endDate 
##' @param univType 
##' @param univRange 
##' @param region 
##' @param inDir 
##' @param daysUsedToSmooth 
##' @param ... 
##' @return data frame
##' @export
##' @author Weilin Lin
univ <- function(startDate, endDate=startDate, univType="liquidityBased", univRange=c(0,1), region, inDir=NULL, daysUsedToSmooth=10, ...)
{
  if (is.null(inDir))
    inDir <- p(DATA.DIR, "alpha/", tolower(region), "/daily/derived/univ");

  univLst <- list()
  if (univType=="CSI300" & region=="CN")
    {
      lst <- index(date.toBusDate(startDate, shift=-1, region=region), date.toBusDate(endDate, shift=-1,region=region), indexID="CN000300", region=region, outClass="list");
      names(lst) <- date.convert(date.toBusDate(names(lst), shift=1, region=region), format="YYYYMMDD");
      for (date in sort(names(lst)))
        {
          univLst[[date]] <- lst[[date]][,"jtid"];
        }
    }
  else if(univType=='Fixed' & region=="HK"){
     univDf <- read.csv('/home/amg/data/hk/indMap/Gics.csv')
     univDf$jtid <- keyMap(univDf$SEDOL,inputKeyType='SEDOL',outputKeyType='JTID',region=region)
     univDf <- univDf[!is.na(univDf$jtid),]
     dates   <- date.convert(date.range(startDate, endDate, region=region), format="YYYYMMDD");
     for(date in dates)
         univLst[[date]] <- univDf[,"jtid"]
     
  }
  else if (univType %in% c("trdUniv", "estUniv", "dataUniv", "liquidityBased"))
    {
      if      (univType=="trdUniv")   univRange <- c(0.55, 1)
      else if (univType=="estUniv")   univRange <- c(0.40, 1)
      else if (univType=="dataUniv")  univRange <- c(0.25, 1);
                
      ub <- max(univRange);
      lb <- min(univRange);
      dataStartDate <- date.convert(date.toBusDate(startDate, shift=-daysUsedToSmooth+1, region=region),format="YYYYMMDD");
      lst           <- utils.readCSV(startDate=dataStartDate, endDate=endDate, region=region, dataDir=inDir, filePrefix="univ", outClass="list", ...);  
      for (date in names(lst))
        {
          df          <- lst[[date]];
          lst[[date]] <- df[which(df$liquidityScore > lb & df$liquidityScore <= ub) ,"jtid"];
        }

      for (date in date.convert(date.range(startDate=startDate,endDate=endDate, region=region),format="YYYYMMDD"))
        {
          dates           <- date.convert(date.range(date.toBusDate(date, shift=-daysUsedToSmooth+1,region=region), date, region=region),format="YYYYMMDD");
          univLst[[date]] <- sort(utils.intersectList(lst[dates]));
        }
    }
  else
    stop ("ERROR: unsupported univType:", univType);
  invisible(univLst);
}
