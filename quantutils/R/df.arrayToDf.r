##' Transfer an array to Data frame
##'
##' Transfer an array to Data frame
##' @title Transfer an array to Data frame
##' @param a an arry
##' @param valueCol Column contains the value
##' @param valueDim logical
##' @return d
##' @export
##' @author Weilin Lin
df.arrayToDf <- function(a, valueCol = "value", valueDim = NULL) {
    dn <- dimnames(a)
    utils.checkCond(all(sapply(dn, is.character)) && !is.null(names(dn)), "must have named dimnames for all dimensions")

    if (!is.null(valueDim)) {
        utils.checkCond(is.character(valueDim), "valueDim must be the name of one of the dimnames of a")
        valueDim <- match(valueDim, names(dn))
        utils.checkCond(!is.na(valueDim), "valueDim must be the name of one of the dimnames of a")
        dn <- dn[-valueDim]
    }

    d <- do.call("expand.grid", list(dn, KEEP.OUT.ATTRS = F))
    d[, ] <- lapply(d, as.character)


    if (is.null(valueDim)) {
        d[, valueCol] <- as.vector(a)
    } else {
        d[, dimnames(a)[[valueDim]]] <- as.vector(aperm(a, c(setdiff(1:length(dim(a)),
            valueDim), valueDim)))
    }

    d
}
