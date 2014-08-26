##' expand Path
##'
##' expand Path
##' @title expand Path
##' @param path path
##' @return path
##' @author Weilin Lin
##' @export
utils.expandPath <- function(path) {
    if (is.na(!is.dir(path))) {
        stop(path, " Not a valid directory")
    }
    path <- path.expand(path)
    if (!file.exists(path))
        stop("Unknown path ", path, "\n")
    return(path)
}
