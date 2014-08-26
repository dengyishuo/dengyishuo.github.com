##' backtest summary for the bondfuture
##'
##' backtest summary for the bondfuture
##' @title backtest summary for the bondfuture
##' @param cfgLst configuration list object
##' @return data frame and plot
##' @importFrom quantutils p utils.readCSV df.rbindList date.convert
##' @export
##' @author Weilin Lin

backtest.summary.bondFuture <- function(cfgLst){
            sumDf <- cfgLst$sumDf;
            ii    <- which(!duplicated(sumDf$date));
            ylims <- c(min(sumDf[,c("cumRet","indexCumRet")]), max(sumDf[,c("cumRet","indexCumRet")]));
            plot(100*sumDf$indexCumRet, ty="l", ylim=100*ylims, ylab="(%)",
                          xlab="date", xaxt="n", main = cfgLst$signalVar);
            lines(100*sumDf$cumRet, col="red");
            abline(v=ii, lty=2);
            axis(1, at=ii, labels=sumDf$date[ii],las=0);

            ## summary by keys
            # Firstly aggregate into daily data.
            sumDf$signalRet <- sumDf[[cfgLst$signalVar]]*sumDf$ret;
            indexDf  <- aggregate(ret~date, data=sumDf, FUN=sum);
            signalDf <- aggregate(signalRet~date, data=sumDf, FUN=sum);
            dailyDf  <- merge(indexDf, signalDf);
            lst      <- list();
            for(freq in c("ALL", "YYYY", "YYYYMM","YYYYMMDD")){
                      if(freq=="ALL"){
                                  dailyDf$key <- rep("ALL", nrow(dailyDf));
                              }else{
                                          dailyDf$key <- date.convert(dailyDf$date, format=freq);
                                      }
                            keys       <- sort(unique(dailyDf$key));
                            summaryLst <- lapply(keys, function(key, dailyDf)
                                                 {
                                                                                  dailyDf  <- dailyDf[which(dailyDf$key==key),];
                                                                                                               ret      <- dailyDf$signalRet;
                                                                                                               indexRet <- dailyDf$ret;
                                                                                                               y <- data.frame(ret.P=(prod(1+ret)-1)*100, anaRet.P=mean(ret)*240*100, indexRet.P=(prod(indexRet+1)-1)*100, SR=mean(ret)/sd(ret)*sqrt(240), downDays=sum(ret<0), downDaysPct.P=sum(ret<0)/nrow(dailyDf)*100);
                                                                                                               return(cbind(data.frame(period=key, startDate=min(dailyDf$date), endDate=max(dailyDf$date)),round(y,2)));
                                                                              },dailyDf=dailyDf);
                            summaryDf <- df.rbindList(summaryLst);
                            lst[[freq]] <- summaryDf;
                  }
            invisible(lst);
    }
