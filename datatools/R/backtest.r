##' backtest main function
##'
##' backtest main function
##' @title backtest main function
##' @param cfgLst configuration list
##' @return cfgLst
##' @export 
##' @author Weilin Lin
##' 
backtest <- function(cfgLst)
{    
  ## create output directory
  if(file.exists(cfgLst$dataOutDir) & cfgLst$runFromScratch) unlink(cfgLst$dataOutDir, recursive=TRUE);
  if(!file.exists(cfgLst$dataOutDir))  dir.create(p(cfgLst$dataOutDir), recursive = TRUE, showWarnings=FALSE);

  ## handle date
  alphaFiles <- sort(list.files(cfgLst$alphaDir, pattern=p(cfgLst$alphaFilePrefix, "_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"), full.names=TRUE));
  #dates      <- sort(unique(utils.substring(alphaFiles, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]")));
  dates <- date.convert(date.range(cfgLst$startDate,cfgLst$endDate,region=cfgLst$region),format="YYYYMMDD")

  if (is.null(cfgLst$startDate))
    {
      cfgLst$startDate <- min(dates);
    }

  if (is.null(cfgLst$endDate))
    {
      cfgLst$endDate <- max(dates);
    }

  startDate <- cfgLst$startDate;
  endDate   <- cfgLst$endDate;
  utils.checkCond(startDate <= endDate, paste("startDate(", startDate, ") must be no later than endDate(", endDate, ")"));
  startDate <- date.convert(startDate, format="YYYYMMDD");
  endDate   <- date.convert(  endDate, format="YYYYMMDD");
  dates     <- sort(dates[which(dates>=startDate & dates<=endDate)]);
  
  if (cfgLst$region=="HK")
    dates <- setdiff(dates, c("20080123","20100510")); ## There is no Heng Seng Index data in QT_HKDailyQuote on 2010-05-10

  ## handle alphaLst
  if (is.null(cfgLst$alphaLst))
    {
      cfgLst <- backtest.loadAlpha(cfgLst=cfgLst)
    }

  ## handle univLst
  if (is.null(cfgLst$univLst))
    {
      cfgLst <- backtest.loadUniv(cfgLst=cfgLst);
    }
  
  ## handle dataLst
  if (is.null(cfgLst$dataLst))
    {
      cfgLst <- backtest.loadData(cfgLst=cfgLst);
    }

  if (cfgLst$runFromScratch)
    {
      hldLst    <- list();
      navLst    <- list();
    }
  else
    {
      hldLst      <- utils.readCSV(dataDir=hldDir, filePrefix="hld",region=cfgLst$region, outClass="list");
      navDf       <- read.csv(p(cfgLst$dataOutDir, "/dailySummary.csv"));
      navDf       <- navDf[which(navDf$date<navDf$startDate | navDf$date>navDf$endDate),];
      startDateL1 <- date.convert(date.toBusDate(min(dates), shift=-1, region=cfgLst$region), format="YYYYMMDD");
      navLst      <- list();
      navLst[[startDateL1]] <- navDf;
    }

  ## print backtest configuration settings
  utils.log("run back test for the following configuration:")
  print (cfgLst[names(cfgLst)[-grep("Lst$", names(cfgLst))]]);
  sink(p(cfgLst$dataOutDir, "/cfg.R"));
  dput(cfgLst[names(cfgLst)[-grep("Lst$", names(cfgLst))]]);
  sink();  
  utils.log("Backtest Start for", cfgLst$alphaVar, "from", cfgLst$startDate, "to", cfgLst$endDate);
  for (date in dates)
    {        
      cat(date);
      dateL1 <- date.convert(date.toBusDate(date, shift=-1, region=cfgLst$region), format="YYYYMMDD");
      if (date %in% names(cfgLst$alphaLst))
        {
          alphaDf <- cfgLst$alphaLst[[date]];
        }
      else
        stop("ERROR: need to update cfgLst$alphaLst for date:", date);

        if (date %in% names(cfgLst$dataLst))
        {
          dataDf <- cfgLst$dataLst[[date]];
        }
      else
        stop("ERROR: need to update cfgLst$dataLst for date:", date);

        if (date %in% names(cfgLst$univLst))
        {
          univVec <- cfgLst$univLst[[date]];
        }
        else
          stop("ERROR: need to update cfgLst$univLst for date:", date);

      if (dateL1 %in% names(hldLst))
        {  
          prevHldDf        <- hldLst[[dateL1]];
          hldDf            <- merge(prevHldDf, dataDf, by="jtid", all.x=TRUE, suffix=c(".L1", ""));
          hldDf$prevClose  <- ifelse(is.na(hldDf$prevClose), hldDf$close.L1, hldDf$prevClose);
          hldDf$ntnlHldBOD <- hldDf$ntnlHldEOD;
          hldDf$shsHldBOD  <- round(hldDf$ntnlHldBOD / hldDf$prevClose);
          hldDf            <- hldDf[which(abs(hldDf$ntnlHldBOD)>0), c("jtid", "date", "shsHldBOD", "ntnlHldBOD")];
          hldDf$date       <- rep(date, nrow(hldDf));
        }
      else
        {
          hldDf <- NULL;
        }

      
      if(cfgLst$rebalanceRule=="simple"){          
          hldDf <- backtest.simpleRebalance(hldDf, alphaDf, dataDf, univVec, cfgLst);          
        } else if (cfgLst$rebalanceRule=="optimized"){
          hldDf <- backtest.optimizedRebalance(hldDf, alphaDf, dataDf, univVec, cfgLst);
        }  else if (cfgLst$rebalanceRule=="simOpt"){
          date          <- sort(unique(alphaDf$date));
          tmpDf         <- na.exclude(alphaDf[which(alphaDf$jtid %in% univVec | alphaDf$jtid %in% hldDf$jtid), c("jtid", "date", cfgLst$alphaVar)]);
          tmpDf         <- tmpDf[which(tmpDf$jtid %in% dataDf$jtid[dataDf$volume>0]),];   ## get rid non-tradable stocks for the given date
          tmpDf         <- tmpDf[order(tmpDf[[cfgLst$alphaVar]]), ];
          
          nStocks       <- nrow(tmpDf);
          nInStocks     <- cfgLst$tradeInThreshold;
          nOutStocks    <- cfgLst$tradeOutThreshold;          
          mustLongIDs   <- tmpDf[(nStocks - nOutStocks+1) : (nStocks - nInStocks+1), "jtid"];
          utils.checkCond((nInStocks>=1) & (nInStocks>nOutStocks), "Wrong tradeInThreshold or tradeOutThreshold setting");
          topExtraIDs   <- ifelse(nInStocks>1,tmpDf[nStocks - nInStocks+2 : nStocks, "jtid"],NULL);
          reduceZeroIDs <- c(tmpDf[1:(nStocks - nOutStocks), "jtid"],topExtraIDs);          
          hldDf         <- backtest.optimizedRebalance(hldDf, alphaDf, dataDf, univVec=univVec, cfgLst, longIDs=unique(mustLongIDs), reduceIDs=c(reduceZeroIDs, keepShortIDs, mustShortIDs));
        } else {
        stop ("ERROR: unsupported portfolio construction rule:", cfgLst$portConstrRule);
        }
      
      hldDf <- backtest.accounting(hldDf=hldDf, dataDf=dataDf, cfgLst=cfgLst);
      hldLst[[date]] <- hldDf;      
      navLst[[date]] <- backtest.dailySummary(hldDf);
      cat("\b\b\b\b\b\b\b\b");
    }
  cat("\n");
  utils.log("Backtest for", cfgLst$alphaVar, "DONE");

  navDf <- df.rbindList(navLst);
  write.csv(navDf, p(cfgLst$dataOutDir, "/dailySummary.csv"), row.names=FALSE, quote=FALSE);
  
  if ("saveHldFiles" %in% names(cfgLst))
    if (!cfgLst$saveHldFiles)
      {
        return(invisible(cfgLst));
      }
  else
    {
      hldDir <- p(cfgLst$dataOutDir, "/hld");
      if (!file.exists(hldDir))            dir.create(hldDir,               recursive = TRUE, showWarnings=FALSE);
      hldDf <- df.rbindList(hldLst);      
      utils.writeCSV(hldDf, outDir=hldDir, filePrefix="hld", startDate=startDate, endDate=endDate, region=cfgLst$region);
    }

  invisible(cfgLst);
}
