##' This is the function to calculate cash flow in deliyable set
##'
##' This is the function to calculate cash flow in deliyable set
##' @title This is the function to calculate cash flow in deliyable set
##' @param jtid symbols of stocks or bonds
##' @param vars variables in data 
##' @export
##' @importFrom quantutils date.convert dot.date.convert p 
##' @return a dataframe includs the cash flow of jtid
##' @author Weilin Lin
cashFlow <- function(jtid = NULL, vars = NULL) {
    df <- read.csv("http://fiquant.oicp.net:20000/yieldCurve/cn/CF/cashflow.csv",fileEncoding = "utf-8")
    df$windID <- p("CN", df$windID)
    df$date <- date.convert(dot.date.convert(df$date, format = "%Y/%m/%d"), format = "YYYYMMDD")
    colnames(df) <- c("jtid", "date", "coupon", "face", "cashflow", "type", "couponRate")
    if (!is.null(jtid))
        df <- df[df$jtid == jtid, ]
    if (!is.null(vars))
        df <- df[, c("jtid", "date", vars)]
    invisible(df)
}
