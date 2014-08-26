##' Calculate cash flow of a coupon
##'
##' Calculate cash flow of a coupon
##' @title Calculate cash flow of a coupon
##' @param yrMatVec years to maturity
##' @param cVec coupon
##' @param region region of coupon
##' @return Cash flow 
##' @export
##' @author Weilin Lin
CF <- function(yrMatVec, cVec, region) {
    return(mapply(FUN = dot.cf, yrMat = yrMatVec, c = cVec, region = region))
}
