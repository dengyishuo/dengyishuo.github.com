##' This is the scripts to collect the information of variety of bonds
##'
##' This is the scripts to collect the information of variety of bonds
##' @title collect the information fo variety of bonds
##' @param jtids symbols for bonds
##' @param vars variables in data
##' @param region region for bonds
##' @param inFile data source
##' @return df
##' @importFrom quantutils p utils.readCSV
##' @export
##' @author Weilin Lin
bondMain <- function(jtids = NULL, vars = NULL, region = "CN", inFile = NULL) {
    if (is.null(inFile))
        inFile <- p(YTM.DATA.DIR, "/", tolower(region), "/bondMain/bondMain.csv")
    df <- read.csv(inFile, header = TRUE, fileEncoding = "utf8");
    fullVars <- names(df)
    if (is.null(vars))
        vars <- fullVars
    if (is.null(jtids))
        jtids <- sort(unique(df$jtid))
    df <- df[which(df$jtid %in% jtids), ]
    tmp <- ordered(df$jtid, levels = jtids)
    df <- df[order(tmp), c("jtid", setdiff(vars, "jtid"))]
    if (nrow(df) <= 10)
        return(df)
    invisible(df)
}
