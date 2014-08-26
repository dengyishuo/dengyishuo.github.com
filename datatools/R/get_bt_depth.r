##' Read bitcoin depth data
##'
##' Read bitcoin depth data
##' @title Read bitcoin depth data
##' @param starttime The starttime of Data
##' @param endtime The endtime of Data
##' @param vars variables in data
##' @return An dataframe
##' @importFrom quantutils datetime2num datetime2POSIXlt
##' @export 
##' @author Yishuo Deng

get_bt_depth <- function(starttime="2013-12-08 10:22:32",endtime="2013-12-09 00:00:00",vars="*"){
  if(!is.null(starttime)&&!is.null(endtime)){
    starttime <- datetime2num(starttime);
    endtime <- datetime2num(endtime);
    if(unique(vars!="*")){
      query <- paste("select datetime,", paste(vars,collapse=",")," from bondFuture.t_btc_china_depth ","where datetime>=",starttime," and datetime<=",endtime,sep="")
    }
    else{
      query <- paste("select ",vars," from bondFuture.t_btc_china_depth ","where datetime>=",starttime," and datetime<=",endtime,sep="")
    }
  }
  else{
    if(uniqure(vars!="*")){
      query <- paste("select datetime,",paste(vars,collapse=",")," from bondFuture.t_btc_china_depth",sep="")
    }
    else {
      query <- paste("select ",vars," from bondFuture.t_btc_china_depth",sep="")
    }
    
  }
  
  depth <- dbGetQuery(DBChannel_APE,query);
  depth$datetime <- datetime2POSIXlt(depth$datetime);
  invisible(depth)
}