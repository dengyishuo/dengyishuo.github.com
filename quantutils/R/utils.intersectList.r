##' calculates the intersect of list
##'
##' calculates the intersect of lis
##' @title calculates the intersect of lis
##' @param lst list
##' @return x,the intersect 
##' @export
##' @author Weilin Lin
utils.intersectList <- function(lst) {
    if (length(lst) == 0)
        stop("ERROR: the input list should contain at least one set")
    if (length(lst) == 1)
        return(lst[[1]]) else {
        x <- lst[[1]]
        for (i in 2:length(lst)) x <- intersect(x, lst[[i]])
        return(x)
    }
}
