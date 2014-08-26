##' read HFT data from database
##'
##' read HFT data from database
##' @title read HFT data from database
##' @param startDate 
##' @param endDate 
##' @param securityID 
##' @param vars 
##' @return data frame
##' @importFrom quantutils p utils.readCSV date.convert 
##' @export
##' @author Weilin Lin
##' 
mktDataHFT  <- function(startDate, endDate=startDate,securityID=NULL,vars=NULL){    
  startDate <- date.convert(startDate, format="YYYYMMDD");
  endDate   <- date.convert(endDate,   format="YYYYMMDD");
  sqlStr    <- p("SELECT * FROM hft.hft WHERE date>='",startDate,"' AND date<='",endDate,"'");
  if(!is.null(securityID)){
      sqlStr <- p(sqlStr, " AND SecurityID in (",p(p("'",securityID,"'"), collapse=","),")");
  }
  
  sqlStr    <- p(sqlStr," ORDER BY date"); 
  mktDf     <- dbGetQuery(DBChannel.sigmaTF, sqlStr);
  mktDf     <- subset(mktDf, LastPx>0);
  mktDf     <- mktDf[order(mktDf$SecurityID, mktDf$date, mktDf$TradeTime), ];
  flags     <- p(mktDf$SecurityID,"_",mktDf$date,"_",mktDf$TradeTime);
  mktDf     <- mktDf[!duplicated(flags), ];
  
  ## calculate return of securities.
  mktDataLst <- split(mktDf, mktDf$SecurityID);
  mktDataLst <- lapply(mktDataLst, function(df){
         n         <- nrow(df);
         df$ret    <- c(0,(df$LastPx[2:n]-df$LastPx[1:(n-1)])/df$LastPx[1:(n-1)]);
         df$logRet <- c(0,(log(df$LastPx[2:n])-log(df$LastPx[1:(n-1)])));
         return(df);         
      });
  mktDf <- df.rbindList(mktDataLst);
  
  if(!is.null(vars)) {
      vars      <- c("SecurityID","date","TradeTime",vars);  
      mktDf     <- mktDf[,vars];
  }else{
      vars      <- c("SecurityID","date","TradeTime",setdiff(colnames(mktDf),c("SecurityID","date","TradeTime")));
      mktDf     <- mktDf[,vars];
  }
  invisible(mktDf);
}


