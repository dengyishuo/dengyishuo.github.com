---
author: admin
comments: true
layout: post
title: 在时间序列的线图上添加垂线
categories:
- econometrics
tags:
- r
- 垂线
- 时间序列
- 绘图
---

`
>  library(xts)
Loading required package: zoo

Attaching package: 'zoo'

The following object(s) are masked from 'package:timeSeries':

    time<-

>  v <- vector()
> v[1] <- 10
> for(i in 2:100){
+ v[i] <- v[i-1]+rnorm(1, 0, 0.01)
+ }
> X <- xts(v, seq(as.Date("2009-01-01"), by=1, length.out=100))
> plot(X)
> abline(v=X[50,])              #不行
> abline(v=50)                  #不行
> abline(v=index(X)[50])    #不行
> abline(v=.index(X)[50], col="red")    #正解
`
 
