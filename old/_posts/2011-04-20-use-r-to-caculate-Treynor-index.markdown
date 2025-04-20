---
layout: post
title: 用R计算Treynor系数
comments: true
categories:
- investment
tags:
- Treynor指数
- 基金
---

Treynor指数是Treynor提出的用以衡量基金绩效的指数。特雷诺认为,优秀的基金管理者应能够通过投资组合消除所有的非系统性风险,因此，可以用单位系统性风险系数所获得的超额收益率来衡量投资基金的业绩。他采用基金收益率和无风险收益率的差来衡量基金的超额收益率；采用基金投资收益率的[latex]\beta[/latex]系数作为衡量系统风险的指标。很显然，Treynor指数越大，表示单位系统风险系数对应的超额收益越大，也就代表基金的效益越好。在运作基金或者投资组合时这个指数十分有用。
Treynor指数的计算公式如下:
[latex]T=\frac{r_i-r_f}{\beta_i}[/latex]
其中：
[latex]T[/latex]：Treynor指数 
[latex]r_f[/latex] ：无风险收益率
[latex]r_i[/latex]：基金的收益率 
[latex]\beta_i[/latex] ：基金的[latex]beta[/latex]系数
计算Treynor指数的R代码如下：
[code]
library(PerformanceAnalytics)
TreynorRatio()
[/code]

