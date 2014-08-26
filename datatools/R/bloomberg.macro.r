##' Macro data from bloomberg
##'
##' Macro data from bloomberg
##' @title Macro data from bloomberg
##' @param name ticker of bloomberg
##' @param startDate startDate of data
##' @param endDate endDate of data
##' @param verbose whether to plot and print
##' @param ... 
##' @return data frame and plot
##' @importFrom quantutils date.convert
##' @importFrom quantutils dot.date.convert
##' @importFrom RMySQL dbGetQuery
##' @importFrom xts as.xts
##' @importFrom xtsExtra plot.xts
##' @importFrom TTR SMA
##' @export
##' @author Weilin Lin
bloomberg.macro = function(name, startDate=NULL, endDate=NULL,verbose=TRUE,...){
  if(is.null(startDate)){
    startDate = 19900101;
  }
  
  if(is.null(endDate)){
    endDate = date.currentDate();
  }
  startDate = date.convert(startDate, format="YYYYMMDD");
  endDate   = date.convert(endDate, format="YYYYMMDD");
  matchDf = data.frame(query=c("cpi","export","fai","fdi","gdp",
                               "import","m1","m2","loan","pmi",
                               "ppi","retail","vai","finance",
                               "gdp.us","consum.us","unemployment.us"),
                       match=c("CPI_YOY_P","EXPORT_YOY_P","FAI_YOY_P","FDI_YOY_P","GDP_YOY_P",
                               "IMPORT_YOY_P","M1_YOY_P","M2_YOY_P","NEWLOAN_B","PMI",
                               "PPI_YOY_P","RETAIL_YOY_P","VAI_YOY_P","AGGREGATE_FINANACE_B",
                               "US_GDP_QOQ","US_CONSUMPTION","US_UNEMPLOYMENT"));
  if(name%in%matchDf$query) {
    match_var = matchDf$match[which(matchDf$query==name)];
  }else{
    match_var = name;
  }
  sqlStr = p("SELECT * FROM bloomberg WHERE name='",match_var,"'");
  data = dbGetQuery(DBChannel.sigmaMacro, sqlStr);
  vars = unique(data$name);
  name_appro = match_var;
  data = subset(data, name==name_appro);
  data$date = date.convert(dot.date.convert(data$date, format="%Y-%m-%d"), format="YYYYMMDD");
  data = subset(data, (date>=startDate) & (date<endDate));
  data = as.xts(data[,c("released","survey")], date.convert(data$date));
  if(verbose) {
      plot(data,screens = c(1,1),xlab="date",ylab="Released & Survey",main=p("(",max(time(data)),") ",name,": ",round(as.vector(data[nrow(data),"released"]),2), "  diff: ",round(as.vector(data[nrow(data),"released"])-as.vector(data[nrow(data)-1,"released"]),2)),...);
      legend("topright", c("released","survey"), cex=1.0, bty="n",lty=1,lwd=2,col=c("black","red"));      
  }
  
  tmp = as.vector(na.omit(data$released));
  x   = tmp;
  f   = ecdf(x);
  latest = tmp[length(tmp)];
  if(verbose){
  cat(p("latest: ",latest,",  ",round(f(latest)*100,2),"%","\n\n"));
  print(summary(as.vector(data$released)));
  }
  invisible(data);
}
