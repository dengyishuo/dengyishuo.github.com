##' assert whether two objects are equal
##'
##' assert whether two objects are equal
##' @title assert whether two objects are equal
##' @param expected result expected
##' @param generated result generated
##' @param msg massage
##' @param printInputsOnDiff logical
##' @param errorFunc function for error
##' @param ... other parameters needed
##' @return logical
##' @export
##' @author Weilin Lin
utils.assertEquals <- function(expected, generated, msg = NULL, printInputsOnDiff = TRUE, errorFunc = "stop", ...) {
    
	comp <- all.equal(expected, generated, ...)

    if (is.null(msg))
        msg <- "Expected and generated values were not equal"

    if (mode(comp) != "logical" || comp != TRUE) {
        cat(msg, "\n")
        cat("EXPECTED:\n")
        if (printInputsOnDiff)
            print(expected)
        cat("GENERATED:\n")
        if (printInputsOnDiff)
            print(generated)

        if (class(errorFunc) == "character" && errorFunc == "stop") {
            stop(comp)
        } else {
            errorFunc(comp)
        }
    }
}
