##' read CTDBond from our database
##'
##' read CTDBond from our database
##' @title read CTDBond from our database
##' @param contract contract
##' @param region region 
##' @return a data frame
##' @importFrom quantutils p
##' @author Weilin Lin
##' @export
CTDBond <- function(contract = NULL, region = "CN") {
    outDir <- p(YTM.DATA.DIR, "/", tolower(region), "/daily/derived/CTDBond")
    df <- read.csv(p(outDir, "/CTDBond.csv"))
    if (is.null(contract)) {

    } else {
        df <- df[df$contract == contract, ]
    }
    return(df)
}
