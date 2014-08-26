##' using ggplot to find season pattern
##' 
##'  using ggplot to find season pattern
##'  @title using ggplot to find season pattern
##'  @param startDate startDate of the data
##'  @param endDate endDate of the data
##'  @return xts object
##'  @importFrom ggplot2 ggplot aes geom_point geom_line ggtitle annotate
##'  @export 
##'  @author Weilin Lin
 bloomberg.gg.month <- function(name,startDate=NULL, endDate=NULL,df = NULL){
   if(is.null(df)) df  <- bloomberg.macro.getData(name,startDate=startDate,endDate);
   df       <- na.omit(df);
   df       <- as.data.frame(df);
   var      <- colnames(df);
   df$year  <- substring(rownames(df),1,4);
   df$month <- substring(rownames(df),6,7);
   df[,1]   <- round(df[,1], 2);
   colnames(df) <- c("value","year","month");
   maxYears     <- which(df$year==max(df$year));
   p            <- ggplot(df,aes(x=month,y=value,group=year,color=year));
   p+geom_point()+geom_line()+ylab(var)+ggtitle(paste("Monthly plot",var))+ annotate("text", x = df[maxYears,"month"], y = df[maxYears,"value"], label = df[maxYears,"value"],size=4,alpha=0.5);
 }
 
