---
layout: post
title: quantmod:R中的金融分析包
comments: true
categories:
- R
tags:
- quantmod
- R
---

## 1.获取数据

### 1.1 获取股票数据

#### 1.1.1 从网络获取股票数据

[quantmod](http://www.quantmod.com )包中的`getSymbols()`函数可以从网络上获取股票日交易数据。我们用`args()`函数看一下它的基本用法：


```r
install.packages("quantmod")
```

```
## Installing package into 'C:/Users/dengyishuo/Documents/R/win-library/3.0'
## (as 'lib' is unspecified)
```

```
## Error: trying to use CRAN without setting a mirror
```

```r
require(quantmod)
```

```
## Loading required package: quantmod
```

```
## Warning: there is no package called 'quantmod'
```

```r
args(getSymbols)
```

```
## Error: object 'getSymbols' not found
```


`getSymbols()`函数各参数的意义如下：

参数|用途
----|-------
Symbols|指定股票符号或者代码。
env|指定数据的存储位置。
reload.Symbols|是否重新载入数据到指定环境，缺省设置为FALSE。
warnings|是否打开警告提醒，缺省设置为TRUE。
src|获取股票数据的网址，缺省设置为yahoo，也可以选择google。
symbol.lookup|重设股票代码名称等。
auto.assign|结果是否自动载入工作环境。
file.path|文件路径。
...|其它参数。 

##### 1.1.1.1获取上证指数

上证指数的符号是^SSEC,获取上证指数的代码如下：

```
getSymbols("^SSEC")
```

也可以通过上证指数的代码来获取该数据。可以查到上证指数的代码为`000001.ss`，其中`.ss`代表该指数从属于上交所。代码如下：

```
getSymbols("000001.ss")
```

##### 1.1.1.2 获取上证A股指数

上证A股指数的代码为000002.ss。
值得指出的是，由于上证A股指数没有自己的符号，因此为了使用数据的方便，需要动用setSymbolLookup函数。

setSymbolLookup(A.Share.index=list(name="000002.ss",src="yahoo"))
getSymbols("A.Share.index")


##### 1.1.1.3 获取上证B股指数
上证B股指数的代码为000003.ss。

setSymbolLookup(B.Share.index=list(name="000003.ss",src="yahoo"))
getSymbols("B.Share.index")


##### 1.1.1.4 获取上证综合指数
上证综合指数的代码为000008.ss。

setSymbolLookup(Conglomerate.index=list(name="000008.ss",src="yahoo"))
getSymbols("Conglomerate.index")

获取沪深300指数}
沪深300指数的代码为000300.ss。

setSymbolLookup(CSI300=list(name="000300.ss",src="yahoo"))
getSymbols("CSI300")
CSI300

深圳成指}
深证成指的代码为399001.sz，其中.sz代表该指数从属于深交所。

setSymbolLookup(component.index=list(name="399001.sz",src="yahoo"))
getSymbols("component.index")
component.index

获取中国移动公司数据}
中国移动公司的符号是CHL。

getSymbols("CHL")


获取三一重工数据}
三一重工的股票代码为600030.ss。

setSymbolLookup(SANY.HEAVY=list(name="600030.ss",src="yahoo"))
getSymbols("SANY.HEAVY")
SANY.HEAVY


从数据库获取股票数据}
除了能从网站上直接获取股票数据外，quantmod包还提供了一系列从现有文件或者数据库读取OHLC股票数据的函数，列出如下：
\textcolor{blue}{getSymbols.csv()}：从csv文件读取OHLC数据
用args()函数查看\textcolor{blue}{getSymbols.csv()}的用法：



getSymbols.MySQL()：从MySQL数据库读取数据
getSymbols.SQLite()：从SQLite数据库读取数据
getSymbols.rda()：读取以.r格式存储的数据

获取和查看上市公司的财务报表}
获取财务报表的函数是：getFinancials}或者getFin}函数。

getFinancials('CHL')

结果：

[1] "CHL.f"

用view.Fin()函数查看财务报表数据

view.Fin(CHL.f)


获取上市公司股息数据
getDividends()函数可以获取上市公司的股息数据。

getDividends("CHL")


根据股息调整股票价格
adjustOHLC()函数可以对股票数据进行除息调整。

getSymbols("CHL", from="1990-01-01", src="yahoo")
head(CHL)
head(CHLL.a <- adjustOHLC(CHL))
head(CHL.uA <- adjustOHLC(CHL, use.Adjusted=TRUE))


获取股票分割数据
getSplits()函数可以获取上市公司的股票分割数据。

getSplits("MSFT")

从网络获取期权交易数据

AAPL.OPT <- getOptionChain("AAPL")
AAPL.OPTS <- getOptionChain("AAPL", NULL)



getSymbols("AAPL")
options.expiry(AAPL)
futures.expiry(AAPL)
AAPL[options.expiry(AAPL)]


从网络获取汇市数据
getFX()函数可以获取汇率数据。

getFX("USD/JPY")
getFX("EUR/USD",from="2005-01-01")

也可以：

getSymbols("USD/EUR",src="oanda")
getSymbols("USD/EUR",src="oanda",from="2005-01-01")

获取重金属交易数据
getMetals()函数可以获取重金属的交易数据。

getFX(c("gold","XPD"))
getFX("plat",from="2005-01-01")

获取美联储经济数据

getSymbols.FRED()函数可以获取美联储主页上的美国经济数据。

getSymbols('CPIAUCNS',src='FRED')


或者：

setSymbolLookup(CPIAUCNS='FRED')
getSymbols('CPIAUCNS')

其它函数
查看内存中的股票数据

getSymbols("CHL","000023.ss")
showSymbols(env=.GlobalEnv)

结果如下：
\textcolor{blue}{
3.SS       CHL
"yahoo"   "yahoo" 
}
从内存中移除股票数据


RemoveSymbols("CHL")
showSymbols(env=.GlobalEnv)



getQuote("AAPL")
getQuote("QQQQ;SPY;^VXN",what=yahooQF(c("Bid","Ask")))
standardQuote()
yahooQF()

attachSymbols()

## 2 基本数据操作

### 2.1 逻辑判断函数
is族函数
is.OHLC(x):检查是否是OHLC类型数据
is.OHLCV(x)：检查是否是OHLCV类型数据
is.BBO(x)：检查是否是BBO类型数据
is.TBBO(x)：检查是否是TBBO类型数据
is.HLC(x):检查是否是HLC类型数据

is.quantmod(x):   
is.quantmodResults(x):  
has族函数
has.OHLC(x, which = FALSE) 
has.HLC(x, which = FALSE)
has.OHLCV(x, which = FALSE)
has.Op(x, which = FALSE)
has.Hi(x, which = FALSE)
has.Lo(x, which = FALSE)
has.Cl(x, which = FALSE)
has.Vo(x, which = FALSE)
has.Ad(x, which = FALSE)

has.Ask(x, which = FALSE)
has.Bid(x, which = FALSE)
has.Price(x, which = FALSE)
has.Qty(x, which = FALSE)
has.Trade(x, which = FALSE)

### 2.2 提取数据的函数
列名函数
Op(x):提取开盘价
Hi(x):提取最高价
Lo(x):提取最低价
Cl(x):提取收盘价
Vo(x):提取交易量
Ad(x):提取调整价格
HLC(x):提取最高价、最低价和收盘价
OHLC(x):提取开盘价、最高价、最低价和收盘价
series族函数}
seriesHi(x)：提取开盘价
seriesLo(x):提取最低价

### 2.3 简单的计算函数
列操作函数
计算变化率
Delt(x1, x2 = NULL, k = 0, type = c("arithmetic", "log")) 

Stock.Open <- c(102.25,102.87,102.25,100.87,103.44,103.87,103.00)
Stock.Close <- c(102.12,102.62,100.12,103.00,103.87,103.12,105.12)

按开盘价计算收益率

Delt(Stock.Open)

或者

Delt(Stock.Open,k=1)

或者

diff(Stock.Open)/Stock.Open[1:6]

按开盘价计算几何收益率

Delt(Stock.Open,type='log')

计算开盘价与收盘价的差

Delt(Stock.Open,Stock.Close)

等同于

(Stock.Open-Stock.Close)/Stock.Open

计算开盘价与下一期收盘价的差

Delt(Stock.Open,Stock.Close,K=1)

等同于

(Stock.Open[1:6]-Stock.Close[2:7])/Stock.Open[1:6]


OpCl(x):等同于Delt(Op(x), Cl(x))
ClCl(x):等同于Delt(Cl(x))
HiCl(x):等同于Delt(Hi(x),Cl(x))
LoCl(x):等同于Delt(Lo(x),Cl(x))
LoHi(x):等同于Delt(Lo(x),Hi(x))
OpHi(x):等同于Delt(Op(x),Hi(x))
OpLo(x):等同于Delt(OP(x),Lo(x))
OpOp(x):等同于Delt(Op(x))

### 2.4 其它函数
Lag(x,k):求滞后k期
Next(x, k = 1)：求k期后
first(x,k)：求前k个
last(x,k):求后k个

findPeaks(x, thresh=0)：找峰值
findValleys(x, thresh=0)：找谷底值

seriesIncr(x, thresh=0, diff.=1L)：差分后大于限值的点
seriesDecr(x, thresh=0, diff.=1L)：差分后小于限值的点
endpoints()：寻找节点

to.weekly()：将OHLC数据转化为周数据
to.monthly():将PHLC数据转化为月数据
periodicity()：返回数据的日期范围

例子

Lag(Op(CHL))
Lag(Op(CHL),c(1,3,5))
Next(Cl(CHL))
Delt(Op(CHL),Cl(CHL),k=1:3)

CHL['2007']
CHL['2009']
CHL['2009-01']
CHL['2009-01::2009-08']
CHL['2009-01::']

first(CHL)
first(CHL,5)
first(CHL,'3 weeks')
last(CHL,'-3 weeks')
last(first(CHL, '2 weeks'), '3 days')

periodicity(CHL)
unclass(periodicity(CHL))
to.weekly(CHL)
to.monthly(CHL)

periodicity(to.monthly(CHL))
endpoints(CHL,on="months")
apply.weekly(CHL,FUN=function(x) { max(Cl(x)) } )
period.apply(CHL,endpoints(CHL,on='weeks'),FUN=function(x) { max(Cl(x)) } )
as.numeric(period.max(Cl(CHL),endpoints(CHL,on='weeks')))

计算收益率
计算收益率的主要函数有：
periodReturn(x,
             period='monthly',
             subset=NULL,
             type='arithmetic',
             leading=TRUE,
             ...)
dailyReturn(x, subset=NULL, type='arithmetic',
           leading=TRUE, ...)
weeklyReturn(x, subset=NULL, type='arithmetic',
           leading=TRUE, ...)
monthlyReturn(x, subset=NULL, type='arithmetic',
           leading=TRUE, ...)
quarterlyReturn(x, subset=NULL, type='arithmetic',
           leading=TRUE, ...)
annualReturn(x, subset=NULL, type='arithmetic',
           leading=TRUE, ...)
yearlyReturn(x, subset=NULL, type='arithmetic',
           leading=TRUE, ...)
allReturns(x, subset=NULL, type='arithmetic',
           leading=TRUE)
求日收益率

periodReturn(x,period='daily')

或者

dailyReturn(x)

求周收益率

periodReturn(x,period='weekly')

或者

weeklyReturn(x)

求月收益率

periodReturn(x,period='monthly')

或者

monthlyReturn(x)


求年度收益率

periodReturn(x,period='quarterly')

或者

quarterlyReturn(x)



## 3.图形分析

### 3.1 两个基本的画图函数

chartSeries
chartSeries()函数是主绘图函数。

chart_Series(x,
             name = deparse(substitute(x)),
             type = "candlesticks",
             subset = "",
             TA = "",
             pars = chart_pars(),
             theme = chart_theme(),
             clev = 0)

主要参数：
x：时序数据
type:画图的类型
TA：技术分析指标
pars:图形参数
theme:主题

reChart}

reChart()是一个重新绘图函数。

### 3.2 三种基本图形
条形图}
barChart(CHL)
barChart(CHL,theme="white")
蜡烛图}
candleChart(CHL)
candleChart(CHL,multi.col=T,theme="white")
线图
lineChart(CHL)
lineChart(CHL,theme="white")

### 3.3 技术分析图

require(TTR)
平均趋向指标ADX}
平均趋向指标ADX是另一种常用的趋势衡量指标。 ADX无法告诉你趋势的发展方向。可是，如果趋势存在， ADX可以衡量趋势的强度。不论上升趋势或下降趋势， ADX 看起来都一样。 ADX 的读数越大，趋势越明显。衡量趋 势强度时，需要比较几天的 ADX 读数，观察 ADX 究竟是上升或下降。 ADX 读数上升，代表趋势转强；如果 ADX 读数下降，意味着趋势转弱。当 ADx 曲线向上攀升，趋势越来越强，应该会持续发展。如果 ADX 曲线下滑，代表趋势开始转弱，反转的可能性增加。单就 ADX 本身来说，由于指标落后价格走势，所以算不上是很好的指标，不适合单就 ADX 进行操作。可是，如果与其他指标配合运用， ADX 可以确认市场是否存在趋势，并衡量趋势的强度。
addADX()
平均真实波幅指标ATR}
addATR()
布林线指标BBands}
addBBands()
顺势指标CCI}
addCCI()
Chaikin资金流量指标CMF}
addCMF()
Chande动量摆动指标CMO}
addCMO()
指数平均数指标EMA}
addEMA()
包络线指标Envelope}
addEnvelope()
弹性成交量加权移动平均线指标EVWMA}
addEVWMA ()
移动平均收敛发散指标MACD}
addMACD ()
动量指标Momentum}
addMomentum ()
合约终止线Expiry}
addExpiry()
抛物线指标SAR}
addSAR()
简单移动平均指标SMA}
addSMA()
随机动量指标SMI}
addSMI()
双指数移动平均指标DEMA}
addDEMA()
区间震荡线DPO}
addDPO()
变动率指标ROC}
addROC ()
相对强弱指标RSI}
addRSI()
交易量指标Vo}
addVo()
加权移动平均线指标WMA}
addWMA()
威廉指标WPR}
addWPR()
零滞后指数移动平均ZLEMA}
addZLEMA()
辅助函数}
addTA()

newTA()

setTA(type = c("chartSeries", "barChart", "candleChart"))

listTA(dev)

### 3.4 修饰图形

设置背景颜色}
chartTheme()函数来设置颜色：
fg.col:foreground color
bg.col:background color
grid.col:grid color
border:border color
minor.tick:minor tickmark color
major.tick:major tickmark color
up.col:up bar/candle color
dn.col:down bar/candle color
up.up.col:up after up bar/candle color
up.dn.col:up after down bar/candle color
dn.dn.col:down after down bar/candle color
dn.up.col:down after up bar/candle color
up.border:up bar/candle border color
dn.border:down bar/candle border color
up.up.border:up after up bar/candle border color
up.dn.border:up after down bar/candle border color
dn.dn.border:down after down bar/candle border color
dn.up.border:down after up bar/candle border color 

### 3.5 图形缩放和存储

#### 图形缩放

zooom(n=1, eps=2)
zoomChart(subset, yrange=NULL)

#### 图形存储

getSymbols("AAPL")
chartSeries(AAPL)
require(TTR)
addBBands()
saveChart('pdf')
saveChart('pdf', width=13)


## 4 金融建模

### 4.1 建模准备

buildData()

buildData(Next(OpCl(DIA)) ~ Lag(TBILL) + I(Lag(OpHi(DIA))^2))
buildData(Next(OpCl(DIA)) ~ Lag(TBILL), na.rm=FALSE)
buildData(Next(OpCl(DIA)) ~ Lag(TBILL), na.rm=FALSE, return.class="ts")


getModelData(x, na.rm = TRUE)
modelData(m)

### 4.2 设定模型形式

buildModel(x, method, training.per, ...)
getSymbols('QQQQ',src='yahoo')
q.model = specifyModel(Next(OpCl(QQQQ)) ~ Lag(OpHi(QQQQ),0:3))
buildModel(q.model,method='lm',training.per=c('2006-08-01','2006-09-30'))


specifyModel(formula, na.rm=TRUE)
specifyModel(Next(OpCL(CHL))~Lag(OpHi(CHL),0:3)+Hi(CHL))

### 4.3 估计模型参数

fittedModel(x.lm)

### 4.4 模型结果分析

x <- specifyModel(Next(OpCl(DIA)) ~ OpCl(VIX))
x.lm <- buildModel(x,method='lm',training.per=c('2001-01-01','2001-04-01'))

fittedModel(x.lm)

coef(fittedModel(x.lm))
coef(x.lm)                  # same

vcov(fittedModel(x.lm))
vcov(x.lm)                  # same

### 模型应用

my.model <- specifyModel(Next(OpCl(QQQQ)) ~ Lag(Cl(NDX),0:5))
getModelData(my.model)
modelSignal()
tradeModel()

