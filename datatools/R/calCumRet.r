##' caculates the cumulative return 
##'
##' cumRet is computed use the as (endDate closePrice)/ (startDate closePrice) -1 with proper CACS adjustments
##' @title caculates the cumulative return 
##' @param jtids symbols
##' @param startDates start dates
##' @param endDates end dates
##' @param region region
##' @return cumRet
##' @export
##' @author Weilin Lin
calCumRet <- function(jtids, startDates, endDates, region = "CN") {
    if (length(jtids) == 0)
        stop("ERROR: must provide valid jtids to compute cummulative returns")

    startDates <- date.convert(date.toBusDate(startDates, region = region), format = "YYYYMMDD")
    endDates <- date.convert(date.toBusDate(endDates, region = region), format = "YYYYMMDD")

    if (length(startDates) == 1) {
        startDates <- rep(startDates, length(jtids))
    }

    if (length(endDates) == 1) {
        endDates <- rep(endDates, length(jtids))
    }

    if (length(startDates) != length(jtids))
        stop("ERROR: the length of startDates must be 1 or as same length as the jtids")

    if (length(endDates) != length(jtids))
        stop("ERROR: the length of endDates must be 1 or as same length as the jtids")

    if (any(startDates > endDates))
        stop("ERROR: all the startDates must be earlier than the endDates")

    zeroVec <- rep(0, length(jtids))
    oneVec <- rep(1, length(jtids))
    NAVec <- rep(NA, length(jtids))

    df <- data.frame(jtid = jtids, startDate = startDates, endDate = endDates,
        close.s = NAVec, close.e = NAVec, adjustingFactor.s = oneVec, adjustingConst.s = zeroVec,
        adjustingFactor.e = oneVec, adjustingConst.e = zeroVec, cumRet = NAVec)

    
	adjDf <- adjFactor(jtids = unique(jtids), region = region)
    dataLst <- list()

    for (date in sort(unique(c(startDates, endDates)))) {
        ids <- unique(df$jtid[which(df$startDate == date | df$endDate == date)])
        mktDf <- mktData(startDate = date, endDate = date, vars = "close", region = "CN")
        mktDf <- subset(mktDf, jtid %in% ids)
        dataLst[[date]] <- mktDf
    }

    for (i in 1:nrow(df)) {
        jtid <- df$jtid[i]
        startDate <- df$startDate[i]
        endDate <- df$endDate[i]
        sDf <- dataLst[[startDate]]
        eDf <- dataLst[[endDate]]
        if (jtid %in% sDf$jtid & jtid %in% eDf$jtid) {
            df$close.s[i] <- sDf$close[which(sDf$jtid == jtid)]
            df$close.e[i] <- eDf$close[which(eDf$jtid == jtid)]
        }
        aDf <- adjDf[which(adjDf$jtid == jtid & adjDf$exDiviDate <= startDate),]
        if (nrow(aDf) > 0) {
            df$adjustingFactor.s[i] <- aDf[nrow(aDf), "adjustingFactor"]
            df$adjustingConst.s[i] <- aDf[nrow(aDf), "adjustingConst"]
        }

        aDf <- adjDf[which(adjDf$jtid == jtid & adjDf$exDiviDate <= endDate),]
        if (nrow(aDf) > 0) {
            df$adjustingFactor.e[i] <- aDf[nrow(aDf), "adjustingFactor"]
            df$adjustingConst.e[i] <- aDf[nrow(aDf), "adjustingConst"]
        }
    }

    df$cumRet <- (df$close.e * df$adjustingFactor.e + (df$adjustingConst.e - df$adjustingConst.s))/df$adjustingFactor.s/df$close.s - 1
    invisible(df$cumRet)
}
