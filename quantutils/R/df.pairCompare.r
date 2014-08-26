##' compare every pair of the column of data frame
##'
##' compare every pair of the column of data frame,can not be explicit called
##' @title compare every pair of the column of data frame
##' @param df data frame
##' @param vars variables in data frame
##' @param tol tolerence
##' @param suffixes suffixes
##' @param absoluteTol absolute tolerence
##' @return x
##' @export
##' @examples pairCompareResults <- df.pairCompare(df,  c("V2","V3","V4","in"),  tol = 1e-04, suffixes = c(".x", ".y"), absoluteTol = TRUE)
##' @author Weilin Lin
df.pairCompare <- function(df, vars, tol = 1e-04, suffixes = c(".x", ".y"), absoluteTol = TRUE) {
    x <- lapply(vars, function(x, ...) {
	     statsFUN <- function(var, df, tol, suffixes, absoluteTol) {
            vars <- paste(var, suffixes, sep = "")
            x <- df[[vars[[1]]]]
            y <- df[[vars[[2]]]]
            if (!is.numeric(x) && !is.numeric(y)) {
                return(NULL)
            }
            if (inherits(x, "POSIXct") && inherits(y, "POSIXct")) {
                x <- as.numeric(x)
                y <- as.numeric(y)
            }
            diff <- x - y
            scale0 <- quantile(abs(c(x, y)), 0.2, na.rm = TRUE)
            scale <- pmax(scale0, x, y)
            if (!absoluteTol)
                tol <- abs(x * tol) + 1e-06
           result <- c(cor = suppressWarnings(cor(df[, vars], use = "complete")[1,2]), 
				N.match = sum(abs(diff) <= tol, na.rm = TRUE), 
				N.nomatch = sum(abs(diff) > tol, na.rm = TRUE), 
				rangeCover = suppressWarnings((min(max(x, na.rm = TRUE), max(y, na.rm = TRUE)) - max(min(x, na.rm = TRUE),min(y, na.rm = TRUE)))/(max(c(x, y), na.rm = TRUE) - min(c(x,
                y), na.rm = TRUE))), 
				meanAbsDiff = mean(abs(diff), na.rm = TRUE),
                medAbsDiff = median(abs(diff), na.rm = TRUE),
				absDiff.q = quantile(abs(diff),c(0.9, 0.95, 0.99), na.rm = TRUE), 
				max.diff = suppressWarnings(max(abs(diff),na.rm = TRUE)), 
				max.pctdiff = suppressWarnings(max(abs(diff)/scale*100, na.rm = TRUE)), 
				max.relativediff = suppressWarnings(max(abs(diff)/abs(x),na.rm = TRUE)))
            result
        }
         statsFUN(x, ...)
    }, df = df, tol = tol, suffixes = suffixes, absoluteTol = absoluteTol)

    ok <- which(!sapply(x, is.null))
    x <- x[ok]

    x <- data.frame(t(data.frame(x)))
    row.names(x) <- vars[ok]
    x
}

