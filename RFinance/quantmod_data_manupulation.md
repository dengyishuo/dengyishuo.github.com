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
