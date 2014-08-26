##' transforms data frame to list of character
##'
##' transforms data frame to list of character
##' @title transforms data frame to list of character
##' @param df data frame
##' @param sep the field separator character.
##' @return an list
##' @export
##' @author Weilin Lin
utils.combineFactors <- function(df, sep = ":") {
    utils.checkCond(is.data.frame(df), "df must be a data.frame")
    return(do.call("paste", c(lapply(df, as.character), sep = sep)))
}
