backtest.CB.arbitrage <- function(date=NULL){
    if(is.null(date)) date <- date.currentDate();
    date.L1 <- date.toBusDate(date, shift = -1, region = "CN");
    date.L2 <- date.toBusDate(date, shift = -2, region = "CN");
    date.L1 <- date.convert(date.L1, format = "YYYYMMDD");
    date.L2 <- date.convert(date.L2, format = "YYYYMMDD");
    
    ## downd load CB hft data from database
    data <- mktDataHFT.CB(date.L2, date.L1);
    data <- data[,c("TradeTime", "SecurityID", "LastPx", "BidPx1", "BidSize1",
                    "OfferPx1", "OfferSize1")];
    colnames(data) <- c("rt_time","jtid","last","bid1","bsize1","ask1","asize1");
    data$jtid      <- p("CN", data$jtid);
    
    ## Calculation for day T-2
    CBDf         <- mktData.CB(date.L2, vars = c("NewConvetPrice"));
    CBDf$stkjtid <- keyMap.CB(CBDf$jtid, "JTID", "stkJTID");
    CBDf$name    <- keyMap.CB(CBDf$jtid, "JTID", "SecuAbbr");
    CBDf         <- CBDf[,c("name","jtid","stkjtid","NewConvetPrice")];
    tmpDf        <- data[,c("jtid","rt_time","ask1","asize1")];
    CBDf         <- merge(CBDf,tmpDf, by="jtid");
    
    
   
    
    ## Exclude those convertible bond that can not be converted into stocks.
    paramDf <- read.csv("/home/amg/data/CB/cn/pricing/pricingParameters.csv", header = TRUE);
    paramDf <- paramDf[,c(1,9)];
    colnames(paramDf)  <- c("windID","convStartDate");
    paramDf$jtid       <- p("CN", substring(paramDf$windID,1,6));
    paramDf            <- paramDf[,c("jtid","convStartDate")];
    CBDf$convStartDate <- paramDf$convStartDate[match(CBDf$jtid, paramDf$jtid)];
    CBDf               <- subset(CBDf, convStartDate<date.L2, select = -convStartDate);
    volDf              <- volatility(date.convert(date.toBusDate(date.L2, shift = -1, region = "CN"), format="YYYYMMDD"));
    
    ## caculates convertible premium rate
    CBDf$ask1          <- data$ask1[match(CBDf$jtid,data$jtid)];
    CBDf$asize1        <- data$asize1[match(CBDf$jtid,data$jtid)]/1000;
    CBDf$rt_time       <- data$rt_time[match(CBDf$jtid, data$jtid)];
    CBDf               <- subset(CBDf, ask1>0);
    CBDf$stkPrice      <- data$last[match(CBDf$stkjtid,data$jtid)];
    CBDf$convValue     <- 100/CBDf$NewConvetPrice*CBDf$stkPrice;        
    CBDf$convPremium.P <- 100*(CBDf$ask1 - CBDf$convValue)/CBDf$convValue;
    CBDf$vol20.P       <- 100*volDf$vol20[match(CBDf$stkjtid, volDf$jtid)];
    CBDf$expRet.P      <- 100*(100/CBDf$NewConvetPrice*CBDf$stkPrice-CBDf$ask1)/CBDf$ask1;    
    CBDf$SR.a          <- CBDf$expRet.P/CBDf$vol20.P*sqrt(240);
    CBDf$probOfLoss    <- pnorm(-CBDf$expRet.P/100, 0, CBDf$vol20.P/100)*100;
    
           
}
