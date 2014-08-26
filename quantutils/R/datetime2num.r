##' transfer datetime to number
##' 
##' transfer datetime to number
##' @title transfer datetime to number
##' @param x Datetime
##' @return An number
##' @export
##' @author Yishuo Deng
datetime2num <- function(x){
  as.numeric(paste(gsub("-","",strsplit(x," ")[[1]][1]),gsub(":","",strsplit(x," ")[[1]][2]),sep=""))
}
