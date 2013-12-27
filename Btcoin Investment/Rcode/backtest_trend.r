library(datatools)
utils.init()

# Get history data
btdata <- get_bt_history("2013-12-09 08:00:00","2013-12-15 24:00:00");

# Generates signal

signal <- price_trend_signal(btdata,n=20);
account <- init.account()

backtest()


