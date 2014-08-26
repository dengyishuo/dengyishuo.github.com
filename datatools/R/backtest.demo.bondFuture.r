##' Demo for bondfuture HFT
##'
##' Demo for bondfuture HFT
##' @title Demo for bondfuture HFT
##' @return data frame
##' @export
##' @importFrom quantutils p utils.readCSV df.rbindList date.convert
##' @importFrom zoo zoo 
##' @author Weilin Lin
backtest.demo.bondFuture <- function(){
    sigDf <- mktDataHFT(startDate = 20131001, endDate = 20131108, jtids = "TF1312",vars="LastPx");
    colnames(sigDf)    <- c("contract","date","time","LastPx");
    sigDf              <- sigDf[order(sigDf$date, sigDf$time), ];
    rownames(sigDf)    <- NULL;
    n                  <- nrow(sigDf);
    sigDf$simpleSignal <- c(0, sign(sigDf$LastPx[2:n]-sigDf$LastPx[1:(n-1)]));
    signals            <- zoo(sigDf$simpleSignal);
    sigDf$simpleSignal <- as.vector(lag(signals, -10, na.pad = TRUE));

    ## Maintain short positions between two trading days
    flags <- which(sigDf$date[2:n] != sigDf$date[1:(n-1)]) + 1;
    sigDf$simpleSignal[flags] <- 0;
    cfgLst             <- list(signalVar = "simpleSignal",
                                                            startDate = NULL,
                                                            endDate   = NULL,
                                                            sigDf     = sigDf
                                                          );
    cfgLst <- backtest.loadData.bondFuture(cfgLst);
    cfgLst <- backtest.bondFuture(cfgLst = cfgLst);
    backtest.summary.bondFuture(cfgLst = cfgLst);
}
