##' get market information data
##'
##' get market information data
##' @title get market data
##' @param name symbol of the bloomberg ticker
##' @param startDate startDate of data
##' @param endDate endDate of data
##' @param addSMA if add simple moving average line to the plot
##' @param ifPlot if plot to the window
##' @param ... 
##' @return data frame and plot
##' @importFrom quantutils date.convert
##' @importFrom quantutils dot.date.convert
##' @importFrom RMySQL dbGetQuery
##' @importFrom xts as.xts
##' @importFrom xtsExtra plot.xts
##' @importFrom TTR SMA
##' @importFrom PerformanceAnalytics chart.TimeSeries
##' @export
##' @author Weilin Lin
##' 
bloomberg.market = function(name, startDate=NULL, endDate=NULL,addSMA=FALSE,ifPlot=TRUE,...){
  if(is.null(startDate)){
    startDate = 19900101;
  }
  if(is.null(endDate)){
    endDate = date.currentDate();
  }
  startDate = date.convert(startDate, format="YYYYMMDD");
  endDate   = date.convert(endDate, format="YYYYMMDD");
  match_var = name;
  sqlStr = p("SELECT * FROM bloomberg_daily WHERE name='",match_var,"'");
  data = dbGetQuery(DBChannel.sigmaMacro, sqlStr);
  vars = unique(data$name);
  name_appro = match_var;
  data = subset(data, name==name_appro);
  data$date = date.convert(dot.date.convert(data$date, format="%Y-%m-%d"), format="YYYYMMDD");
  data = subset(data, (date>=startDate) & (date<=endDate));
  data = as.xts(data$value, date.convert(data$date));
  colnames(data) <- name;
  if(ifPlot & !addSMA){
      #plot(data, xlab="date",ylab="", main=p("(",max(time(data)),") ",name,": ",round(as.vector(data[length(data)]),2),"  diff: ",round(100*(as.vector(data[length(data)])-as.vector(data[length(data)-1])),2)," bps"), ...);
      chart.TimeSeries(data, xlab="date",ylab="", main=p("(",max(time(data)),") ",name,": ",round(as.vector(data[length(data)]),2),"  diff: ",round(100*(as.vector(data[length(data)])-as.vector(data[length(data)-1])),2)," bps"), ...);
  }

  if(ifPlot & addSMA){
      data$MA5     <- SMA(data,5);
      values       <- as.vector(data[,name]);
      plot(data, xlab="date",ylab="", main=p("(",max(time(data)),") ",name,": ",round(values[length(values)],2),"  diff: ",round(100*(values[length(values)]-values[length(values)-1]),2)," bps"),screens = c(1,1),...);
      legend("topright", c(name,"MA5"), cex=1.0, bty="n",lty=1,lwd=2,col=c("black","red"));
  }    

  tmp = na.omit(as.vector(data[,name]));
  x   = tmp;
  f   = ecdf(x);
  latest = tmp[length(tmp)];
  if(ifPlot){
  cat(p(match_var,"_latest: ",latest,",  ",round(f(latest)*100,2),"%","\n\n"));
  cat(p("latest change ",round((tmp[length(tmp)]-tmp[length(tmp)-1])*100,2),"\n\n"));
  print(summary(as.vector(data)));
  }
  invisible(data[,name]);
}