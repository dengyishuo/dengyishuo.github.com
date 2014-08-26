##' rename variables in a data frame
##'
##' rename variables in a data frame
##' @title rename variables in a data frame
##' @param df data frame
##' @param oldNames old names
##' @param newNames new names
##' @param warning warning
##' @return df
##' @export
##' @author Weilin Lin
df.renameVar <- function(df, oldNames, newNames, warning = FALSE) {
    if (NROW(oldNames) != NROW(newNames))
        stop("Dimension of oldNames and newNames must be equal")
    ii <- match(oldNames, names(df), nomatch = 0)
    if (warning && any(ii == 0))
        warning(paste(paste(oldNames[ii == 0], collapse = ", "), "not found in",
            substitute(df), "- only replacing subset of names"))
    oldNames <- oldNames[as.logical(ii)]
    newNames <- newNames[as.logical(ii)]
    if (length(intersect(newNames, names(df)[-ii])) != 0)
        stop("Renaming variables to existing names")
    names(df)[ii] <- newNames
    df
}
