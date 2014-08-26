##' extract substrings of text
##' 
##' extract substrings of text
##' @title extract substrings of text
##' @param text a character vector.
##' @param first  integer. The first element to be replaced.
##' @param last integer. The last element to be replaced.
##' @return substring is compatible with S, with first and last instead of start and stop. For vector arguments, it expands the arguments cyclically to the length of the longest provided none are of zero length.
##' @export
##' @author Weilin Lin
utils.substring <- function(text, first, last = NULL) {
    if (is.character(first)) {
        match <- regexpr(first, text)
        return(substring(text, first = match, last = match + attr(match, "match.length") -
            1))
    } else {
        return(substring(text, first = first, last = last))
    }
}
