---
author: admin
comments: true
date: 2011-05-08 14:41:51
layout: post
slug: '%e5%9c%a8%e6%97%b6%e9%97%b4%e5%ba%8f%e5%88%97%e7%9a%84%e7%ba%bf%e5%9b%be%e4%b8%8a%e6%b7%bb%e5%8a%a0%e5%9e%82%e7%ba%bf'
title: 在时间序列的线图上添加垂线
wordpress_id: 705
categories:
- 计量经济学(R)
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
 
