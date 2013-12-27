signal2return <- function(data,signal,account){
newdata <- merge(data[,],signal$signal);
for(i in 1:dim(btdata)[1]){
  flag=btdata[i,]$sma_flag
  feerate <- account$feerate
  if(flag==1){
    price <- btdata[i,]$ask1;
    volume <- btdata[i,]$ask1_size;
    tradevolume <- min(tail(account$cash,1)/(price*(1+feerate)),volume);
    account$fee[length(account$fee)+1] <- tail(account$fee,1)+tradevolume*price*feerate;
    account$cash[length(account$cash)+1]<- tail(account$cash,1)-tradevolume*price*(1+feerate);
    account$btcoin[length(account$btcoin)+1]<- tail(account$btcoin,1)+tradevolume;
    account$price <- btdata[i,]$bid1;
  }
  else{
    price <- btdata[i,]$bid1;
    volume <- btdata[i,]$bid1_size;
    tradevolume <- min(tail(account$btcoin,1),volume);
    account$fee[length(account$fee)+1] <- tail(account$fee,1) + tradevolume*price*feerate;
    account$cash[length(account$cash)+1]<- tail(account$cash,1) + tradevolume*price*(1+feerate);
    account$btcoin[length(account$btcoin)+1]<- tail(account$btcoin,1) - tradevolume;
    account$price <- btdata[i,]$bid1;
  }
}
}