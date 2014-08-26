##' more complex optimizer for backtesting
##'
##' more complex optimizer for backtesting
##' @title more complex optimizer for backtesting
##' @param hldDf holding data frame 
##' @param alphaDf alpha data frame 
##' @param dataDf data frama
##' @param univVec universe vector
##' @param cfgLst configuration list
##' @param longIDs longIDs 
##' @param reduceIDs reduceIDs 
##' @return data frame
##' @export 
##' @author Weilin Lin
backtest.optimizedRebalance <- function(hldDf, alphaDf, dataDf, univVec, cfgLst, longIDs=NULL, reduceIDs=NULL)
{
  cfgLst$bins <- cfgLst$fwdPoints[-1] - cfgLst$fwdPoints[-length(cfgLst$fwdPoints)];
  epts          <- cfgLst$fwdPoints[-1];
  alphaVars     <- p(cfgLst$alphaVarPrefix, ".T0_", epts, "d");
  date          <- sort(unique(alphaDf$date));
  if(is.null(hldDf))  currentIDs <- NULL
  else currentIDs <- hldDf$jtid;
  tmpDf         <- na.exclude(alphaDf[which(alphaDf$jtid %in% unique(c(univVec, currentIDs))), c("jtid", "date", alphaVars)]);

  ## aggregate alpha for the index if hedging by index
  if (cfgLst$portType=="LI" & (!is.element(cfgLst$indexID, tmpDf$jtid)))   {
      dateL1         <- date.convert(date.toBusDate(date, shift=-1, region=cfgLst$region), format="YYYYMMDD");
      indexDf        <- index(startDate=dateL1, endDate=dateL1, indexID=cfgLst$indexID, region=cfgLst$region);
      indexDf        <- na.exclude(merge(indexDf[, c("jtid", "indexID", "weight")], tmpDf, by=c("jtid")));
      df             <- data.frame(jtid=cfgLst$indexID, date=date);
      for (alphaVar in alphaVars)
        {
          ## df[[alphaVar]] <- sum(indexDf[[alphaVar]]*indexDf$weight)/sum(indexDf$weight);
          df[[alphaVar]] <- 0;
        }
      tmpDf          <- rbind(tmpDf, df);
    }

  ## load risk model data
  rmDf        <- riskModel(startDate=date, endDate=date, jtids=tmpDf$jtid, riskModelCode=cfgLst$riskModelCode, dataType="expo", region=cfgLst$region)[[date]];
  covMat      <- riskModel(startDate=date, endDate=date, jtids=tmpDf$jtid, riskModelCode=cfgLst$riskModelCode, dataType="cov",  region=cfgLst$region)[[date]];
  factorNames <- riskModel(startDate=date, endDate=date, jtids=tmpDf$jtid, riskModelCode=cfgLst$riskModelCode, dataType="factorName", region=cfgLst$region)[[date]];
  tmpDf       <- merge(tmpDf, rmDf, by=c("jtid", "date"),all.x=TRUE);
  tmpDf       <- merge(tmpDf, dataDf[, c("jtid", "atv5d", "mtv5.60d", "prevClose")], all.x=TRUE);
  
  if(is.null(hldDf))  {
      hldDf            <- tmpDf;
      hldDf$shsHldBOD  <- 0;
      hldDf$ntnlHldBOD <- 0;
    }
  else
    {
      hldDf            <- merge(hldDf, tmpDf, by=c("jtid", "date"), all=TRUE);
    }

  ## handle NA
  for (var in setdiff(names(hldDf), c("jtid", "date", "srisk", "prevClose"))) hldDf[[var]][which(is.na(hldDf[[var]]))] <- 0;
  hldDf$srisk     <- ifelse(is.na(hldDf$srisk),     max(hldDf$srisk, na.rm=T), hldDf$srisk);
  hldDf$prevClose <- ifelse(is.na(hldDf$prevClose), max(hldDf$prevClose, na.rm=T), hldDf$prevClose);

  ## setup tcost coefficients
  hldDf$tcostAlpha <- cfgLst$tcostAlpha;
  hldDf$tcostBeta  <- cfgLst$tcostBeta / max(sqrt(hldDf$mtv5.60d),1, na.rm=T);  ## use max(, 1) to avoid the case when mtv5.60d is 0

  ## setup trade limit
  hldDf$ntnlTrdB <- hldDf$atv5d*cfgLst$volumeParticipationLimit;

  ## setup position limit
  if (cfgLst$portType =="L")
    {
      hldDf$stockPositionLB  <- pmin(hldDf$mtv5.60d*cfgLst$stockPositionPctLimit, cfgLst$stockPositionNtnlLimitLB, na.rm=TRUE);
      hldDf$stockPositionUB  <- pmax(pmin(hldDf$mtv5.60d*cfgLst$stockPositionPctLimit, cfgLst$stockPositionNtnlLimitUB, na.rm=TRUE), hldDf$ntnlHldBOD-hldDf$ntnlTrdB, na.rm=TRUE);
    }
  else if (cfgLst$portType =="LI")
    {
      hldDf$stockPositionUB     <- pmax(pmin(hldDf$mtv5.60d*cfgLst$stockPositionPctLimit, cfgLst$stockPositionNtnlLimitUB, na.rm=TRUE), hldDf$ntnlHldBOD-hldDf$ntnlTrdB, na.rm=TRUE);
      if (cfgLst$rebalanceRule=="simOpt" & !is.null(longIDs) & !is.null(reduceIDs))
        {
          hldDf$stockPositionLB   <- ifelse(hldDf$jtid %in% longIDs,   pmin(hldDf$mtv5.60d*cfgLst$stockPositionPctLimit, cfgLst$stockPositionNtnlLimitLB, na.rm=TRUE),0)
          hldDf$stockPositionUB   <- ifelse(hldDf$jtid %in% longIDs,   hldDf$stockPositionUB, hldDf$ntnlHldBOD);
          hldDf$stockPositionUB   <- ifelse(hldDf$jtid %in% reduceIDs, pmax(hldDf$ntnlHldBOD-hldDf$ntnlTrdB,0), hldDf$stockPositionUB);
        }
      else 
        hldDf$stockPositionLB   <- pmin(hldDf$mtv5.60d*cfgLst$stockPositionPctLimit, cfgLst$stockPositionNtnlLimitLB, na.rm=TRUE);

      hldDf$stockPositionLB     <- pmin(pmin(hldDf$stockPositionLB, hldDf$ntnlHldBOD+hldDf$ntnlTrdB), hldDf$stockPositionUB);
      
      ii                        <- which(hldDf$jtid==cfgLst$indexID)
      hldDf$stockPositionLB[ii] <- -hldDf$mtv5.60d[ii]*cfgLst$stockPositionPctLimit;
      hldDf$stockPositionUB[ii] <- 0;
      hldDf$tcostAlpha[ii]      <- 0.00001; ## assume there is very low cost for trading the index
      hldDf$tcostBeta[ii]       <- 0;
    }
  else if (cfgLst$portType =="LS")
    {
      hldDf$stockPositionLB <- -pmax(pmin(hldDf$mtv5.60d*cfgLst$stockPositionPctLimit, cfgLst$stockPositionNtnlLimit, na.rm=TRUE),  abs(hldDf$ntnlHldBOD)-hldDf$ntnlTrdB, na.rm=TRUE);
      hldDf$stockPositionUB <-  pmax(pmin(hldDf$mtv5.60d*cfgLst$stockPositionPctLimit, cfgLst$stockPositionNtnlLimit, na.rm=TRUE),  abs(hldDf$ntnlHldBOD)-hldDf$ntnlTrdB, na.rm=TRUE);
    }
  else
    stop("ERROR: unsupported portfolio type:", cfgLst$portType);

  nStocks     <- nrow(hldDf);
  nPeriods    <- length(cfgLst$fwdPoints)-1;
  cfgLst$ids  <- hldDf$jtid;
  cfgLst$eret <- NULL;
  ept         <- cfgLst$fwdPoints[length(cfgLst$fwdPoints)];
  alphaVar1   <- p(cfgLst$alphaVarPrefix, ".T0_",ept, "d");
  cfgLst$eret <- hldDf[[alphaVar1]];
  for ( i in (length(cfgLst$fwdPoints)-1):1)
    {
      bpt         <- cfgLst$fwdPoints[i];
      alphaVar2   <- p(cfgLst$alphaVarPrefix, ".T0_",bpt, "d");
      cfgLst$eret <- c(cfgLst$eret, hldDf[[alphaVar1]]-hldDf[[alphaVar2]]);
    }
  cfgLst$srisk           <- rep(hldDf$srisk,           nPeriods);
  cfgLst$stockPositionLB <- rep(hldDf$stockPositionLB, nPeriods);
  cfgLst$stockPositionUB <- rep(hldDf$stockPositionUB, nPeriods);
  cfgLst$ntnlTrdB        <- rep(hldDf$ntnlTrdB,        nPeriods);
  cfgLst$tcostAlpha      <- rep(hldDf$tcostAlpha,      nPeriods);
  cfgLst$tcostBeta       <- rep(hldDf$tcostBeta,       nPeriods);
  cfgLst$currentPosition <- hldDf$ntnlHldBOD;
  if (is.null(cfgLst$factorNames))
    cfgLst$factorNames     <- factorNames
  else
    {
      cfgLst$factorNames  <- intersect(cfgLst$factorNames, factorNames);
      factorNames         <- cfgLst$factorNames;
      if (length(cfgLst$factorNames)==0)
        stop ("ERROR: Can't find the risk factors from the risk model");
    }
  cfgLst$factorExpo      <- t(as.matrix(hldDf[, factorNames, drop=FALSE]));
  cfgLst$factorCov       <- covMat[factorNames, factorNames, drop=FALSE];
  solution               <- opt(cfgLst);
  hldDf$ntnlHldEOD       <- solution[["position"]]$ntnlTarget;
  if (sum(abs(hldDf$ntnlHldEOD),na.rm=TRUE) < 1e6) browser();
  print(round(solution[[2]]/1e6));
  cat(date);
  hldDf$shsHldEOD        <- hldDf$ntnlHldEOD / hldDf$prevClose;
  hldDf                  <- hldDf[order(hldDf$jtid), c("jtid", "date", "shsHldBOD", "ntnlHldBOD", "shsHldEOD", alphaVars)];
}
