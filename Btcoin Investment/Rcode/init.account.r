# set account

init.account <- function(cash=50000,btcoin=0,feerate=0.003,fee=0,risk_free=0.03,...){
  account <- list(cash=NULL,btcoin=NULL,price=NULL,feerate=NULL,fee=NULL,trade_log=NULL)
  account$cash[1]=cash;
  account$btcoin[1]=btcoin;
  account$feerate[1]=feerate
  account$fee[1]=fee
  account$price=NULL
  account
}