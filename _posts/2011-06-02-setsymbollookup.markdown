---
author: admin
comments: true
date: 2011-06-02 12:50:58
layout: post
slug: setsymbollookup
title: setSymbolLookup
wordpress_id: 742
categories:
- 金融投资分析(R)
tags:
- quantmod
- R&amp;数据艺术
- 指定名称
- 股票数据
---

[code]
主人云：站内文章皆为信手涂鸦，不时需要修改纰漏，转载引用请注明出处！
[/code]
用quantmod获取OHLC数据时，如果不知道所有获取的股票的简称，在使用数据时可能会遇到一些麻烦，比如：
[code]
library(quantmod)
getSymbols("000065.SS")
[/code]
获取数据后，敲入
[code]
000065.SS
[/code]
无法返回所获取的数据。
这个问题可以用setSymbolLookup来解决：
[code]
setSymbolLookup(myname=list(name="000065.SS", src="yahoo"))  
getSymbols("myname")  
MYNAME   #这里是大写字母
[/code] 
