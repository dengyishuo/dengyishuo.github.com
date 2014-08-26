##' using ggplot to find season pattern
##' 
##' using ggplot to find season pattern
##' @title using ggplot to find season pattern
##' @param startDate startDate of the data
##' @param endDate endDate of the data
##' @return xts object
##' @importFrom ggplot2 ggplot aes geom_point geom_line ggtitle annotate 
##' @export 
##' @author Yishuo Deng

bloomberg.gg.daily <- function(name,startDate=NULL, endDate=NULL,market="market",...){
     if(market=="market"){
         df         <- bloomberg.market.getData(name,startDate=startDate,endDate = endDate);
     }else if(market=="macro.daily"){
         df         <- bloomberg.macro.getData(name,startDate=startDate,endDate = endDate);
     }else{
         stop("Unsupported market time");
     }
     
     startDate  <- min(time(df));
     endDate    <- max(time(df));
     
     ## need to refine
     seq_from   <-  as.POSIXct(date.convert(startDate,format="YYYY-MM-DD"));
     seq_end    <-  as.POSIXct(date.convert(endDate,format="YYYY-MM-DD"));
     seq_dat    <-  seq.POSIXt(from=seq_from,to=seq_end,by="day");
     
	 rankofday  <-  function(x){
 		rankofday <- as.numeric(as.Date(date.convert(x,format="YYYY-MM-DD"))-as.Date(paste(substr(x,1,4),"01-01",sep="-")))+1;
 		invisible(rankofday);
 	 }
	 
 	time_dat     <- zoo(rankofday(seq_dat),seq_dat);
	df           <- na.locf(merge(df,time_dat),fromLast = FALSE);
	df           <- as.data.frame(df);
	var          <- colnames(df);
	df$year      <-  substring(as.character(rownames(df)),1,4);
 	df$month     <-  substring(as.character(rownames(df)),6,7);
	df$day       <-  substring(as.character(rownames(df)),9,10);
 	colnames(df) <- c("value","dayrank","year","month","day");
	maxYears <- which(df$year==max(df$year));
        tmpDf    <-  data.frame(dayrank = df$dayrank, month = df$month);
        tmpDf    <- tmpDf[order(tmpDf$month, tmpDf$dayrank), ];     
        keyDates <- tmpDf$dayrank[!duplicated(tmpDf$month)]; 
        values   <- df$value;
     if(market=="market"){
         titleStr     <- p("(",max(rownames(df)),") ",name,": ",round(values[length(values)],2),"  diff: ",round(100*(values[length(values)]-values[length(values)-1]),2)," bps");
     }else if(market=="macro.daily"){
         titleStr     <- p("(",max(rownames(df)),") ",name,": ",round(values[length(values)],2),"  diff: ",round(values[length(values)]-values[length(values)-1],2));
     }else{
         stop("Unsupported market time");
     }
	p <- ggplot(df,aes(x=dayrank,y=value,group=year,color=year));
 	p+geom_line(size=1)+ylab(var)+xlab("month")+ggtitle(titleStr)+scale_x_continuous("x axis",breaks=keyDates,labels = c("01","02","03","04","05","06","07","08","09","10","11","12"));
     
 	}
