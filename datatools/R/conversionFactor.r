##' get the deliveable bonds information
##' 
##' get the deliveable bonds information
##' @title get deliveable bonds information
##' @return data frame
##' @export
##' @author Weilin Lin
conversionFactor <- function(){
    CFDf    <- read.csv(p(YTM.DATA.DIR,"/cn/CF/CF.csv"), header=TRUE);
    CFDf$IB <- formatC(CFDf$IB, width = 6, format = "d", flag = "0");
    CFDf$SH <- formatC(CFDf$SH, width = 6, format = "d", flag = "0");
    CFDf$SZ <- formatC(CFDf$SZ, width = 6, format = "d", flag = "0");
    CFDf$IB <- p("CN",CFDf$IB,".IB");
    CFDf$SH <- p("CN",CFDf$SH,".SH");
    CFDf$SZ <- p("CN",CFDf$SZ,".SZ");
    return(CFDf);
}
