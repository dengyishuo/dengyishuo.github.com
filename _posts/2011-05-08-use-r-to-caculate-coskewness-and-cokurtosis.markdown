---
layout: post
title: 用R计算协偏度（coskewness）和协峰度（cokurtosis）
comments: true
categories:
- 金融投资分析(R)
tags:
- cokurtosis
- coskewness
- 协偏度
- 协峰度
---

PerformanceAnalytics包中提供了CoSkewness()和CoKurtosis()函数来计算两个资产间的协偏度（co-skewness）和协峰度(co-kurtosis)。
例如：
`
>library(PerformanceAnalytics)  #载入包
>data(managers)                    #加载managers数据集
>CoSkewness(managers[, "HAM2", drop=FALSE], managers[, "SP500 TR", drop=FALSE]) #计算协偏度
[1] -2.101289e-06
>CoKurtosis(managers[, "HAM2", drop=FALSE], managers[, "SP500 TR", drop=FALSE]) #计算协峰度
[1] 2.579066e-06
`

