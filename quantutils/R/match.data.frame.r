##' match two lists
##'
##' match two lists
##' @title match two lists
##' @param x list
##' @param table a list the same length as x
##' @param nomatch the value to be returned in the case when no match is found. Note that it is coerced to integer.
##' @param incomparables logical
##' @return A vector of the same length as x
##' @export
##' @author Weilin Lin
match.data.frame <- function(x, table, nomatch = NA, incomparables = F) {
     if (!identical(incomparables, F))
        stop("incomparables argument is not supported when x is a list")
    p <- length(x)
	
    if (!is.list(table) || length(table) != p)
        stop("table must be a list the same length as x")
    if (length(unique(unlist(lapply(x, length)))) > 1)
        warning("lengths of keys (variables in x) differ")
    if (length(unique(unlist(lapply(table, length)))) > 1)
        warning("lengths of keys (variables in table) differ")
		
    uniqueTable <- lapply(table, unique)
    f <- function(i, x, u) match(x[[i]], u[[i]])
	
    x <- lapply(seq(p), f, x = x, u = uniqueTable)
    table <- lapply(seq(p), f, x = table, u = uniqueTable)
	
    match(do.call("paste", x), do.call("paste", table), nomatch = nomatch)
}
