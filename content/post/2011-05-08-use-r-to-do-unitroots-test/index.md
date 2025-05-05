---
title: R与单位根检验
author: MatrixSpk
date: '2011-05-08'
slug: use-r-to-do-unitroots-test
categories:
- 计量经济学
tags:
- Augmented Dickey-Fuller test
- unit root test
- 单位根检验
---
R里面的fUnitRoots包可以轻松实现时间序列的单位根检验。两个主函数分别是adfTest和unitrootTest。对于以应用统计为主要目的的人而言，看懂单位根检验的结果可能比探讨单位根检验的原理更重要。

为了清晰地表明有单位根的序列的检验结果和无单位根的序列的检验结果之间的差别，在这里生成两个可对比的单位根序列来举例：

首先，载入fUnitRoots包：


``` r
library(fUnitRoots);

# 生成没有单位根的序列x和由单位根的序列y

x <-  rnorm(1000) 
y <- cumsum(c(0, x)) 
```

# 对序列x进行adf检验：


``` r
adfTest(x)
```

```
## Warning in adfTest(x): p-value smaller than printed p-value
```

```
## 
## Title:
##  Augmented Dickey-Fuller Test
## 
## Test Results:
##   PARAMETER:
##     Lag Order: 1
##   STATISTIC:
##     Dickey-Fuller: -21.1357
##   P VALUE:
##     0.01 
## 
## Description:
##  Mon May  5 17:44:36 2025 by user:
```

注意上述结果中的P值。

对序列y进行adf检验：


``` r
adfTest(y) 
```

```
## 
## Title:
##  Augmented Dickey-Fuller Test
## 
## Test Results:
##   PARAMETER:
##     Lag Order: 1
##   STATISTIC:
##     Dickey-Fuller: 0.8508
##   P VALUE:
##     0.8875 
## 
## Description:
##  Mon May  5 17:44:36 2025 by user:
```

注意上述结果的p值，跟x序列的结果有什么区别？

对序列x和序列y进行单位根检验，观察下两者的区别。


``` r
unitrootTest(x)
```

```
## 
## Title:
##  Augmented Dickey-Fuller Test
## 
## Test Results:
##   PARAMETER:
##     Lag Order: 1
##   STATISTIC:
##     DF: -21.1357
##   P VALUE:
##     t: < 2.2e-16 
##     n: 0.001252 
## 
## Description:
##  Mon May  5 17:44:36 2025 by user:
```

``` r
unitrootTest(y)
```

```
## 
## Title:
##  Augmented Dickey-Fuller Test
## 
## Test Results:
##   PARAMETER:
##     Lag Order: 1
##   STATISTIC:
##     DF: 0.8508
##   P VALUE:
##     t: 0.8938 
##     n: 0.8854 
## 
## Description:
##  Mon May  5 17:44:36 2025 by user:
```
