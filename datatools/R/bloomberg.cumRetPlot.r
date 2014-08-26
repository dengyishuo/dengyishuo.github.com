##' cunmRet plot for asset price
##'
##' cunmRet plot for asset price
##' @title cunmRet plot for asset price
##' @param indexNames indexNames
##' @param ChiNames ChiNames
##' @param startDate startDate
##' @param endDate endDate
##' @param monthLabel whether use month label
##' @param ... others
##' @return gg plt
##' @importFrom ggplot2 ggplot aes geom_point geom_line ggtitle annotate
##' @importFrom reshape melt
##' @export 
##' @author Weilin Lin
bloomberg.cumRetPlot <- function(indexNames,ChiNames = NULL,startDate=NULL, endDate=NULL,monthLabel=TRUE,...){
  if(is.null(ChiNames)) ChiNames = indexNames;
  data = bloomberg.market.getData(indexNames, startDate = startDate, endDate = endDate);
  data = as.data.frame(data);
  data = cumsum(data);  
  data[1,] = 0;
  colnames(data) <-  ChiNames;
  data$date      <-  rownames(data);
  dates          <-  data$date;
  data           <-  melt(data, id = "date");
  data$year      <-  substring(as.character(data$date),1,4);
  data$month     <-  substring(as.character(data$date),6,7);
  data$yearmonth <-  substring(as.character(data$date),1,7);
  data$day       <-  substring(as.character(data$date),9,10); 
  keyDates       <-  data$date[!duplicated(data$yearmonth)];
  tmpDf          <- data.frame(date = dates, x = 1:length(dates));
  keyDates_x     <- tmpDf$x[match(keyDates, tmpDf$date)];
  data           <- merge(data, tmpDf, by = "date");
  data           <- data[order(data$variable, data$x),];
  if(monthLabel){
    p = ggplot(data,aes(x=x,y=value,group=variable,color=variable));
    p+geom_line(size=0.5)+ylab("Cumreturn(%)")+xlab("date")+ggtitle("sector index")+scale_x_continuous("x axis",breaks=keyDates_x,
                                                                                           labels=substring(keyDates,1,7));
  }else{
    p = ggplot(data,aes(x=date,y=value,group=variable,color=variable));
    p+geom_line(size=0.5)+geom_point(size=2)+ylab("Cumreturn(%)")+xlab("date")+ggtitle("sector index");
  }

}
