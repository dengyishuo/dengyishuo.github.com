---
title: 在时间序列的线图上添加垂线
author: MatrixSpk
date: '2011-05-08'
slug: add-vertical-lines-to-timeseries-plot
categories:
- econometrics
tags:
- r
- 垂线
- 时间序列
- 绘图
---


``` r
library(xts)
v <- vector()
v[1] <- 10
for(i in 2:100){
    v[i] <- v[i-1]+rnorm(1, 0, 0.01)
}
X <- xts(v, seq(as.Date("2009-01-01"), by="day", length.out=100))
plot.xts(X)
# abline(v=X[50,])              #不行
# abline(v=50)                  #不行
# abline(v=index(X)[50])             #不行
abline(v =.index(X)[50],col="red")    #不行
abline(v = (.index(X)[30]), col = "blue")
```
 
