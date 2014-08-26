##' Calculates the summary information of a data frame
##'
##' Calculates the summary information of a data frame
##' @title Calculates the summary information of a data frame
##' @param df data frame
##' @return xx
##' @export
##' @author Weilin Lin
df.summary <- function(df) {
    df <- df[, sapply(df, is.numeric), drop = F]
    lst <- lapply(df, utils.summary)
    xx <- do.call("rbind", lst)
    return(xx)
}
