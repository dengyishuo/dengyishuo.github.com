 tickers = c( "VNO" , "VMC" , "WMT" , "WAG" , "DIS" , "WPO" , "WFC" , "WDC" ,
 "WY" , "WHR" , "WMB" , "WEC" , "XEL" , "XRX" , "XLNX" ,"ZION" ,"MMM" ,
 "ABT", "ADBE" , "AMD" , "AET" , "AFL" , "APD" , "ARG" ,"AA" , "AGN" ,
 "ALTR" , "MO" , "AEP" , "AXP" , "AIG" , "AMGN" , "APC" ,"ADI" , "AON" ,
 "APA", "AAPL" , "AMAT" ,"ADM" , "T" , "ADSK" , "ADP" , "AZO" , "AVY" ,
 "AVP", "BHI" , "BLL" , "BAC" , "BK" , "BCR" , "BAX" , "BBT" , "BDX" ,
 "BMS" , "BBY" , "BIG" , "HRB" , "BMC" , "BA" , "BMY" , "CA" , "COG" ,
 "CPB" , "CAH" , "CCL" , "CAT" , "CELG" , "CNP" , "CTL" , "YHOO", "CERN" ,
 "SCHW" , "CVX" , "CB" , "CI" ,"CINF" ,"CTAS" , "CSCO" , "C" , "CLF" ,
 "CLX", "CMS" , "KO" , "CCE" , "CL" , "CMCSA" ,"CMA" , "CSC" , "CAG" ,
 "COP" , "ED" , "QQQ" ,"GLW" , "COST" , "CVH" , "CSX" , "CMI" , "CVS" ,
 "DHR" , "DE")

 library(quantmod);
 getSymbols(tickers, from = "2000-12-01", to = "2010-12-31")
 P <- NULL; seltickers <- NULL
 for(ticker in tickers) {
 tmp <- Cl(to.monthly(eval(parse(text=ticker))))
 if(is.null(P)){ timeP = time(tmp) }
 if( any( time(tmp)!=timeP )) next
 else P<-cbind(P,as.numeric(tmp))
 seltickers = c( seltickers , ticker )
 }
 P = xts(P,order.by=timeP)
 colnames(P) <- seltickers
 R <- diff(log(P))
 R <- R[-1,]
 dim(R)
 mu <- colMeans(R)
 sigma <- cov(R)

 library("PerformanceAnalytics")
 obj <- function(w) {
 if (sum(w) == 0) {
 w <- w + 1e-2
 }
 w <- w / sum(w)
 CVaR <- ES(weights = w,
 method = "gaussian",
 portfolio_method = "component",
 mu = mu,
 sigma = sigma)
 tmp1 <- CVaR$ES
 tmp2 <- max(CVaR$pct_contrib_ES - 0.05, 0)
 out <- tmp1 + 1e3 * tmp2
 return(out)
 }

 N <- ncol(R)
 minw <- 0
 maxw <- 1
 lower <- rep(minw,N)
 upper <- rep(maxw,N)

 source("constraints.R")
 source("random_portfolios.R")
 eps <- 0.025
 weight_seq<-generatesequence(min=minw,max=maxw,by=.001,rounding=3)
 rpconstraint<-constraint(
 assets=N, min_sum=(1-eps), max_sum=(1+eps),
 min=lower, max=upper, weight_seq=weight_seq)
 set.seed(1234)
 rp<- random_portfolios(rpconstraints=rpconstraint,permutations=N*10)
 rp <-rp/rowSums(rp)