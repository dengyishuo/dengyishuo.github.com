##' Is n an even?
##'
##' Is n an even?
##' @title Is n an even
##' @param n any integer
##' @return logical
##' @export
##' @author Weilin Lin
is.even = function(n) {
    res = n%%2
    if (res > 0) {
        return(FALSE)
    } else {
        return(TRUE)
    }
}
