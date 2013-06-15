# 1 获取数据

要想用[quantmod](http://www.quantmod.com)进行数据分析，第一步自然得把数据导入到R里面。将数据导入[R](http://r-project.org)里面的著名的教程是[数据导入与导出](http://cran.r-project.org/doc/manuals/r-release/R-data.pdf)。里面对大部分关于导入和导出数据的内容都讲的很明晰，读者可以直接去看，这里不再赘述。下面只说一下针对[quantmod](http://www.quantmod.com)特有的一些数据导入和导出的做法。

[quantmod](http://www.quantmod.com)中从外部获取数据的途径有三种：

* 从网络上获取数据
* 从数据库读入数据
* 基于`read.table`、`read.csv`等函数读取数据并转化为[quantmod](http://www.quantmod.com)可适应的格式

## 1.1 从网络获取数据

[quantmod](http://www.quantmod.com )包中的`getSymbols()`函数可以从网络上获取数据。我们用`args()`函数看一下它的基本用法。


```{r}
# 安装并载入quantmod包
install.packages("quantmod")
require(quantmod)
```

```r
> args(getSymbols)
function (Symbols = NULL, env = parent.frame(), reload.Symbols = FALSE, 
    verbose = FALSE, warnings = TRUE, src = "yahoo", symbol.lookup = TRUE, 
    auto.assign = getOption("getSymbols.auto.assign", TRUE), 
    ...) 
NULL
```

`getSymbols()`函数各主要参数的意义如下：

参数|用途
-------|-------
Symbols|指定股票符号或者代码。
env|指定对象的创建位置。
reload.Symbols|是否在指定环境中重新载入数据，缺省设置为FALSE。
warnings|是否输出警告信息，缺省设置为TRUE。
src|指定抓取数据的网址，缺省设置为yahoo，也可以选择google。
symbol.lookup|从外部查找检索股票代码的路径。
auto.assign|是否将函数结构自动载入到工作环境。
file.path|指定文件路径的字符串。
...|其它参数。 

基于`getSymbols()`函数，我们可以从网络上常用的金融数据库中抓取各种金融数据，。目前`getSymbols()`函数支持的数据库包括：

* yahoo
* google
* FRED
* oanda

### 1.1.1 获取股票日交易数据

上证指数的符号是^SSEC,获取上证指数的代码如下：

```
getSymbols("^SSEC")
```

也可以通过上证指数的代码来获取该数据。可以查到上证指数的代码为`000001.ss`，其中`.ss`代表该指数从属于上交所。代码如下：

```
getSymbols("000001.ss")
```

```
例1：获取上证A股指数

上证A股指数的代码为000002.ss。
值得指出的是，由于上证A股指数没有自己的符号，因此为了使用数据的方便，需要动用setSymbolLookup函数。

setSymbolLookup(A.Share.index=list(name="000002.ss",src="yahoo"))
getSymbols("A.Share.index")
```

```
例2：获取上证B股指数
上证B股指数的代码为000003.ss。

setSymbolLookup(B.Share.index=list(name="000003.ss",src="yahoo"))
getSymbols("B.Share.index")
```

```
## 例3：获取上证综合指数
上证综合指数的代码为000008.ss。
setSymbolLookup(Conglomerate.index=list(name="000008.ss",src="yahoo"))
getSymbols("Conglomerate.index")
```

```
例4：获取沪深300指数
沪深300指数的代码为000300.ss。

setSymbolLookup(CSI300=list(name="000300.ss",src="yahoo"))
getSymbols("CSI300")
CSI300
```

```
例5：深圳成指
深证成指的代码为399001.sz，其中.sz代表该指数从属于深交所。

setSymbolLookup(component.index=list(name="399001.sz",src="yahoo"))
getSymbols("component.index")
component.index
```

```
例6：获取中国移动公司数据
中国移动公司的符号是CHL。

getSymbols("CHL")

```
```
例7：获取三一重工数据

三一重工的股票代码为600030.ss。

setSymbolLookup(SANY.HEAVY=list(name="600030.ss",src="yahoo"))
getSymbols("SANY.HEAVY")
SANY.HEAVY
```

### 1.1.3 获取上市公司股息数据
getDividends()函数可以获取上市公司的股息数据。

getDividends("CHL")

根据股息调整股票价格

adjustOHLC()函数可以对股票数据进行除息调整。

getSymbols("CHL", from="1990-01-01", src="yahoo")
head(CHL)
head(CHLL.a <- adjustOHLC(CHL))
head(CHL.uA <- adjustOHLC(CHL, use.Adjusted=TRUE))


### 1.1.4 获取股票分割数据
getSplits()函数可以获取上市公司的股票分割数据。

getSplits("MSFT")

### 1.1.5 从网络获取期权交易数据

AAPL.OPT <- getOptionChain("AAPL")
AAPL.OPTS <- getOptionChain("AAPL", NULL)

getSymbols("AAPL")
options.expiry(AAPL)
futures.expiry(AAPL)
AAPL[options.expiry(AAPL)]

### 1.1.6 获取和查看上市公司的财务报表

[quantmod](http://www.quantmod.com)中`getFinancials()`函数和`getFin()`函数可以获取上市公司的财务报表数据。看看两个函数的用法：
```
args(getFinancials)
args(getFin)
```

例子：获取中国移动公司的财务数据

```
getFinancials('CHL')
```

获取数据之后，可以通过`view.Fin`函数查看财务报表数据:

```
view.Fin(CHL.f)
```

### 1.1.7 从网络获取汇市数据
getFX()函数可以获取汇率数据。

getFX("USD/JPY")
getFX("EUR/USD",from="2005-01-01")

也可以：

getSymbols("USD/EUR",src="oanda")
getSymbols("USD/EUR",src="oanda",from="2005-01-01")

### 1.1.8 获取重金属交易数据
getMetals()函数可以获取重金属的交易数据。

getFX(c("gold","XPD"))
getFX("plat",from="2005-01-01")

### 1.1.9 获取美联储经济数据

getSymbols.FRED()函数可以获取美联储主页上的美国经济数据。

getSymbols('CPIAUCNS',src='FRED')


或者：

setSymbolLookup(CPIAUCNS='FRED')
getSymbols('CPIAUCNS')

## 1.2 从数据库获取股票数据

[quantmod](http://www.quantmod.com)除了支持从网络数据库直接抓取数据外，当然也支持从本地数据库读入数据。目前，能支持的数据库类型包括：

* mysql
* csv
* RData

对应的函数有以下几个：

* getSymbols.csv()：从csv文件读取OHLC数据
* getSymbols.MySQL()：从MySQL数据库读取数据
* getSymbols.SQLite()：从SQLite数据库读取数据
* getSymbols.rda()：读取以.r格式存储的数据


## 1.3 查看和移除股票数据

### 1.3.1 查看股票数据

getSymbols("CHL","000023.ss")
showSymbols(env=.GlobalEnv)

结果如下：

### 1.3.2 移除股票数据

RemoveSymbols("CHL")
showSymbols(env=.GlobalEnv)

getQuote("AAPL")
getQuote("QQQQ;SPY;^VXN",what=yahooQF(c("Bid","Ask")))
standardQuote()
yahooQF()

attachSymbols()
