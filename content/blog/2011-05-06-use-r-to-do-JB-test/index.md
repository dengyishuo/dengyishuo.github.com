---
title: "用R进行Jarque-Bera检验"
author: "MatrixSpk"
date: "2011-05-06"
slug: use-r-to-do-jb-test
tags:
- jarque bera检验
- jb检验
- 正态性检验
categories: 计量经济学
---
线性回归模型的检验是建立在假设随机误差 `\(u_t\)` 服从正态分布的基础之上的。但问题是我们没有办法直接观察到真实的 `\(u_t\)` ，那么，如何验证它是否服从正态分布呢？一般来说，会用残差 `\(e_t\)` 近似表示 `\(u_t\)` ，再通过 `\(e_t\)` 的正态性来推断 `\(u_t\)` 的正态性。

一种比较常用的正态性检验方法叫Jarque-Bera(雅克-贝拉)检验，简称JB检验。其思路大概是这样的：

首先，计算偏度系数 `\(s_{k}\)` 和 峰度系数 `\(k\)` ：

$$
s_{k}=\frac{\frac{1}{n}\sum\_{i=1}^{n}(x\_{i}-\bar x)^{3}}{(\frac{1}{n}\sum\_{i=1}^{n}(x_{i}-\bar x)^{2})^{\frac{3}{2}} }
$$

$$
\text{k}=\frac{\frac{1}{n}\sum\_{i=1}^{n}(x\_{i}-\bar x)^{4}}{(\frac{1}{n}\sum\_{i=1}^{n}(x_{i}-\bar x)^{2})^{2} }-3
$$

Jarqe和Bera建立了如下检验统计量：

$$
\text{JB}=\frac{n}{6}(sk^{2}+\frac{k^{2}}{4})
$$

在正态性分布的假定下，JB统计量渐近服从自由度为2的 `\(\chi^2\)` 分布。

显然，如果变量服从正态分布，则S为0，K为0，因而JB统计量的值为零。如果变量不是服从正态分布的变量，则JB统计量将为一个逐渐增大值。而针对每一个JB统计量，都可以算出其对应的P值，根据P值和事先确定的置信水平便可以确定是否拒绝变量为正态分布的假设。

在R软件中，Jarque-Bera检验可以用tseries包中的jarque.bera.test来实现。我们这里虚构两个数据，第一个例子中的数据服从正态分布，第二例子中的数据是1到200的序列。


``` r
library(tseries)
```

```
## Registered S3 method overwritten by 'quantmod':
##   method            from
##   as.zoo.data.frame zoo
```

``` r
set.seed(123)
x=rnorm(20)
jb <- jarque.bera.test(x)
jb
```

```
## 
## 	Jarque Bera Test
## 
## data:  x
## X-squared = 0.081917, df = 2, p-value = 0.9599
```

返回结果中p-value等于0.9598692，大于0.05，因此在95%置信水平下，无法拒绝x服从正态分布的假设。

另外一个例子：


``` r
library(tseries)
x <- 1:200 #不服从正态分布
jb <- jarque.bera.test(x)
jb
```

```
## 
## 	Jarque Bera Test
## 
## data:  x
## X-squared = 12.001, df = 2, p-value = 0.002477
```

返回结果中p-value等于0.0024773，远小于0.05，因此在95%置信水平下，拒绝x服从正态分布的假设（这是显而易见的）。
