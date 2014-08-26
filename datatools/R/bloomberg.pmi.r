##' PMI panel 
##'
##' PMI panel
##' @title PMI panel
##' @param startDate 
##' @param endDate 
##' @param ... 
##' @return xts object
##' @importFrom timeSeries as.timeSeries
##' @export
##' @author among group
bloomberg.pmi <- function(startDate=NULL, endDate=NULL,...){
        df <- bloomberg.macro.getData(c("PMI","PMI_Production","PMI_NewOrder","PMI_Import","PMI_Export","PMI_OnHandOrder"), startDate=startDate, endDate=endDate);        
        df_ts <- as.timeSeries(df);
        plot(df_ts, plot.type="single", ylab="PMI Component", main=p("Latest day: ",as.character(time(df_ts)[nrow(df_ts)])),col=palette()[1:ncol(df_ts)],...);
        legend("bottomright",legend=colnames(df_ts),col=palette()[1:ncol(df_ts)],lty=1,lwd=2, cex=1.0, bty="n");        
        #bloomberg.plot.monthly(df[,"PMI"]);
        #colVec <- palette()[1:ncol(df_ts)];
        #for(i in 1:ncol(df)){
        #        plot(df[,i], main=p(colnames(df)[i],", diff: ",round((as.vector(df[nrow(df),i])-as.vector(df[nrow(df)-1,i])),2)),...);
        #    }
        
}
