price_trend_signal <- function(btdata,n=20){
	btdata$sma <- SMA(btdata$price,n);
	btdata$diff <- btdata$price-btdata$sma
	flag <- function(x){ifelse(x>=0,1,-1)}
	btdata$signal <- apply(btdata$signal,1,flag);
	btdata <- as.data.frame(na.omit(btdata))
}