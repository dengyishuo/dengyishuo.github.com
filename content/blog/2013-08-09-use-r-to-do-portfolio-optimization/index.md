---
title: 使用R语言构造投资组合的有效前沿
author: MatrixSpk
date: '2013-08-09'
slug: use-r-to-do-portfolio-optimization
categories:
- 量化投资
tags:
- portfolio
- frontier
---
构造投资组合是金融投资分析中历久弥新的问题。多年以来，学界、业界提出诸多对投资组合进行优化的方法。比如，最经典的基于收益率均值和收益率波动性进行组合优化，由于马克维滋提出用收益率方差表示收益率的波动性，所以，这种方法又称为的 M-V 方法，即 `Mean-Variance` 方法的缩写；后来，又衍生出基于夏普比率（`Sharp Ratio`）的投资组合优化方法；近年来，随着`VaR` (`Value at Risk`) 和 `CVaR` (`Conditional Vaule at Risk`) 概念的兴起，基于 `VaR` 和 `CVaR` 对投资组合进行优化的思路也开始勃兴；除此之外，对冲基金届还有一种非常有生命力的投资组合优化方法，即桥水公司（`Bridge-Water`）公司提出的风险均摊方法（ `Risk Pairy` ），这种方法的核心思路在于，估计组合中各个资产的风险度及其占组合风险的比率，然后，按照该比例对组合头寸进行分配。

几种方法中，在学界和业界最收关注的还是 `M-V` 方法。而在 `M-V` 方法中最基本的一个知识点，就是构造投资组合的有效前沿。

理论这里不再赘述，简单说一下其在 `R` 语言中的实现。构造有效前沿的步骤大致可按照获取数据、将数据加工处理为收益率矩阵、以收益率矩阵为输入计算得到有效前沿这三个步骤来完成。下面分布来说一说。

第一步，获取数据。最简单的方法是使用 `quantmod` 中的 `getSymbols` 函数。因为要要做的事是构建资产组合，因此，得同时获取多只股票的交易数据，这里取 QQQ/SPY/YHOO 三只股票为例。需要运行的代码：


``` r
# 载入 quatnmod 包
require(quantmod) 
```

```
## 载入需要的程序包：quantmod
```

```
## 载入需要的程序包：xts
```

```
## 载入需要的程序包：zoo
```

```
## 
## 载入程序包：'zoo'
```

```
## The following objects are masked from 'package:base':
## 
##     as.Date, as.Date.numeric
```

```
## 载入需要的程序包：TTR
```

```
## Registered S3 method overwritten by 'quantmod':
##   method            from
##   as.zoo.data.frame zoo
```

``` r
# 下载 QQQ/SPY/TSLA 交易数据
getSymbols(c('QQQ','SPY','TSLA')) 
```

```
## [1] "QQQ"  "SPY"  "TSLA"
```

第二步，将交易数据处理为收益率数据。这一步可以用 dailyReturn 函数来完成。


``` r
# 计算收益率序列
QQQ<- readRDS("QQQ.rds")
SPY<- readRDS("SPY.rds")
TSLA<- readRDS("TSLA.rds")

QQQ_ret <- na.omit(ROC(Cl(QQQ),type = "discrete",na.pad = TRUE))
SPY_ret <- na.omit(ROC(Cl(SPY),type = "discrete",na.pad = TRUE))
TSLA_ret <- na.omit(ROC(Cl(TSLA),type = "discrete",na.pad = TRUE))
```

第三步，合并收益率序列。


``` r
dat <- na.omit(merge(QQQ_ret,SPY_ret,TSLA_ret))
```

第四步，计算投资组合的有效前沿。这一步使用 portfolioFrontier 函数来完成。由于 portfolioFrontier 函数的输入必须是 timeSeries 类，因而，得将数据类型进行转化。


``` r
## 转化为 timeSeries 类
require(timeSeries)
```

```
## 载入需要的程序包：timeSeries
```

```
## 载入需要的程序包：timeDate
```

```
## 
## 载入程序包：'timeSeries'
```

```
## The following object is masked from 'package:zoo':
## 
##     time<-
```

```
## The following objects are masked from 'package:graphics':
## 
##     lines, points
```

``` r
dat <- as.timeSeries(dat)  
## 载入 fPortfolio
require(fPortfolio)
```

```
## 载入需要的程序包：fPortfolio
```

```
## 载入需要的程序包：fBasics
```

```
## 
## 载入程序包：'fBasics'
```

```
## The following object is masked from 'package:TTR':
## 
##     volatility
```

```
## 载入需要的程序包：fAssets
```

``` r
## 求frontier 
Frontier <- portfolioFrontier(dat)
Frontier
```

```
## 
## Title:
##  MV Portfolio Frontier 
##  Estimator:         covEstimator 
##  Solver:            solveRquadprog 
##  Optimize:          minRisk 
##  Constraints:       LongOnly 
##  Portfolio Points:  5 of 50 
## 
## Portfolio Weights:
##    QQQ.Close SPY.Close TSLA.Close
## 1     0.0000    1.0000     0.0000
## 13    0.6345    0.2116     0.1538
## 25    0.5957    0.0000     0.4043
## 37    0.3098    0.0000     0.6902
## 50    0.0000    0.0000     1.0000
## 
## Covariance Risk Budgets:
##    QQQ.Close SPY.Close TSLA.Close
## 1     0.0000    1.0000     0.0000
## 13    0.5509    0.1442     0.3049
## 25    0.3021    0.0000     0.6979
## 37    0.0911    0.0000     0.9089
## 50    0.0000    0.0000     1.0000
## 
## Target Returns and Risks:
##      mean    Cov   CVaR    VaR
## 1  0.0005 0.0109 0.0265 0.0165
## 13 0.0009 0.0142 0.0331 0.0227
## 25 0.0013 0.0200 0.0448 0.0303
## 37 0.0016 0.0276 0.0604 0.0407
## 50 0.0021 0.0366 0.0792 0.0522
## 
## Description:
##  Mon May  5 16:26:15 2025 by user:
```

上面结果中 title 部分表明的是本次操作过程中使用的相关方法。Portfolio Weights 部分返回的是三只股票在投资组合中的头寸比例，每一行的和都是 1 。对于第二行，它表示的是在投资组合中将总头寸以 24.09% 、 75.41% 、 0.50% 的比例分散到三只股票标的上。Covariance Risk Budgets 表示的是协方差风险预算矩阵。Target Return and Risks 表示目标组合的预期收益率和风险数据。

调用 plot 函数可以对上述结果进行绘图，调用 plot 之后，R 控制台会返回一组绘图选项卡：

```
plot(Frontier)

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

各选项卡对应的绘图类型依次是：有效前沿、最小风险组合、切线组合、单个资产的风险/收益、等权重投资组合、两资产投资组合的有效前沿（禁止卖空）、模特卡罗模拟得到的投资组合、夏普比率。依次选择就可以看到相应的绘图结果。
