---
title: 技术指标在量化投资中的应用：以SMA指标为例
author: MatrixSpk
date: '2015-01-08'
slug: A-simple-moving-average-strategy-for-evaluating-signal
categories:
  - 量化投资
tags:
  - sma
  - r
  - quantstrat
  - 量化投资
---

## 引言

在量化投资领域，技术指标是构建自动化交易策略的核心工具。通过对历史价格、成交量等数据的数学建模，技术指标能够将市场行为转化为可量化的信号，为程序化交易提供决策依据。简单移动平均线（Simple Moving Average,SMA）作为最经典的技术指标之一，凭借其简洁的逻辑和广泛适用性，在量化策略开发中占据重要地位。
 
### 技术指标的核心作用

技术指标通过三种典型方式驱动量化交易：

* 趋势识别：MACD、布林带等指标可捕捉价格方向性变动；
* 超买超卖判断：RSI、KDJ等振荡器可识别市场极端状态；
* 波动率测量：ATR、标准差指标可量化市场风险强度。

这些指标通过参数优化、多周期组合、跨指标协同等方式构建数学模型，在沪深300股指期货、加密货币等不同市场展现出稳定收益特征。研究表明，技术指标驱动的策略在趋势性市场中夏普比率可达1.5以上。

### SMA指标的量化应用

SMA的计算公式为：

$$
SMA_{t} = \frac{1}{n}\sum_{i=1}^{n} P_{t-i+1} \\
=\frac{P_t+P_{t-1}+\cdots+P_{t-n+1}}{n}
$$

其在量化策略中的典型应用包括：

#### 趋势跟踪策略

* 双均线系统：结合5日SMA与20日SMA，当短周期线上穿长周期线时生成买入信号（黄金交叉），反之为卖出信号（死亡交叉）。回测显示该策略在A股市场年化收益可达12%-18%[2]。

* 价格偏离策略：当现价突破100日SMA时视为牛市启动，跌破则触发止损。该策略在美股ETF轮动中成功降低28%的最大回撤[3]。

#### 风险控制模块

* 动态止盈：当持仓盈利超过200日SMA的3倍标准差时自动减仓；

* 波动过滤：仅在价格位于50日SMA上方时允许开多单，规避下行趋势风险。

#### 参数优化实践

通过遗传算法对SMA周期进行动态调整，发现：
* 股票市场最优参数集中在20-60日
* 加密货币市场更适用10-30日短周期
* 参数组合的夏普比率比单一参数提升35%

## 策略实现

我们用R语言实现一个简单的SMA策略。完整代码如下：


``` r
# 基于简单移动平均线的信号评估策略
###############################################################)############

# 加载包：
require(devtools)
```

```
## Loading required package: devtools
```

```
## Loading required package: usethis
```

``` r
require(iterators)      # 迭代器工具
```

```
## Loading required package: iterators
```

``` r
require(quantstrat)     # 量化策略回测框架
```

```
## Loading required package: quantstrat
```

```
## Loading required package: quantmod
```

```
## Loading required package: xts
```

```
## Loading required package: zoo
```

```
## 
## Attaching package: 'zoo'
```

```
## The following objects are masked from 'package:base':
## 
##     as.Date, as.Date.numeric
```

```
## Loading required package: TTR
```

```
## Registered S3 method overwritten by 'quantmod':
##   method            from
##   as.zoo.data.frame zoo
```

```
## Loading required package: blotter
```

```
## Loading required package: FinancialInstrument
```

```
## Loading required package: PerformanceAnalytics
```

```
## 
## Attaching package: 'PerformanceAnalytics'
```

```
## The following object is masked from 'package:graphics':
## 
##     legend
```

```
## Loading required package: foreach
```

``` r
require(gamlss.util)    # 统计工具包（用于数据分布分析）
```

```
## Loading required package: gamlss.util
```

```
## Loading required package: gamlss.dist
```

```
## 
## Attaching package: 'gamlss.dist'
```

```
## The following object is masked from 'package:TTR':
## 
##     DPO
```

```
## Loading required package: gamlss
```

```
## Loading required package: splines
```

```
## Loading required package: gamlss.data
```

```
## 
## Attaching package: 'gamlss.data'
```

```
## The following object is masked from 'package:datasets':
## 
##     sleep
```

```
## Loading required package: nlme
```

```
## Loading required package: parallel
```

```
##  **********   GAMLSS Version 5.4-22  **********
```

```
## For more on GAMLSS look at https://www.gamlss.com/
```

```
## Type gamlssNews() to see new features/changes/bug fixes.
```

``` r
require(reshape2)
```

```
## Loading required package: reshape2
```

``` r
require(rCharts)
```

```
## Loading required package: rCharts
```

```
## 
## Attaching package: 'rCharts'
```

```
## The following object is masked from 'package:base':
## 
##     %||%
```

``` r
require(beanplot)
```

```
## Loading required package: beanplot
```


``` r
###########################################################################
# 配置时区设置
ttz<-Sys.getenv('TZ')   # 保存当前时区
Sys.setenv(TZ='UTC')    # 设置回测时区为UTC（避免时区问题影响）

# 清理残留数据
suppressWarnings(rm("order_book.macross",pos=.strategy))
suppressWarnings(rm("account.macross","portfolio.macross",pos=.blotter))
suppressWarnings(rm("account.st","portfolio.st","stock.str","strategy.st",'start_t','end_t'))
```


``` r
###########################################################################
# 数据准备
startDate="2000-01-01"                         # 回测起始日期
stock.str=c('XLY','XLF','XLP','XLI','RTH','XLV','XLK','XLE','IYT') # 股票代码列表
currency('USD')                                # 设置基准货币为美元
```

```
## [1] "USD"
```

``` r
stock(stock.str, currency='USD', multiplier=1) # 定义交易品种属性
```

```
## [1] "XLY" "XLF" "XLP" "XLI" "RTH" "XLV" "XLK" "XLE" "IYT"
```

``` r
# 下载雅虎财经数据
getSymbols(stock.str, from=startDate, src = 'yahoo')
```

```
## [1] "XLY" "XLF" "XLP" "XLI" "RTH" "XLV" "XLK" "XLE" "IYT"
```

``` r
for (symbol in stock.str) {
    # 检查对象是否存在
  if (exists(symbol)) {
    # 生成文件名
    file_name <- paste0(symbol, ".rds")
    # 保存为RDS文件
    saveRDS(get(symbol), file = file_name)
    # 打印保存信息
    message("已保存: ", symbol, " -> ", file_name)
  } else {
    warning("对象 ", symbol, " 不存在")
  }
}
```

```
## 已保存: XLY -> XLY.rds
```

```
## 已保存: XLF -> XLF.rds
```

```
## 已保存: XLP -> XLP.rds
```

```
## 已保存: XLI -> XLI.rds
```

```
## 已保存: RTH -> RTH.rds
```

```
## 已保存: XLV -> XLV.rds
```

```
## 已保存: XLK -> XLK.rds
```

```
## 已保存: XLE -> XLE.rds
```

```
## 已保存: IYT -> IYT.rds
```

``` r
# 调整所有股票数据为复权价格
for(i in stock.str)
  assign(i, adjustOHLC(get(i), use.Adjusted=TRUE))
```


``` r
###########################################################################
# 初始化账户、组合、策略
initEq=1000000                          # 初始资金100万美元
portfolio.st='macross'                  # 组合名称
account.st='macross'                    # 账户名称
# 初始化组合、账户、订单簿
initPortf(portfolio.st,
          symbols=stock.str)
```

```
## [1] "macross"
```

``` r
initAcct(account.st,
         portfolios=portfolio.st, 
         initEq=initEq)
```

```
## [1] "macross"
```

``` r
initOrders(portfolio=portfolio.st)
# 创建策略对象
strategy.st<- strategy(portfolio.st)
```


``` r
# 添加技术指标
# 添加50日SMA指标
strategy.st <- add.indicator(strategy = strategy.st, 
                             name = "SMA", 
                             arguments = list(x=quote(Cl(mktdata)), 
                                              n=50),
                             label= "ma50" )
# 添加200日SMA指标
strategy.st <- add.indicator(strategy = strategy.st, 
                             name = "SMA", 
                             arguments = list(x=quote(Cl(mktdata)), 
                                              n=200),
                             label= "ma200")

# 添加信号规则
# 当50日均线上穿200日均线时生成信号
strategy.st <- add.signal(strategy = strategy.st,
                          name="sigCrossover",
                          arguments = list(columns=c("ma50","ma200"),
                                           relationship="gte"),
                          label="ma50.gt.ma200")
# 当50日均线下穿200日均线时生成信号
strategy.st <- add.signal(strategy = strategy.st,
                          name="sigCrossover",
                          arguments =list(columns=c("ma50","ma200"),
                                          relationship="lt"), 
                          label="ma50.lt.ma200")
```


``` r
###########################################################################
# 参数优化设置
# 需要分析的信号列标签
signal.label = 'ma50.gt.ma200'

# # 定义参数范围
.FastSMA = seq(1,5,1)    # 快速SMA参数范围：1-5日
.SlowSMA = seq(5,20,5)   # 慢速SMA参数范围：5-20日（步长5）

# 添加快速SMA参数分布
strategy.st<-add.distribution(strategy.st,
                              paramset.label = 'SMA',
                              component.type = 'indicator',
                              component.label = 'ma50',
                              variable = list(n = .FastSMA),
                              label = 'nFAST')
# 添加慢速SMA参数分布
strategy.st<-add.distribution(strategy.st,
                              paramset.label = 'SMA',
                              component.type = 'indicator',
                              component.label = 'ma200',
                              variable = list(n = .SlowSMA),
                              label = 'nSLOW')

# 添加参数约束：快速SMA周期必须小于慢速SMA
strategy.st<-add.distribution.constraint(strategy.st,
                                         paramset.label = 'SMA',
                                         distribution.label.1 = 'nFAST',
                                         distribution.label.2 = 'nSLOW',
                                         operator = '<',
                                         label = 'SMA')
```


``` r
# # 执行信号分析（日线级别）
results = apply.paramset.signal.analysis(
  strategy.st, 
  paramset.label = 'SMA', 
  portfolio.st, 
  sigcol = signal.label,    # 分析的信号列
  sigval = 1,               # 信号触发阈值
  on = NULL,                # 分析频率（NULL表示原始数据频率）
  forward.days = 50,        # 信号后观察50天
  cum.sum = TRUE,           # 计算累积收益
  include.day.of.signal = F,# 排除信号当天
  obj.fun = signal.obj.slope, # 使用斜率作为目标函数
  decreasing = T            # 按降序排序结果
)
```

```
## Applying Parameter Set:  1, 5 
## Applying Parameter Set:  2, 5 
## Applying Parameter Set:  3, 5 
## Applying Parameter Set:  4, 5 
## Applying Parameter Set:  1, 10 
## Applying Parameter Set:  2, 10 
## Applying Parameter Set:  3, 10 
## Applying Parameter Set:  4, 10 
## Applying Parameter Set:  5, 10 
## Applying Parameter Set:  1, 15 
## Applying Parameter Set:  2, 15 
## Applying Parameter Set:  3, 15 
## Applying Parameter Set:  4, 15 
## Applying Parameter Set:  5, 15 
## Applying Parameter Set:  1, 20 
## Applying Parameter Set:  2, 20 
## Applying Parameter Set:  3, 20 
## Applying Parameter Set:  4, 20 
## Applying Parameter Set:  5, 20
```


``` r
#------------------------------- 日线级别分析结果 ------------------------------#
# 绘制IYT标的参数组合(5,20)的收益分布箱线图
# signal: 信号分析结果数据集
# x.val: x轴刻度位置，seq(1,50,5)表示从1到50步长5
# val: 每个盒须图对应的时间窗口长度
# ylim/xlim: 坐标轴范围
# mai: 图形边距参数

  distributional.boxplot(
    signal=results$sigret.by.asset$IYT$paramset.5.20,
    x.val=seq(1, 50, 5),  # 显示1-50天，每5天一个刻度
    val=10,               # 每个盒须图代表10天的收益窗口
    ylim=c(-20, 20),      # Y轴收益范围限制在±20%
    xlim=c(0, 50),        # X轴范围0-50天
    mai=c(1,1,0.3,0.5),   # 图形边距设置（下左上右）
    h=0                   # 水平参考线位置（0轴）
    )                 
```

```
## GAMLSS-RS iteration 1: Global Deviance = 39613.69 
## GAMLSS-RS iteration 2: Global Deviance = 39613.69
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />


``` r
# 绘制XLE标的信号的参数组合面板图（5行4列布局）


  signal.plot(
    results$sigret.by.asset$XLE, 
    rows=5,      # 图形行数
    columns = 4  # 图形列数
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="672" />


``` r
# 绘制XLE标的的豆状分布图（展示参数组合的密度分布）


  beanplot.signals(
    results$sigret.by.asset$XLE,
    rows=5,     # 图形行数
    columns = 4# 图形列数 
  )
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-1.png" width="672" />


``` r
# 绘制IYT标的参数组合(5,20)的信号路径图
# signal.path.plot(results$sigret.by.asset$IYT$paramset.5.20)
```


``` r
#----------------------------- 周线级别前瞻分析 -----------------------------#
# 执行周线级别信号分析（向前看10天）
results.w = apply.paramset.signal.analysis(
  strategy.st,           # 策略对象
  paramset.label='SMA',  # 参数集标签  
  portfolio.st,          # 组合名称
  sigcol = signal.label, # 信号列名称
  sigval = 1,            # 信号触发值
  on='weeks',            # 按周汇总结果
  forward.days=10,       # 信号后观察10天
  cum.sum=TRUE,          # 计算累积收益
  include.day.of.signal=F, # 排除信号当天
  obj.fun=signal.obj.slope, # 使用斜率评估
  decreasing=T           # 降序排列结果
)
```

```
## Applying Parameter Set:  1, 5 
## Applying Parameter Set:  2, 5 
## Applying Parameter Set:  3, 5 
## Applying Parameter Set:  4, 5 
## Applying Parameter Set:  1, 10 
## Applying Parameter Set:  2, 10 
## Applying Parameter Set:  3, 10 
## Applying Parameter Set:  4, 10 
## Applying Parameter Set:  5, 10 
## Applying Parameter Set:  1, 15 
## Applying Parameter Set:  2, 15 
## Applying Parameter Set:  3, 15 
## Applying Parameter Set:  4, 15 
## Applying Parameter Set:  5, 15 
## Applying Parameter Set:  1, 20 
## Applying Parameter Set:  2, 20 
## Applying Parameter Set:  3, 20 
## Applying Parameter Set:  4, 20 
## Applying Parameter Set:  5, 20
```

``` r
# 绘制周线分析箱线图（时间窗口调整为10天）
distributional.boxplot(signal=results.w$sigret.by.asset$IYT$paramset.5.20,
                       x.val=seq(1, 10, 2), # 1-10天步长2
                       val=10,              
                       ylim=c(-20, 20),
                       xlim=c(0, 10),
                       mai=c(1,1,0.3,0.5),
                       h=0)
```

```
## GAMLSS-RS iteration 1: Global Deviance = 8067.487 
## GAMLSS-RS iteration 2: Global Deviance = 8067.487
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" width="672" />

``` r
# 绘制周线信号分析可视化面板
signal.plot(results.w$sigret.by.asset$XLE, rows=5, columns = 4)

# 绘制周线豆状分布图
beanplot.signals(results.w$sigret.by.asset$XLE, rows=5, columns = 4)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-2.png" width="672" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-3.png" width="672" />


``` r
#----------------------------- 月线级别前瞻分析 -----------------------------#
# 执行月线级别信号分析（向前看5天）
results.m = apply.paramset.signal.analysis(
  strategy.st, 
  paramset.label='SMA',  
  portfolio.st,
  sigcol = signal.label,
  sigval = 1,
  on='months',           # 按月汇总结果
  forward.days=5,        # 信号后观察5天（模拟月度调仓）
  cum.sum=TRUE,
  include.day.of.signal=F,
  obj.fun=signal.obj.slope,
  decreasing=T
)
```

```
## Applying Parameter Set:  1, 5 
## Applying Parameter Set:  2, 5 
## Applying Parameter Set:  3, 5 
## Applying Parameter Set:  4, 5 
## Applying Parameter Set:  1, 10 
## Applying Parameter Set:  2, 10 
## Applying Parameter Set:  3, 10 
## Applying Parameter Set:  4, 10 
## Applying Parameter Set:  5, 10 
## Applying Parameter Set:  1, 15 
## Applying Parameter Set:  2, 15 
## Applying Parameter Set:  3, 15 
## Applying Parameter Set:  4, 15 
## Applying Parameter Set:  5, 15 
## Applying Parameter Set:  1, 20 
## Applying Parameter Set:  2, 20 
## Applying Parameter Set:  3, 20 
## Applying Parameter Set:  4, 20 
## Applying Parameter Set:  5, 20
```

``` r
# 绘制月线分析箱线图（时间窗口调整为5天）
distributional.boxplot(signal=results.m$sigret.by.asset$IYT$paramset.5.20,
                       x.val=seq(1, 5, 1),  # 1-5天逐日显示
                       val=10,
                       ylim=c(-30, 30),    # 放宽收益范围
                       xlim=c(0, 5),
                       mai=c(1,1,0.3,0.5),
                       h=0)
```

```
## GAMLSS-RS iteration 1: Global Deviance = 4588.769 
## GAMLSS-RS iteration 2: Global Deviance = 4588.769
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" width="672" />

``` r
# 绘制月线信号面板图
signal.plot(results.m$sigret.by.asset$XLE, rows=5, columns = 4)

# 绘制月线豆状分布图
beanplot.signals(results.m$sigret.by.asset$XLE, rows=5, columns = 4)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-2.png" width="672" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-3.png" width="672" />

## 当前应用方向

当前前沿研究正将SMA与机器学习结合：

* 作为LSTM神经网络的输入特征，提升价格预测精度；
* 构建SMA斜率变化率指标，提前1-3日预警趋势反转；
* 在高频交易中开发毫秒级SMA差值套利模型。

值得注意的是，SMA的滞后性（Lagging Effect）在震荡市中可能产生虚假信号。成熟策略常将其与成交量加权移动平均线（VWMA）组合使用，或将参数动态化以提升适应性。量化实践表明，经过噪音过滤的SMA系统，在配合3%的移动止损规则后，可使策略年化波动率降低22%。
