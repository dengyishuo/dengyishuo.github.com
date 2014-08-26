##' This is the script to make trearury future market data.
##'
##' This is the script to make trearury future market data.
##' @title This is the script to make trearury future market data.
##' @param startDate start Date
##' @param endDate end Date
##' @param jtids symbols of stocks or coupon
##' @param vars varibles in data
##' @param region region for stocks or coupon
##' @param inDir direction
##' @param ... other parameters
##' @return null
##' @importFrom quantutils p utils.readCSV
##' @export
##' @author Weilin Lin
mktTF <- function(startDate, endDate = startDate, jtids = NULL, vars = NULL, region = "CN",
    inDir = NULL, ...) {
    if (is.null(inDir))
        inDir <- p(YTM.DATA.DIR, "/", tolower(region), "/daily/raw/mktTF")
    dailyDf <- utils.readCSV(jtids, startDate = startDate, endDate = endDate,
        vars = vars, region = region, dataDir = inDir, filePrefix = "mktTF", ...)
    invisible(dailyDf)
}
