##' compare two data frame and return their compareStats
##'
##' compare two data frame and return their compareStats
##' @title compare two data frame and return their compareStats
##' @param df.x data frame
##' @param df.y data frame 
##' @param mergeBy an variable in data frame used when merge df.x and df.y
##' @param suffixes suffixes
##' @param tol tolorence
##' @param data logical
##' @param absoluteTol logical
##' @return a list
##' @author Weilin Lin
##' @export
##' @examples df.x=as.data.frame(matrix(round(rnorm(12),2),3,4));df.y=as.data.frame(matrix(round(rnorm(12),2),3,4));df.y[,1]=df.x[,1];df.y[1,]=df.x[1,];df.compareDfs(df.x,df.y,mergeBy="V1")

df.compareDfs <- function(df.x, df.y, mergeBy, suffixes = c(".x", ".y"), tol = 1e-04,
    data = FALSE, absoluteTol = TRUE) {
    dfNames <- c(as.character(substitute(df.x)), as.character(substitute(df.y)))

    sX <- suffixes[1]
    sY <- suffixes[2]

    vars.both <- intersect(names(df.x), names(df.y))
    vars.xonly <- setdiff(names(df.x), names(df.y))
    vars.yonly <- setdiff(names(df.y), names(df.x))
	
    df.x[["in"]] <- in.x <- rep(TRUE, NROW(df.x))
    df.y[["in"]] <- in.y <- rep(TRUE, NROW(df.y))

    if (is.null(mergeBy)) {
        df.x[, "..rowNumber.."] <- 1:NROW(df.x)
        df.y[, "..rowNumber.."] <- 1:NROW(df.y)
        mergeBy <- "..rowNumber.."
    }

    df <- merge(df.x, df.y, by = mergeBy, all = TRUE, suffixes = suffixes)
    inXvar <- paste("in", sX, sep = "")
    inYvar <- paste("in", sY, sep = "")
    df[[inXvar]][is.na(df[[inXvar]])] <- FALSE
    df[[inYvar]][is.na(df[[inYvar]])] <- FALSE

    compareVars <- setdiff(vars.both, mergeBy)

    info <- list(dfNames = dfNames, names = c(names(df.x), names(df.y)), nrows = c(NROW(df.x),
        NROW(df.y)), nRowsCommon = sum(df[[inYvar]] & df[[inXvar]]), nRowsCommonPct = sum(df[[inYvar]] &
        df[[inXvar]])/dim(df)[[1]] * 100, vars.both = vars.both, vars.xonly = vars.xonly,
        vars.yonly = vars.yonly)

    cat("dimensions of df:", dim(df), "\n")
    cat("Number of rows in", dfNames[1], ": ", sum(df[[inXvar]]), "\n")
    cat("Number of rows in", dfNames[2], ": ", sum(df[[inYvar]]), "\n")
    cat("Number of ids in common:", sum(df[[inYvar]] & df[[inXvar]]), "=", sum(df[[inYvar]] &
        df[[inXvar]])/dim(df)[[1]] * 100, "% \n")
    cat("\nVariables in both datasets:\t", vars.both, "\n")
    cat("\nVariables in", dfNames[1], "dataset only:\t", vars.xonly, "\n")
    cat("\nVariables in", dfNames[1], "dataset only:\t", vars.yonly, "\n")

    dfOut <- df
    df <- df[df[[inXvar]] & df[[inYvar]], ]

    missCountFn <- function(x, y) {
        result <- c(ok.both = sum(!is.na(x) & !is.na(y)), miss.both = sum(is.na(x) &
            is.na(y)), miss.x = sum(is.na(x) & !is.na(y)), miss.y = sum(!is.na(x) &
            is.na(y)))
        result
    }

    missCount <- list()
    for (var in compareVars) {
        missCount[[var]] <- missCountFn(df[[paste(var, sX, sep = "")]], df[[paste(var,
            sY, sep = "")]])
    }
    missCount <- do.call("rbind", missCount)
    dimnames(missCount)[[1]] <- compareVars
    missCount <- data.frame(missCount)

    pairCompareVars <- compareVars[sapply(df.x[compareVars], is.atomic) & sapply(df.y[compareVars],
        is.atomic)]
    pairCompareResults <- df.pairCompare(df, pairCompareVars, tol = tol, suffixes = suffixes,
        absoluteTol = absoluteTol)

    compareStats <- merge(missCount, pairCompareResults, by = "row.names", all = TRUE)
    row.names(compareStats) <- compareStats$Row.names
    compareStats <- compareStats[pairCompareVars, -match("Row.names", names(compareStats),
        nomatch = 0)]

    if (data) {
        return(list(info = info, compareStats = compareStats, data = dfOut))
    } else {
        return(list(info = info, compareStats = compareStats))
    }
}
