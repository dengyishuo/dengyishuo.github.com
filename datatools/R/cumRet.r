##' Read cumRet from our Database
##'
##' Read cumRet from our Database
##' @title Read cumRet from our Database
##' @param startDate The startDate of data
##' @param endDate The endDate of data
##' @param jtids Stock or coupon symbols
##' @param vars Variables in data
##' @param region region of stock or coupon
##' @param inDir File direction to read data
##' @param ... Other parameters needed
##' @return dailyDF
##' @importFrom quantutils p utils.readCSV
##' @export
##' @author Weilin Lin
cumRet <- function(startDate, endDate = startDate, jtids = NULL, vars = NULL,
    region, inDir = NULL, ...) {
    if (is.null(inDir))
        inDir <- p(DATA.DIR, "/", tolower(region), "/daily/derived/cumRet")
    dailyDf <- utils.readCSV(jtids, startDate = startDate, endDate = endDate,
        vars = vars, region = region, dataDir = inDir, filePrefix = "cumRet",
        ...)
    invisible(dailyDf)
}
