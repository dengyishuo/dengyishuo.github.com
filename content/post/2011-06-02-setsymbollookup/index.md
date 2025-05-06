---
title: setSymbolLookup
author: MatrixSpk
date: '2011-06-02'
slug: setsymbollookup
categories:
- investment
tags:
- quantmod
- 指定名称
- 股票数据
---
用quantmod获取OHLC数据时，如果不知道所有获取的股票的简称，在使用数据时可能会遇到一些麻烦，比如：


``` r
library(quantmod)
getSymbols("000065.SS")
```

获取数据后，敲入:

```
000065.SS
```

结果是无法返回所获取的数据。不过，不用着急，这个问题可以用setSymbolLookup来解决：


``` r
setSymbolLookup(myname=list(name="000065.SS", src="yahoo"))  
getSymbols("myname")  
MYNAME   #这里是大写字母
```
