##' read csv data
##'
##' read csv data
##' @title read csv data
##' @param startDate start Date for data
##' @param endDate end Date for data
##' @param intervals intervals for data
##' @param shift shift
##' @param jtids symbols for stock or bonds,must be charactor.
##' @param vars variables in data
##' @param region region for data
##' @param ... other parametres
##' @return a data file
##' @importFrom RMySQL dbConnect dbGetQuery dbWriteTable
##' @export
##' @author Yishuo Deng

utils.readMySQL <- function(tablename=NULL, startDate, endDate, Dates=NULL, jtids=NULL, vars=NULL, region=NULL, ...){

    if(!is.null(tablename)){
        tablename <- tablename		     
	}
	else
    stop("You must specify a table! ")
	
	
	if(!is.null(startDate)||!is.null(endDate)){
			 if(!is.null(startDate)&&!is.null(endDate)) {
					 startDate <- date.convert(startDate, format="YYYYMMDD");
					 endDate   <- date.convert(endDate,   format="YYYYMMDD");
					 utils.checkCond(startDate <= endDate, paste("startDate(", startDate, ") must be no later than endDate(", endDate, ")"));
					 Dates <- NULL;
					 post_char_1 <- paste("WHERE date>='",startDate,"' AND date<='",endDate,"'",sep="")
			   }
			 else 
			 print("startDate and endDate should be specified the sametime or both be NULL! ")
	}
	else 
	if(!is.null(Dates)){
				 Dates <- date.convert(Dates)
				 post_char_1 <- paste("WHERE date in ","(",paste(paste(Dates,"'",sep=""),collapse=","),")",sep="")
	}
	else 
	print("startDate, endDate and Dates can't be NULL at the sametime! " )
  
 	if(!is.null(vars)){
	pre_char <- paste("date,jtid",paste(vars,collapse=","),sep=",")
	}
	else
	pre_char <- "*"
	
	if(!is.null(jtids)){
	if(!is.character(jtids)){
	print("jtids must be charator! ")
	}
	else
	post_char_2 <- paste("AND jtid in ",paste("(",paste(paste("'",jtids,"'",sep=""),collapse=","),")",sep=""),sep="");
	Query <- paste("SELECT",pre_char,"FROM",tablename,post_char_1,post_char_2);
	}
	else
	Query <- paste("SELECT",pre_char,"FROM",tablename,post_char_1)
	
	data <- dbGetQuery(DBChannel,Query)
	invisible(data);
}
