##' reads beta
##'
##' reads beta
##' @title reads beta
##' @param startDate start Date
##' @param endDate end Date
##' @param jtids stock symbols
##' @param vars varibles
##' @param region region
##' @param ... other parameters
##' @export 
##' @return beta
##' @author Weilin Lin
                
beta <- function(startDate, endDate = startDate, jtids = NULL, vars = NULL, region = "CN",inDir=NULL, UPDN=0,source="MySQL",...) {
    if(source=="CSV"){
		if (is.null(inDir)){
			 inDir <- p(DATA.DIR, "/", tolower(region), "/daily/derived/beta");
		}
		if (UPDN == 0){
		filePrefix <- "beta";
		}
		if(UPDN == 1){
		filePrefix <- "betaUP";
		}
		 if(UPDN == -1){
		   filePrefix <- "betaDN";
		}
		dailyDf <- utils.readCSV(jtids, startDate=startDate, endDate=endDate, vars=vars, region=region, dataDir=inDir, filePrefix=filePrefix,...);
	}
	else{
	     dailyDf <- utils.readMySQL("daily.beta", startDate = startDate, endDate = endDate, jtids, vars = vars, region = region, ...)
	}
    invisible(dailyDf)	 
}
