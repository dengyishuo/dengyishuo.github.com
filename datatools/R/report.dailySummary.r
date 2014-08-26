##' report summary for contracts 
##'
##' report summary for contracts 
##' @title report summary for contracts 
##' @param date 
##' @return data frame
##' @export
##' @importFrom quantutils p utils.readCSV df.rbindList
##' @author Weilin Lin
##' 
report.dailySummary <- function(date){    
    ## get future contracts
    futDf <- futureMain();    
    futDf <- subset(futDf, LastTradingDate>=date);
    contracts <- unique(futDf$ContractCode);
    lst <- list();
    for(contract in contracts){
        df <- getCTD(date, date, contract=contract, ifplot = FALSE);
        df <- df[,c("contract","futureSettle","futureRet","jtid","VPYield","CF","impliedRepo")];
        lst[[contract]] <- df;
    }
    dataDf <- df.rbindList(lst);
    dataDf$jtid <- substring(dataDf$jtid, 3, 20);    
    dataDf$impliedRepo <- round(100*dataDf$impliedRepo,2);
    return(dataDf);
}


