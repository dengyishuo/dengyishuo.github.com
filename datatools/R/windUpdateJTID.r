##' get windIDs need to update with wind
##'
##' get windIDs need to update with wind
##' @title get windIDs need to update with wind
##' @return vector
##' @importFrom quantutils date.convert date.currentDate date.toBusDate
##' @export
##' @author Weilin Lin
windUpdateJTID <- function(){
    ## get treasury future related jtids
    CFDf    <- read.csv(p("http://",getIP(),":20000/yieldCurve/cn/CF/CF.csv"), header=TRUE);
    CFDf$IB <- formatC(CFDf$IB, width = 6, format = "d", flag = "0");
    CFDf$SH <- formatC(CFDf$SH, width = 6, format = "d", flag = "0");
    CFDf$SZ <- formatC(CFDf$SZ, width = 6, format = "d", flag = "0");
    CFDf$IB <- p("CN",CFDf$IB,".IB");
    CFDf$SH <- p("CN",CFDf$SH,".SH");
    CFDf$SZ <- p("CN",CFDf$SZ,".SZ");
    windIDs <- unique(c(CFDf$IB, CFDf$SH, CFDf$SZ));
    windIDs <- substring(windIDs,3,20);
    futDf     <- futureMain();
    futDf     <- subset(futDf, LastTradingDate>=date.currentDate());
    futureIDs <- p(unique(futDf$ContractCode),".CFE");
    windIDs   <- c(windIDs,futureIDs);
    windIDs   <- c(windIDs,"204001.SH","204002.SH","204003.SH","204004.SH","204007.SH","204014.SH","204028.SH","204091.SH","131810.SZ","131811.SZ","131800.SZ","131809.SZ","131801.SZ","131802.SZ","131803.SZ","131805.SZ","R001.IB","R007.IB");
    
    ## get convertible bond jtids
    dateL      <- date.convert(date.toBusDate(date.currentDate(), shift = -1, region = "CN"),
                               format = "YYYYMMDD");
    mktCBDf        <- mktData.CB(dateL);
    jtids          <- unique(mktCBDf$jtid);
    windjtids      <- keyMap.CB(jtids, "JTID", "windID");
    windstkjtids   <- keyMap.CB(jtids, "JTID", "windStkID");    
    windIDs        <- c(windIDs, windjtids, windstkjtids);

    ## Get Exchange active trade bonds
    liqDf   <- liquidity(dateL);
    mainDf  <- bondMain()[,c("jtid","SecuMarket")];
    mainDf  <- subset(mainDf, SecuMarket%in%c(83, 90));
    liqDf   <- subset(liqDf, jtid%in%mainDf$jtid);
    liqDf   <- subset(liqDf, (atv1d>1*1e6) & (atv3d>1*1e6) ^(atv5d>1*1e6));
    liqDf$jtid <- substring(liqDf$jtid, 3, 20);
    windIDs <- unique(c(windIDs, liqDf$jtid));    
    windIDs <- p(windIDs, collapse=",");    
    return(windIDs);    
}


