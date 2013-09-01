---
layout: post
title: add.indicator函数笔记
comments: true
categories:
- r
tags:
- quantstrat
- add.indicator
- r
---

发布日期:2013-09-01 作者:邓一硕 

add.indicator  函数是 quantstrat 包中的主函数之一。它的主要功能是生成信号指示器。这种解释方法有点绕口。举个例子说起来更容易明白。假如说，我们想测试这样一个策略：即当某支股票的价格低于5日算术平均时，买入该股票；高于5日算术平均时卖出该股票。那么，在这个测试过程中，我们要用到 SMA(price,n=5) 这个序列，既然要用到这个序列，那么得首先生成这个序列，而 add.indicator  函数就是干这个的，是用来生成序列的。

看看帮助文档中的 add.indicator 函数的参数：

{% highlight r %}
add.indicator(strategy, name, arguments,
    parameters = NULL, label = NULL, ..., enabled = TRUE,
    indexnum = NULL, store = FALSE)
{% endhighlight %}

strategy 参数是策略名。在 quantstrat 包的框架中，所有指示器（indicator）都从属于策略（strategy），因此，使用  add.indicator 时要率先指定策略名； name 参数的作用是指定生成指示器所用的 R 函数，比如，这里我们用到的函数是 SMA ，那么，此时的  name 参数就是  SMA ；arguments 参数也是个从属参数，它的作用是指定 name 参数对应的那个函数的参数。好绕口！说人话的话是这样的：SMA 函数除了要输入时间序列参数 x 外，还得指定做算术平均时候的时间跨度 n；label 参数的作用是设定指示器的标签，这样再生成指示器序列时，指示器的序列名的后缀会是该标签的内容，参数默认是 name+ind。其它参数暂时不怎么重要，就不闲扯了，多说无益，上代码：

{% highlight r %}
##定义一个策略，名字名为 str_sma 
strategy("str_sma", store=TRUE)
##获取策略的标的，名字为 SPY
getSymbols("SPY", src='yahoo')
##添加指示器
add.indicator('str.sma', 'SMA', arguments=list(x=quote(Ad(SPY)), n=20),label="sma.20")
##查看策略的结构
str(getStrategy('str.sma')$indicators)
## 执行指示器
out <- applyIndicators('str.sma', SPY)
## 查看指示器结果
tail(out)
{% endhighlight %}
