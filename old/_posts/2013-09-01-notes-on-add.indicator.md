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

<font color=#545450 >发布日期:2013-09-01 作者:邓一硕</font>

<b>add.indicator</b>函数是quantstrat包中的主函数之一。它的主要功能是生成信号指示器。这种解释方法有点绕口。举个例子说起来更容易明白。假如说，我们想测试这样一个策略：即当某支股票的价格低于5日算术平均时，买入该股票；高于5日算术平均时卖出该股票。那么，在这个测试过程中，我们要用到 SMA(price,n=5) 这个序列（SMA函数的作用是计算算术平均），既然要用到这个序列，那么得首先生成这个序列， add.indicator函数就是干这个的，是用来生成序列的。

看看帮助文档中的 add.indicator 函数的参数：

{% highlight r %}
add.indicator(strategy, name, arguments,
    parameters = NULL, label = NULL, ..., enabled = TRUE,
    indexnum = NULL, store = FALSE)
{% endhighlight %}

strategy参数是策略名。在quantstrat 包的框架中，所有指示器（indicator）都从属于策略（strategy），因此，使用add.indicator函数时要率先指定策略名；name参数的作用是指定生成指示器所用的R函数，比如，这里我们用到的函数是SMA ，那么，此时的name参数就是SMA；arguments参数也是个从属参数，它的作用是指定name 参数对应的那个函数的参数。好绕口！说人话的话是这样的：SMA函数除了要输入时间序列参数x 外，还得指定做算术平均时候的时间跨度n，而这个n就是在aruments中指定的。label参数的作用是设定指示器的标签，这样在生成指示器序列时，指示器的序列名的后缀会是该标签的内容。该参数默认是 name+ind。其它参数暂时不怎么重要，就不闲扯了，多说无益，上代码：

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
