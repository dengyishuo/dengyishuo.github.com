---
title: 修改chartSeries绘图结果的x轴标签
author: MatrixSpk
date: '2013-06-26'
slug: change-xlabels-in-chartSeries
categories:
- R
tags:
- quantmod
- R
---

用quantmod包中的chartSeries绘图时，x轴标签会默认为中文汉字，看起来不太美观。想要修改制图结果吧，chartSeries函数中没有提供可设置x.labels的参数。原来chartSeries函数会自动识别系统语言并根据系统语言生成x.labels。这样的话，只要我们把自己的系统语言更改为英语，就应该显示为更为整洁的英文了。


``` r
require(quantmod)
getSymbols("AAPL")
chartSeries(AAPL,theme="white")
```



``` r
Sys.setlocale("LC_TIME","english")
chartSeries(AAPL,theme="white")
```

不过，这个好像不怎么重要吧？
