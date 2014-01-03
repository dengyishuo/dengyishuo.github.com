get_bt_history <- function(startdatetime,enddatetime,...){
	t_data <- get_bt_trade(startdatetime,enddatetime,vars="price");
	q_data <- get_bt_depth(startdatetime,enddatetime,vars=c("ask1","bid1","ask1_size","bid1_size"));
	btdata <- merge(t_data,q_data,by.x="DATETIME",by.y="datetime",all=T);
	btdata$price <- na.locf(btdata$price,na.rm=F);
	btdata=na.omit(btdata);
    invisible(btdata);
}