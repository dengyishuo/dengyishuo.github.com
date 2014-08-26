##' Calculate cash flow of a coupon
##'
##' Calculate cash flow of a coupon
##' @title Calculate cash flow of a coupon
##' @param yrMat years to maturity
##' @param c coupon
##' @param region region of coupon
##' @export
##' @return cash flow of the coupon
##' @author Weilin Lin
dot.cf <- function(yrMat, c, region="CN"){
  if(region=="CN"){
    y = 3/100; # annualized discount rate.
  }else if(region=="US"){
    y = 6/100; # annualized discount rate.
  }else{
    stop("ERROR: Unsupported region");
  }

  n = floor(yrMat/0.25)*0.25;
  if(is.even(n/0.25)){
    # interest is setted to paid after 6 monthes.
    t  = seq(from=0.5,to=n,by=0.5);
    cf = rep(c/2, length(t));
    cf[length(cf)] = 100 + cf[length(cf)];
    cashFlow = data.frame(t=t,cf=cf);
    ## discount the cash flow.
    pv = sum(cashFlow$cf/(1+y/2)^(cashFlow$t/0.5));

  }else{
    t  = c(0.25, 0.25+seq(from=0.5, to=n, by=0.5));
    cf = rep(c/2, length(t));
    cf[length(cf)] = 100 + cf[length(cf)];
    cashFlow = data.frame(t=t,cf=cf);
    cashFlow$t = cashFlow$t - cashFlow$t[1];
    ## discount the cash flow.
    pv = sum(cashFlow$cf/(1+y/2)^(cashFlow$t/0.5));
    pv = pv/(sqrt(1+y/2));
    ## substracting the accrued interest.
    AI = 1/4*c;
    pv = pv-AI;
  }
  return(pv/100);
}
