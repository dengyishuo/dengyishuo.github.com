##' plot macro by month
##'
##' plot macro by month
##' @title plot macro by month
##' @param df 
##' @param ... 
##' @return data frame
##' @importFrom quantutils df.dfToArray
##' @export
##' @author Weilin Lin
bloomberg.plot.monthly <- function(df,...){
          var <- colnames(df);
                  df <- as.data.frame(df);
                  df$month <- substring(rownames(df),6,7);
                  df$year  <- substring(rownames(df),1,4);
                  df <- df.dfToArray(df,c("month","year"),var)[,,];
                  ## plot
                  cols <- rainbow(ncol(df));
                  plot(df[,1], ty="o",ylab="",xlab="month",col=cols[1],ylim=c(min(df, na.rm=TRUE),max(df,na.rm=TRUE)),...);
                  grid();
                  for(i in 1:ncol(df)){
                                      lines(df[,i], ty="o",ylab="",xlab="month",col=cols[i],...);
                                  }
                  # strong latest obervation
                  lines(df[,i], ty="l",ylab="",xlab="month",col=cols[i],lwd=2);
                  text(1:12,df[,i],df[,i]);
                  ## add legends
                  legend("bottomleft",colnames(df), cex=1.0, bty="n",lwd=2,col=cols);
                return(df);
      }
