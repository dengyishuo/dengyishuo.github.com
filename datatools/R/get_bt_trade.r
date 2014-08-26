##' Read bitcoin trade data
##'
##' Read bitcoin trade data
##' @title Read bitcoin trade data
##' @param starttime The starttime of Data
##' @param endtime The endtime of Data
##' @param vars variables in data
##' @return An dataframe
##' @importFrom quantutils datetime2num datetime2POSIXlt
##' @export 
##' @author Yishuo Deng

get_bt_trade <- function(starttime="2013-12-09 00:00:00",endtime="2013-12-09 00:25:30",vars="*"){
  if(!is.null(starttime)&&!is.null(endtime)){
    starttime <- datetime2num(starttime);
    endtime <- datetime2num(endtime);
    if(unique(vars!="*")){
      query <- paste("select DATETIME,", paste(vars,collapse=",")," from bondFuture.t_btc_china_trade ","where DATETIME>=",starttime," and DATETIME<=",endtime,sep="")
    }
    else{
      query <- paste("select ",vars," from bondFuture.t_btc_china_trade ","where DATETIME>=",starttime," and DATETIME<=",endtime,sep="")
    }
  }
  else{
    if(uniqure(vars!="*")){
      query <- paste("select DATETIME,",paste(vars,collapse=",")," from bondFuture.t_btc_china_trade",sep="")
    }
    else {
      query <- paste("select ",vars," from bondFuture.t_btc_china_trade",sep="")
    }
    
  }
  trade <- dbGetQuery(DBChannel_APE,query);
  trade$DATETIME <- datetime2POSIXlt(trade$DATETIME);
  invisible(trade)
}