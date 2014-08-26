##' write an SDIV array or data.frame to daily CSV files to outDir/filePrefixYYYYMMDD.csv
##'
##' write an SDIV array or data.frame to daily CSV files to outDir/filePrefixYYYYMMDD.csv
##' @title write an SDIV array or data.frame to daily CSV files to outDir/filePrefixYYYYMMDD.csv
##' @param data Data
##' @param outDir out Direction
##' @param filePrefix Prefix of files when write out datas
##' @param startDate The start Date of data
##' @param endDate The end Date of data
##' @param vars Variables in data
##' @param shift shift the date forward or backward n business days (e.g, if the data$date is 20090601, shift = 1, then shift data$date to 20090602 and then write to filePrefix20090602.csv 
##' @param region The region of data
##' @param verbose Logical
##' @param quote Logical
##' @param row.names Logical
##' @param fileNameDelimiter  Delimiter of file names
##' @param ... are the extra arguments from write.table() function (e.g. quote=FALSE,row.names=FALSE)
##' @return null
##' @export
##' @author Weilin Lin
utils.writeCSV <- function(data, outDir, filePrefix = "data", startDate = NULL,
    endDate = NULL, vars = NULL, shift = 0, region = NULL, verbose = FALSE, quote = FALSE,
    row.names = FALSE, fileNameDelimiter = "_", ...) {
    if (class(data) == "array") {
        utils.checkCond(length(dim(data)) == 4, "must give an SDIV array")
        data <- df.sdivToDf(data)
    } else if (class(data) == "data.frame") {
        utils.checkCond(all(is.element("date", names(data))), "must give an data.frame with column date")
    } else stop("must give an SDIV array or data.frame")

    ## check keys and vars
    keys <- intersect(c("jtid", "date", "interval"), names(data))
    if (is.null(vars))
        vars <- setdiff(names(data), keys) else {
        noExistVars <- setdiff(vars, names(data))
        utils.checkCond(length(noExistVars) == 0, paste("Cannot find the following variables in data : ",
            paste(noExistVars, collapse = ", ")))
    }

    ## process dates
    if (shift != 0) {
        utils.checkCond(!is.null(region), "Must specify region to shift date")
        data$date <- date.convert(date.toBusDate(data$date, region = region, shift = shift),
            format = "YYYYMMDD")
    }

    dates <- sort(unique(data$date))
    if (!is.null(startDate))
        dates <- dates[dates >= startDate]
    if (!is.null(endDate))
        dates <- dates[dates <= endDate]
    if (length(dates) > 0) {
        ## create dir
        if (!file.exists(outDir))
            dir.create(outDir, recursive = TRUE, showWarnings = FALSE)
        lapply(dates, function(date, data, outDir, filePrefix, keys, vars, verbose,
            quote, row.names, ...) {
            df <- data[which(data$date == date), , drop = FALSE]
            file <- p(outDir, "/", filePrefix, fileNameDelimiter, date, ".csv")
            if (verbose)
                utils.log("Write data to ", file)
            # browser()
            write.csv(df[, setdiff(c(keys, vars), "date"), drop = FALSE], file,
                quote = quote, row.names = row.names, fileEncoding = "UTF-8",
                ...)
            invisible()
        }, data = data, outDir = outDir, filePrefix = filePrefix, keys = keys,
            vars = vars, verbose = verbose, quote = quote, row.names = row.names,
            ... = ...)
    }
    if (verbose)
        cat("Write Data DONE\n")
    invisible()
}
