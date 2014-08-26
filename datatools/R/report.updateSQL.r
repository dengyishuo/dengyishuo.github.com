report.updateSQL <- function(date=NULL, conn=DBChannel.APE.TF){
    if(is.null(date)) date <- date.currentDate();
    date <- date.convert(date, format = "YYYYMMDD");
    ## update daily summary table
    df    <- report.dailySummary(date);
    table <- "dailysummary";
    try(dbSendQuery(conn, p("DROP table ",table)),silent=TRUE);
    dbWriteTable(conn, name=table, value = df, append=FALSE, rownames=FALSE);    
    
    ## update IRR plot
    futDf    <- futureMain();
    futDf    <- subset(futDf, LastTradingDate>=date);
    contract <- futDf$ContractCode[futDf$LastTradingDate==min(futDf$LastTradingDate)];
    irrDf    <- getCTD(startDate = 20130906, endDate = date, contract = contract, ifplot=FALSE)[,c("date","contract","ValueCleanPrice","futureSettle","impliedRepo")];
    irrDf$impliedRepo <- 100*irrDf$impliedRepo;
    
    table    <- "TFtable2";
    try(dbSendQuery(conn, p("DROP table ",table)),silent=TRUE);
    dbWriteTable(conn, name=table, value = irrDf, append=FALSE, rownames=FALSE);

    ## Update IRR intraday data with interbank valuation data.
    df <- mktDataHFT(date, jtids = contract);
    df <- subset(df, LastVolumnTrade>0);
    mktStatDf <- mktStat.CTDBond(date, contract=contract);
    utils.log("Write data to APE for report done!!");    
    
}
