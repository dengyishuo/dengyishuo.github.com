##'  Get CTD information
##'
##' Get CTD information
##' @title Get CTD information
##' @param startDate 
##' @param endDate 
##' @param market 
##' @param contract 
##' @param onlyCTD 
##' @param ifplot 
##' @return data frame and plot
##' @importFrom quantutils p utils.readCSV df.rbindList
##' @export
##' @author Weilin Lin
##' 
getCTD <- function(startDate, endDate, market="IB",contract,onlyCTD=TRUE, ifplot=TRUE){    
      data    <- mktStat.CTDBond(startDate, endDate,contract=contract);
        markets <- substring(data$jtid, 10,13);
        data    <- data[markets==market, ];
        if(onlyCTD){
                lst  <- split(data, data$date);
                    lst  <- lapply(lst, function(df){
                              df <- df[df$atv1d>0, ];
                                    df <- df[order(df$impliedRepo, decreasing=TRUE),];
                                    df <- df[1,];
                          })
                    data <- df.rbindList(lst);
            }
        if(ifplot){
                    ii   <-  seq(1, nrow(data), by=max(round(nrow(data)/6/20)*20,10));
                    ii   <-  unique(c(ii, nrow(data)));                    
                    data <-  data[!is.na(data$jtid),];
                    n    <-  nrow(data);
                    mainStr = p(contract,"(",data$date[n],")",",Valuation Calculated IRR:",
                                round(100*data$impliedRepo[n],2),"%",
                                ", diff:",round(100*(data$impliedRepo[n]-data$impliedRepo[n-1]),2),"%");
    
                    plot(100*data$impliedRepo, main=mainStr, ylab="(%)", ty="o",xlab="date",xaxt="n",lwd=1.5,col="blue");
                    abline(v=ii, lty=2);
                    axis(1, at=ii, labels=data$date[ii], las=0);
                    grid();
                    ## add timeseries of Treasury futures'price and the valuation of bonds
                    retDf <- data[,c("futureSettle","ValueCleanPrice")];
                    tmpDf <- (retDf[2:nrow(retDf),]-retDf[1:(nrow(retDf)-1),])/retDf[1:(nrow(retDf)-1),];
                    retDf[1,] <- 0;
                    retDf[2:nrow(retDf),] <- tmpDf;
                    cumRetDf <- cumprod(1+retDf);
                    par(new=TRUE);
                    plot(cumRetDf$futureSettle,type="o",col="red",xaxt="n",yaxt="n",xlab="",ylab="",ylim=c(min(cumRetDf),max(cumRetDf)));
                    lines(cumRetDf$ValueCleanPrice, col="green");
                    points(cumRetDf$ValueCleanPrice, col="green");
                    axis(4);
                    legend("topleft",col=c("red","green","blue"),lty=1,legend=c("Treasury futures(right)","CTD net value(right)","IRR"),bty="n",lwd=2);
            }
        invisible(data);
  }
