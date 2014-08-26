##' Calculate the diff between two monthes
##'
##' Calculate the diff between two monthes
##' @title Calculate the diff between two monthes
##' @param m1 any month
##' @param m2 any month
##' @param inFormat the format of diff
##' @return diff
##' @export
##' @author Weilin Lin
date.diffMonth <- function(m1, m2, inFormat = "YYYYMM") {
    mdy1 <- as.numeric(date.convert(p(m1, "01"), format = "YYYYMM"))
    mdy2 <- as.numeric(date.convert(p(m2, "01"), format = "YYYYMM"))
    return(as.integer(mdy1%%100 - mdy2%%100 + 12 * (mdy1%/%100 - mdy2%/%100)))
}
