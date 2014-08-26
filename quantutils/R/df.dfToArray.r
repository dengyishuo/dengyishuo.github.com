##' Convert df to Array
##'
##' Convert df to Array
##' @title Convert df to array
##' @param d uncomfirmed
##' @param keyCols uncomfirmed
##' @param valueCols uncomfirmed
##' @param valueColDimnameName uncomfirmed
##' @param drop Logical
##' @return a
##' @export
##' @author Weilin Lin
df.dfToArray <- function(d, keyCols, valueCols, valueColDimnameName = NULL, drop = FALSE) {
    utils.checkCond(!drop || length(valueCols) == 1, "can only use drop = TRUE with a single valueCol")
    dn <- lapply(d[, keyCols], function(keyColValues) {
        sort(unique(keyColValues))
    })
    if (!drop) {
        extraDim <- list(col = valueCols)
        names(extraDim) <- valueColDimnameName
        dn <- c(dn, extraDim)
    }

    a <- array(as.numeric(NA), dim = sapply(dn, length), dimnames = dn)

    i <- do.call("cbind", lapply(1:length(keyCols), function(keyColNum) {
        keyCol <- keyCols[keyColNum]
        match(d[, keyCol], dn[[keyColNum]])
    }))

    if (drop) {
        a[i] <- d[, valueCols]
    } else {
        for (valueColIndex in 1:length(valueCols)) {
            a[cbind(i, valueColIndex)] <- d[, valueCols[valueColIndex]]
        }
    }

    a
}
