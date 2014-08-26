##' read marker statistics from our database
##'
##' read marker statistics from our database
##' @title Read marker statistics from our database
##' @param startDate start date
##' @param endDate end date
##' @param jtids symbols of stocks or coupon
##' @param vars variables in data
##' @param region region for stocks or coupon, must equal to "CN" or "HK"
##' @param inDir direction, unused parameter
##' @param ... other parameters
##' @importFrom quantutils p utils.readCSV
##' @return data frame with liquidity information and others
##' @export
##' @author Weilin Lin
mktStat <- function(startDate, endDate = startDate, jtids = NULL, vars = NULL,
    region = "CN", inDir = NULL, ...) {
    if (is.null(inDir))
        inDir <- p(DATA.DIR, "alpha", tolower(region), "daily/derived/mktStat",sep="/")
    dailyDf <- utils.readCSV(jtids, startDate = startDate, endDate = endDate,
        vars = vars, region = region, dataDir = inDir, filePrefix = "mktStat",
        ...)
    invisible(dailyDf)
}
