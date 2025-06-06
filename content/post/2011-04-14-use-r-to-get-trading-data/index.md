---
title: R获取股票数据
author: MatrixSpk
date: '2011-04-14'
slug: use-r-to-get-trading-data
categories:
- R
tags:
- quantmod
- yahoo
- 数据
- 股票
- 获取数据
---
R中有多个包都提供了从线上数据库获取股票数据的方法。如果非得在其中找出一个最好的，quantmod当之无愧。譬如下载沪市大盘数据，代码可以是：


``` r
library(quantmod)   
SSE <- getSymbols("000001.SS",auto.assign=FALSE)   
head(SSE) 
```

或者：


``` r
library(quantmod)  
setSymbolLookup(SSE=list(name="000001.SS", src="yahoo"))  
getSymbols("SSE")  
head(SSE)  
```

以上是Jeff Ryan（quantmod作者）推荐过的方法。不过，后来JoshuaUlrich在他的邮件中给出了一个更简洁的方法：


``` r
library(quantmod)  
getSymbols("^SSEC")  
head(SSEC)  
```

虽然quantmod的包出自Jeff Ryan之手，显而易见，在这一点上Joshua Ulrich是青出于蓝而胜于蓝。
