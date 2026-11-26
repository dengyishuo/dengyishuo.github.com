---
title: 获取上市公司主要财务指标
author: 揖光尘
date: '2012-09-07'
slug: get-financial-data-from-web
categories:
- 数据获取
tags:
  - R
  - 数据获取
---
  
写了一段获取上市公司主要财务指标的代码：


``` r
# 加载XML包
library(XML)
####id:股票代码
####year:年度
get.finance <- function(id,year,...){
  web <- paste("http://money.finance.sina.com.cn/corp/go.php/vFD_FinancialGuideLine/stockid/",id,"/ctrl/",year,"/displaytype/4.phtml",sep="")
  tables <- readHTMLTable(web)$BalanceSheetNewTable0
  colnames(tables)<-tables[1,]
  tables <- tables[-1,]
  return(tables)
}
```

简单演示一下：


``` r
library(XML)
res <- get.finance("000002","2012")
```

基于这些财务数据和价格数据，就可以着手建立股票排名系统了。
