##' log
##'
##' log
##' @title log
##' @param ... other parametres 
##' @param newPage logical
##' @return log
##' @export
##' @author Weilin Lin
utils.log <- function(..., newPage = FALSE) {
    functionName <- as.character(sys.call(which = sys.parent())[[1]])
    if (length(functionName) != 0 && functionName == "FUN" && as.character(sys.call(sys.parent(2))[[1]]) ==
        "lapply") {
        functionName <- as.character(match.call(lapply, sys.call(which = sys.parent(2)))$FUN)
        if (length(functionName) < 1)
            functionName <- ""
        functionName <- functionName[1]
    }
    if (newPage)
        cat("")
    cat(paste(date(), p(functionName, "() :"), ..., "\n"))
}
