##' read HFT data from database
##'
##' read HFT data from database
##' @title read HFT data from database
##' @param startDate 
##' @param endDate 
##' @param jtids 
##' @param vars 
##' @return data frame
##' @importFrom quantutils p utils.readCSV date.convert 
##' @export
##' @author Weilin Lin
##' 
mktDataHFT.CB  <- function(startDate, endDate=startDate,jtids=NULL,vars=NULL){    
  startDate <- date.convert(startDate, format="YYYYMMDD");
  endDate   <- date.convert(endDate,   format="YYYYMMDD");
  sqlStr    <- p("SELECT * FROM hft.hft WHERE date>='",startDate,"' AND date<='",endDate,"'");
  if(!is.null(jtids)){
      sqlStr <- p(sqlStr, " AND SecurityID in (",p(p("'",jtids,"'"), collapse=","),")");
  }
  
  sqlStr    <- p(sqlStr," ORDER BY date"); 
  mktDf     <- dbGetQuery(DBChannel, sqlStr);
  mktDf     <- subset(mktDf, LastPx>0);
  mktDf     <- mktDf[order(mktDf$date, mktDf$TradeTime), ];
  flags     <- p(mktDf$date,"_",mktDf$TradeTime);
  mktDf     <- mktDf[!duplicated(flags), ];
  ## calculate return of bond future.
  n         <- nrow(mktDf);
  mktDf$ret <- c(0,(mktDf$LastPx[2:n]-mktDf$LastPx[1:(n-1)])/mktDf$LastPx[1:(n-1)]);
  mktDf$logRet <- c(0,(log(mktDf$LastPx[2:n])-log(mktDf$LastPx[1:(n-1)])));
  if(!is.null(vars)) {
      vars      <- c("SecurityID","date","TradeTime",vars);  
      mktDf     <- mktDf[,vars];
  }else{
      vars      <- c("SecurityID","date","TradeTime",setdiff(colnames(mktDf),c("SecurityID","date","TradeTime")));
      mktDf     <- mktDf[,vars];
  }
  invisible(mktDf);
}


