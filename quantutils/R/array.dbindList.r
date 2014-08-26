##' Change the dimnames and dimensions of an array
##'
##' Change the dimnames and dimensions of an array
##' @title Change the dimnames and dimensions of an array
##' @param L An list
##' @param overwrite Logic
##' @return An array with new dimnames and dimesions
##' @export
##' @author Weilin Lin
array.dbindList <- function(L, overwrite = FALSE) {
    L <- L[!sapply(L, is.null)]
    if (length(L) == 0)
        return(NULL)
    dimnamesList <- lapply(L, dimnames)
    numDims <- unique(sapply(dimnamesList, length))

    if (length(numDims) != 1)
        stop("array list must all have same number of dimensions")

    if (numDims < 2)
        stop("arrays of dimension less than 2 are not supported")

    if (overwrite) {
        newDimnames <- lapply(1:numDims, function(d, dimnamesList) {
            unique(unlist(lapply(dimnamesList, function(x, i) {
                x[[i]]
            }, i = d)))
        }, dimnamesList = dimnamesList)
    } else {
        countIden <- 0
        newDimnames <- lapply(1:numDims, function(d, dimnamesList) {
            nameList <- lapply(dimnamesList, function(x, i) {
                x[[i]]
            }, i = d)
            cVec <- unlist(nameList)
            uVec <- unique(cVec)
            if (length(uVec) < length(cVec)) {
                lengthVec <- sapply(dimnamesList, function(x, i) {
                  length(x[[i]])
                }, i = d)
                if (any(lengthVec < length(uVec))) {
                  stop(p("overlap of names in dimension ", d, ": ", gsub("\"",
                    "'", deparse(nameList))))
                } else {
                  assign("countIden", countIden + 1, envir = sys.frame(sys.parent(2)))
                }
            }
            return(uVec)
        }, dimnamesList = dimnamesList)
        if (countIden >= numDims)
            stop("all the dimensions have identical names")
    }

    if (!is.null(names(dimnamesList[[1]])))
        names(newDimnames) <- names(dimnamesList[[1]])

    output <- array(data = NA, dim = as.vector(sapply(newDimnames, length)), dimnames = newDimnames)

    for (i in 1:length(L)) {
        dn <- dimnamesList[[i]]
        dnString <- p(p("dn[[", 1:numDims, "]]"), collapse = ", ")
        eval(parse(text = p("output[", dnString, "] <- L[[i]][", dnString, "]")))
    }

    return(output)
}
