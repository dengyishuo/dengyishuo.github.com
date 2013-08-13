---
comments: true
layout: post
title: R与单位根检验
categories:
- econometrics
tags:
- Augmented Dickey-Fuller test
- unit root test
- 单位根检验
---

R里面的fUnitRoots包可以轻松实现时间序列的单位根检验，两个主函数分别是adfTest和unitrootTest。对于以应用统计为主要目的的人而言，看懂单位根检验的结果可能比探讨单位根检验的原理更重要。为了清晰地表明有单位根的序列的检验结果和无单位根的序列的检验结果之间的差别，在这里生成两个可对比的单位根序列来举例：
首先，载入fUnitRoots包：
[code]
>library(fUnitRoots);
[/code]
生成没有单位根的序列x和由单位根的序列y:
[code]
>x = rnorm(1000) ;
>y = cumsum(c(0, x)) ;
[/code]
对序列x进行adf检验：
[code]
>adfTest(x)
###结果
Title:
Augmented Dickey-Fuller Test

Test Results:
PARAMETER:
Lag Order: 1
STATISTIC:
Dickey-Fuller: -22.6172
P VALUE:
0.01 

Description:
Sun May 08 20:02:14 2011 by user: deng

Warning message:
In adfTest(x) : p-value smaller than printed p-value
[/code]
注意上述结果中的P值。
对序列y进行adf检验：
[code]
adfTest(y) 
###结果
Title:
Augmented Dickey-Fuller Test
Test Results:
PARAMETER:
Lag Order: 1
STATISTIC:
Dickey-Fuller: -0.3826
P VALUE:
0.4944 

Description:
Sun May 08 20:02:14 2011 by user: deng
[/code]
注意上述结果的p值，跟x序列的结果有什么区别？
对序列x进行单位根检验：
[code]
>unitrootTest(x)
###结果
Title:
 Augmented Dickey-Fuller Test

Test Results:
PARAMETER:
Lag Order: 1
STATISTIC:
DF: -22.2201
P VALUE:
t: < 2.2e-16 
n: 0.0009314 

Description:
Tue May 31 19:36:38 2011 by user: deng
[/code]
对序列y的单位根检验：
[code]
> unitrootTest(y)
###结果
Title:
Augmented Dickey-Fuller Test

Test Results:
PARAMETER:
Lag Order: 1
STATISTIC:
DF: -1.1701
P VALUE:
t: 0.2213 
n: 0.4443 

Description:
Tue May 31 19:37:37 2011 by user: deng
[/code]

