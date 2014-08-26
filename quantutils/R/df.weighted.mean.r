##' calculates weighted mean of data frame
##'
##' calculates weighted mean of data frame
##' @title calculates weighted mean of data frame
##' @param df data frame
##' @param meanVar variables to calculates mean
##' @param byVar group variables
##' @param wgtVar weight variables
##' @param ... other parameters
##' @return data
##' @export
##' @author Weilin Lin
df.weighted.mean <- function(df, meanVar, byVar, wgtVar, ...) {
    df <- df[, c(meanVar, byVar, wgtVar)]
    df <- na.omit(df)
    dfLst <- split(df, df[[byVar]])
    names <- names(dfLst)
    wgt.mean <- c()

    for (name in names) {
        ddf <- dfLst[[name]]
        wgt.mean[name] <- weighted.mean(ddf[[meanVar]], ddf[[wgtVar]], ...)
    }

    data <- data.frame(byVar = names, wgt.mean = wgt.mean)
    colnames(data) <- c(byVar, meanVar)
    return(data)
}
