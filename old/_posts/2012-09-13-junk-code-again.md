---
layout: post
title: 乱码，又见乱码
comments: true
categories:
- R
tags:
- R
- 财务数据
- 财新网
- 宏观数据
- htmlParse
- readHTMLTable
- utf-8
- XML
- 乱码
- 抓数据 
---
  
当网页编码为unicode时，有时候在Windows系统下用readHTMLTable函数读入网页时会出现乱码，这个时候的乱码是因为R是用本地码（通常是GBK）来解释unicode。此时，只要用iconv(x,"utf-8","gbk")就可以了。
然而，有时候会出现另外一种情况：
{% highlight r %}
library(XML);
url="http://data.caixin.com/macro/macro_indicator_more.html?id=F0001&cpage=2&pageSize=30&url=macro_indicator_more.html#top";
tables=readHTMLTable(url)[[2]];
head(tables)
 V1 V2 V3 V4
 1 101′2 42,865.82 224,286.95 636,072.26
 2 101′1 40,758.58 229,588.98 625,609.29
 3 091′12 38,246.97 221,445.81 610,224.52
 4 091′11 36,343.86 212,493.18 594,604.72
 5 091′10 35,730.23 207,545.74 586,643.29
 6 091′9 36,787.89 201,708.14 585,405.34
{% endhighlight %}

这种情况下icnov好像就无能为力了，不过事情还是有解决方案的。正如回复中所言，在readHTMLTable之前加上一句代码就可以了。

{% highlight r %}
url= htmlParse(url,encoding="UTF-8")看看效果：

> library(XML);
> url="http://data.caixin.com/macro/macro_indicator_more.html?id=F0001&cpage=2&pageSize=30&url=macro_indicator_more.html#top";
> url= htmlParse(url,encoding="UTF-8")
> tables=readHTMLTable(url)[[2]];
> head(tables)
 V1 V2 V3 V4
1 10年2月 42,865.82 224,286.95 636,072.26
2 10年1月 40,758.58 229,588.98 625,609.29
3 09年12月 38,246.97 221,445.81 610,224.52
4 09年11月 36,343.86 212,493.18 594,604.72
5 09年10月 35,730.23 207,545.74 586,643.29
6 09年9月 36,787.89 201,708.14 585,405.34 
{% endhighlight %}
 