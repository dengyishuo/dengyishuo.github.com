##' Use dot.date.convert to Convert time format 
##'
##' Use dot.date.convert to Convert time format 
##' @title Use dot.date.convert to Convert time format 
##' @param time Time to convert to new format
##' @param format New format of Time
##' @return An object with new format
##' @export 
##' @author Weilin Lin
date.convert <- function(time, format = NULL) {
    if (all(nchar(time) > 10)){
        time <- substring(time, 1, 10)
        time <- as.POSIXct(strptime(time, "%Y-%m-%d"), tz = "")
        if (is.null(format)) {
            return(time)
        } 
		else {
             format <- gsub("YYYY", "%Y", format)
             format <- gsub("MM", "%m", format)
             format <- gsub("DD", "%d", format)
             return(format(dot.date.convert(time), format))
        }
    }

    if (is.null(format)) {
        return(dot.date.convert(time))
    } 
	else {
         format <- gsub("YYYY", "%Y", format)
         format <- gsub("MM", "%m", format)
         format <- gsub("DD", "%d", format)
         return(format(dot.date.convert(time), format))
    }
}
