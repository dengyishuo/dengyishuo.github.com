##' backtest summary for the backtest 
##'
##' backtest summary for the backtest 
##' @title backtest summary for the backtest 
##' @param cfgLst configuration list
##' @param startDate startDate of summary 
##' @param endDate endDate of summary
##' @param pnlVar pnlVar
##' @param extraTC extra trading cost
##' @param plotToFile determine whether to plot to pdf for summary
##' @param navDf daily summary data frame
##' @export
##' @return  list with summary by different frequency
##' @author Weilin Lin
backtest.summary <- function(cfgLst, startDate=NULL, endDate=NULL, pnlVar="betaAdjPnL", extraTC=0.0020, plotToFile=TRUE, navDf=NULL) 
{
  if (is.null(startDate))
    {
      startDate <- cfgLst$startDate;
    }
  if (is.null(endDate))
    {
      endDate <- cfgLst$endDate;
    }

  if(is.null(navDf))  navDf            <- read.csv(p(cfgLst$dataOutDir, "/dailySummary.csv"), header=TRUE);
  navDf            <- navDf[which(navDf$date>=startDate & navDf$date<=endDate),];
  navDf$extraTC    <- navDf$ntnlTrd*extraTC;
  navDf$PnL        <- navDf$PnL - navDf$extraTC;
  navDf$betaAdjPnL <- navDf$betaAdjPnL - navDf$extraTC;
  navDf$cashBOD    <- -cumsum(c(0, navDf$netNtnlTrd))[-(nrow(navDf)+1)];
  navDf$cashEOD    <- -cumsum(c(navDf$netNtnlTrd));  
  summaryFile      <- p(cfgLst$dataOutDir, "/", cfgLst$alphaVar, "Summary.txt");

  max.print <- options()$max.print;
  options(max.print=50000);
  on.exit(options(max.print=max.print));

  lst <- list();
  for(freq in c("ALL", "YYYY", "YYYYMM","YYYYMMDD"))
    {
      if (freq=="ALL")
        {
          navDf$key <- rep("ALL", nrow(navDf));
        }
      else
        {
          navDf$key <- date.convert(navDf$date, format=freq);
        }

      keys <- sort(unique(navDf$key));
      summaryLst <- lapply(keys, function(key, navDf)
      {
        navDf <- navDf[which(navDf$key==key),];
        pnl              <- navDf[[pnlVar]];
        x <- data.frame(numDays= nrow(navDf), numStocks=mean(navDf$numStocks), ntnlEOD.M=mean(navDf$ntnlHldEOD)/1e6, cashEOD.M=mean(navDf$cashEOD)/1e6, ntnlBetaEOD.M=mean(navDf$ntnlBetaEOD)/1e6, ntnlTrd.M=mean(navDf$ntnlTrd)/1e6, turnover=sum(navDf$ntnlTrd)/mean(navDf$ntnlHldEOD)/2);
        y <- data.frame(ret.P=sum(pnl)/mean(navDf$ntnlHldEOD)*100, anaRet.P=mean(pnl)/mean(navDf$ntnlHldEOD)*240*100, indexRet.P=(prod(navDf$indexRet+1)-1)*100, SR=mean(pnl)/sd(pnl)*sqrt(240), margin.B=sum(pnl)/sum(navDf$ntnlTrd)*1e4, totalPnL.M=sum(pnl)/1e6, avgPnL.K=mean(pnl)/1e3, sdPnL.K=sd(pnl)/1e3, downDays=sum(pnl<0), downDaysPct.P=sum(pnl<0)/nrow(navDf)*100,totalExtraTC.M=sum(navDf$extraTC)/1e6);
        
        return(cbind(data.frame(period=key, startDate=min(navDf$date), endDate=max(navDf$date)), round(x,2), round(y,2)));
      }, navDf=navDf);

      summaryDf <- df.rbindList(summaryLst);

      lst[[freq]] <- summaryDf;
      if (freq!="YYYYMMDD")
        {
          cat(p("\n", cfgLst$alphaVar, ": ", startDate, "--", endDate, " strategy ", pnlVar, " summary by ", freq, " with extraTC.B=", extraTC*1e4, "\n"));
          print(summaryDf);
        }
      sink(summaryFile, append=(freq!="ALL"));
      cat(p("\n", cfgLst$alphaVar, ": ", startDate, "--", endDate, " strategy ", pnlVar, " summary by ", freq, "\n"));
      print(summaryDf);
      sink();
    }

  
  if (plotToFile)
   {     
  dataOutDir       <- cfgLst$dataOutDir;
  #hldDf           <- read.csv(p(dataOutDir, "/hld.csv"), header=TRUE);
  hldDf            <- navDf;
  hldDf$extraTC    <- abs(hldDf$ntnlTrd)*extraTC;
  hldDf$PnL        <- hldDf$PnL - hldDf$extraTC;
  hldDf$betaAdjPnL <- hldDf$betaAdjPnL - hldDf$extraTC;
  
  ask <- TRUE;
  if (plotToFile)
    {
      ask <- FALSE;
      plotDir <- p(dataOutDir);
      
      if (!file.exists(plotDir))
        {
          dir.create(plotDir, recursive = TRUE, showWarnings=FALSE);
        }
      
      plotFile <- p(plotDir, "/", cfgLst$alphaVar, ".pdf");
      pdf(file=plotFile, paper="a4r", width=10, height=7);
      on.exit(dev.off(), add=TRUE);
    }

  old.par <- par(no.readonly = TRUE) # all par settings which could be changed.
  on.exit(par(old.par),add=TRUE);

  ii  <- seq(1, nrow(navDf), by=max(round(nrow(navDf)/6/20)*20,10));
  
  par(mfrow=c(2,2), ask=ask);
  ## plot 1)
  plot(navDf$numStocks, type="l", main=p(cfgLst$alphaVar, " number of stocks :", startDate, "-", endDate), ylab="numStocks", xlab="date", xaxt="n");
  abline(v=ii, lty=2);
  axis(1, at=ii, labels=navDf$date[ii],las=0);
  
  ## plot 2)
  plot(navDf$ntnlHldEOD, type="l", main=p("ntnlEOD :", startDate, "-", endDate), ylab="ntnlEOD", xlab="date", xaxt="n");
  abline(v=ii, lty=2);
  axis(1, at=ii, labels=navDf$date[ii],las=0);

  ## plot 3)
  plot(navDf$ntnlTrd, type="l", main=p("ntnlTrd :", startDate, "-", endDate), ylab="ntnlTrd", xlab="date", xaxt="n");
  abline(v=ii, lty=2);
  axis(1, at=ii, labels=navDf$date[ii],las=0);

  ## plot 4)
  plot(navDf$ntnlBetaEOD, type="l", main=p("ntnlBetaEOD :", startDate, "-", endDate), ylab="ntnlBetaEOD", xlab="date", xaxt="n");
  abline(v=ii, lty=2);
  axis(1, at=ii, labels=navDf$date[ii],las=0);
  
  ## plot 5)
  pnl <- navDf[[pnlVar]];
  SR  <- round(mean(pnl)/sd(pnl)*sqrt(240),2);
  plot(cumsum(pnl), type="l", main=p("cumulative ", pnlVar, " : ", startDate, "-", endDate, " SR=", SR), ylab=paste("cumulative", pnlVar), xlab="date", xaxt="n");
  abline(v=ii, lty=2);
  axis(1, at=ii, labels=navDf$date[ii],las=0);

  ## plot 6)
  ret    <- pnl / navDf$ntnlHldBOD;
  ret[1] <- 0;
  SR     <- round(mean(ret)/sd(ret)*sqrt(240),2);
  plot(cumprod(1+ret), type="l", main=p("cumulative daily return: ", startDate, "-", endDate, " SR=", SR), ylab=paste("cumulative log return"), xlab="date", xaxt="n");
  abline(v=ii, lty=2, h=1);
  axis(1, at=ii, labels=navDf$date[ii],las=0);

  ## plot 7)
  hist(ret, main="distribution of daily return", ylab="freq", xlab="daily return");
  
  ## plot 8)
  ret <- navDf$indexRet;
  SR  <- round(mean(ret)/sd(ret)*sqrt(240),2);
  plot(cumprod(1+ret), type="l", main=p("cumulative index return: ", startDate, "-", endDate, " SR=", SR), ylab=paste("cumulative log return"), xlab="date", xaxt="n");
  abline(v=ii, lty=2, h=1);
  axis(1, at=ii, labels=navDf$date[ii],las=0);

  ## plot 9)
  pnl <- navDf[[pnlVar]];
  ret    <- pnl / navDf$ntnlHldBOD;
  ret[1] <- 0;
  indexRet <- navDf$indexRet;
  a <- min(c(cumprod(1+ret),cumprod(1+indexRet)));
  b <- max(c(cumprod(1+ret),cumprod(1+indexRet)));  
  plot(cumprod(1+ret), type="l", main=p("cumulative daily return: ", startDate, "-", endDate), ylab=paste("cumulative log return"), xlab="date", xaxt="n",col="red",ylim=c(a,b));
  lines(cumprod(1+indexRet), type="l", main=p("cumulative daily return: ", startDate, "-", endDate), ylab=paste("cumulative log return"), xlab="date", xaxt="n");  
  abline(v=ii, lty=2, h=1);
  axis(1, at=ii, labels=navDf$date[ii],las=0);
  

  
  ## plot 9)
  #tmp <- math.statsOverGroups(hldDf, byVar="daysInPort", dataVar=pnlVar, stats=c("n", "mn", "sum"),byVar.na.rm=TRUE);
  #plot(cumsum(tmp[[p(pnlVar, ".sum")]]), type="l", main=p("cumulative ", pnlVar, " based on days in the portfolio"), ylab="cumulative PnL", xlab="days in portfolio");

  ## plot 10)
  #plot(tmp[[p(pnlVar, ".n")]], type="l", main="number of stocks", ylab="numStocks", xlab="days in portfolio"); 

  ## plot 11)
  #plot(navDf$mktCapRank, type="l", main=p("mktCapRank :", startDate, "-", endDate), ylab="mktCapRank", xlab="date", xaxt="n");
  #abline(v=ii, lty=2);
  #axis(1, at=ii, labels=navDf$date[ii],las=0);

  ## return
}
  invisible(lst);
}
