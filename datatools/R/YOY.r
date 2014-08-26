##' YOY Calculation of time Seriese
##' YOY Calculation of time Seriese
##'  
##' YOY Calculation of time Seriese
##' @title YOY Calculation of time Seriese
##' @param df input time series
##' @return xts object
##' @importFrom quantutils df.dfToArray p date.convert
##' @importFrom xts xts
##' @export 
##' @author WeilinLin

YOY <- function(df){
    dates   <- date.convert(time(df), format = "YYYYMMDD");
    dataLst <- list();
    dataLst[[names(df)]] <- df;
    dataLst$year  <- substring(dates,1,4);
    dataLst$month <- substring(dates,5,6);
    data   <- as.data.frame(dataLst);
    arr    <- df.dfToArray(d = data, keyCols = c("year","month"), valueCols = names(df));
    arr    <- arr[,,1];
    arr    <- (arr[2:nrow(arr),] - arr[1:(nrow(arr)-1),])/arr[1:(nrow(arr)-1),];
    tmpDf  <- expand.grid(rownames(arr),colnames(arr));
    months <- p(tmpDf[,1],tmpDf[,2]);
    tmpDf  <- data.frame(month = months);
    tmpDf[[names(df)]] <- as.vector(arr);
    tmpDf  <- tmpDf[order(tmpDf$month), ];
    YOYdf  <- data.frame(date = dates, month = substring(dates,1,6));    
    YOYdf  <- merge(YOYdf, tmpDf, by = "month", all.x = TRUE);
    YOYdf  <- xts(YOYdf[[names(df)]], date.convert(YOYdf$date));
    names(YOYdf) <- p(names(df),"_YOY");
    return(YOYdf);
}

