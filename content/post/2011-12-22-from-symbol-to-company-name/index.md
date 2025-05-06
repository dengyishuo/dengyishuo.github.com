---
title: 从股票代码到公司名
author: MatrixSpk
date: '2011-12-12'
slug: from-symbol-to-company-name
categories:
- R
tags:
- quantmod
- yahoo
- yahooQF
- 代码
- 公司简称
- 股票
---
Ruser也有Ruser的恶习，经常弄的什么事情都想用R来完成：用R玩儿扫雷、用R玩汉诺塔、用R玩儿黑白棋、用R获取股票数据、用R获取财务数据。

现在想的是，如果已经知道一个股票代码，比如上交所的000061，如何知道其对应的公司名称呢？如果能找到一个数据库，其包含公司名称、公司股票代码、公司简称就可以完成这样的事情了。

最典型的金融数据库有什么呢？google?yahoo? yahoo是可以的。代码：


``` r
library(quantmod)
paste(getQuote("000061.ss", what=yahooQF("Name"))[,2])
```

返回结果如下：

```
[1] "SSE CORPORATE BON"
```
