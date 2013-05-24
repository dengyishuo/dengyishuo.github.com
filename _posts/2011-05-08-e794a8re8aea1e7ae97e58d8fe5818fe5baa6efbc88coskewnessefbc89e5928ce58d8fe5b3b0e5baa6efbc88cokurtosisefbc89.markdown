---
author: admin
comments: true
date: 2011-05-08 11:02:09
layout: post
slug: '%e7%94%a8r%e8%ae%a1%e7%ae%97%e5%8d%8f%e5%81%8f%e5%ba%a6%ef%bc%88coskewness%ef%bc%89%e5%92%8c%e5%8d%8f%e5%b3%b0%e5%ba%a6%ef%bc%88cokurtosis%ef%bc%89'
title: 用R计算协偏度（coskewness）和协峰度（cokurtosis）
wordpress_id: 702
categories:
- 金融投资分析(R)
tags:
- cokurtosis
- coskewness
- R&amp;数据艺术
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

