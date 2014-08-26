##' Adjust Factors
##'
##' Adjust Factors
##' @title Adjust Factors
##' @param jtids stock symbols
##' @param vars High/low/open/close price for a stock
##' @param region region for stock symbols
##' @param adjFactorFile adjFactor File
##' @return df
##' @importFrom quantutils p utils.readCSV
##' @export
##' @author Weilin Lin
adjFactor <- function(jtids = NULL, vars = NULL, region, adjFactorFile = NULL) {
    if (is.null(adjFactorFile))
    adjFactorFile <- p(DATA.DIR, "alpha",tolower(region), "adjFactor/adjFactor.csv",sep="/")
    df <- read.csv(adjFactorFile)
    fullVars <- names(df)
    if (is.null(vars)){
        vars <- fullVars
		}
    if (length(setdiff(vars, fullVars)) > 0) {
        stop("Error: Input arg vars contains invalid column names: ", setdiff(vars,fullVars))
			}
    if (is.null(jtids)){
        jtids <- sort(unique(df$jtid))
		df <- df[which(df$jtid %in% jtids), ]
}
    if (nrow(df) == 0)
        return(NULL)

    tmp <- ordered(df$jtid, levels = jtids)
    df <- df[order(tmp), c("jtid", setdiff(vars, "jtid"))]
    if (nrow(df) <= 10)
        return(df)
    invisible(df)
}
