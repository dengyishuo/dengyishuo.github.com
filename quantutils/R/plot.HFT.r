##' plot function for HFT data
##'
##' plot function for HFT data
##' @title plot function for HFT data
##' @param data 
##' @param var plot var
##' @param ... 
##' @return NULL
##' @export
##' @author Weilin Lin
plot.HFT <- function(data, var = NULL, ...){
    # data should has three columns, (date, time, value);
    if(is.null(var)) var <- colnames(data)[ncol(data)];
    ii <- which(!duplicated(data$date));
    plot(data[,var], ty="l", xlab="date", xaxt="n", ...);
    abline(v=ii, lty=2);
    axis(1, at=ii, labels=data$date[ii],las=0);    
}
