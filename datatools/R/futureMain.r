##' get future contract information and write to local csv files
##'
##' get future contract information and write to local csv files
##' @title get future contract information and write to local csv files
##' @return data
##' @author Weilin Lin
##' @export
futureMain <- function() {
    data <- read.csv(p("http://",ip,":20000/yieldCurve/cn/futureMain/futureMain.csv"),fileEncoding = "utf-8",header = TRUE);
    return(data)
}
