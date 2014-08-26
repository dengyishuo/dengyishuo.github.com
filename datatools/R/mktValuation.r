##' read market valuation from our database
##'
##' read market valuation from our database
##' @title read market valuation from our database
##' @param startDate start Date
##' @param endDate end Date
##' @param jtids symbols of stocks or coupon
##' @param vars variables in data
##' @param region region for stocks or coupon
##' @param inDir Direction 
##' @param ... other parameters
##' @return null
##' @importFrom quantutils p utils.readCSV
##' @export
##' @author Weilin Lin

mktValuation <- function(startDate, endDate = startDate, jtids = NULL, vars = NULL,
    region = "CN", inDir = NULL, ...) {
    if (is.null(inDir))
        inDir <- p(YTM.DATA.DIR, "/", tolower(region), "/daily/raw/mktValuation")
    dailyDf <- utils.readCSV(jtids, startDate = startDate, endDate = endDate,
        vars = vars, region = region, dataDir = inDir, filePrefix = "mktValuation",
        ...)
    invisible(dailyDf)
}
