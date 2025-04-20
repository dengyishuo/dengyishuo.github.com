---
layout: post
title: WDI包：从世界银行获取世界发展指标数据
comments: true
categories:
- R
tags:
- WDI
- 世界银行
- 世界发展指数
---

<b>发布日期:2013-09-01 作者:邓一硕</b>

在网络上闲逛时偶然发现了WDI包。

搜索、提取及格式化世界银行（World Bank）公布的世界发展指标（World Development Indicators）数据。

包括一个数据对象WDI_data及三个函数 WDIsearch、WDIcache和WDI。其中，WDI是主函数，WDIsearch和WDIcache是辅助函数。

WDI_data作为一个本地对象，保存了世界银行截止2012年6月18日所有可获得的指标信息。

WDIcache函数作用是更新可获得的WDI的指标列表。从世界银行网站上下载一个WDI指标的列表。返回一个数据框，该数据框可以作为WDIsarch函数的对象。从世界银行网站下载所有的时序信息会非常耗时间。用来对wDI_data对象中的信息进行更新。通过 cache 函数输入到WDIsearch函数中。

WDIseach函数的作用是搜索所有WDI序列的名字和信息描述。搜索WDI序列的代码、名字、描述及数据源。

{% highlight r %}
 WDIsearch(string = "gdp", field = "name", short = TRUE,
    cache = NULL)
{% endhighlight %}

string 搜索关键字
field 搜索范围'indicator', 'name', 'description', 'sourceDatabase', 'sourceOrganization'等。
short 逻辑变量。TRUE，只返回代码和名字。FALSE返回序列的所有信息。
cache WDIcache函数生成的数据列表。缺失的话，WDIsearch会在本地的数据列表中进行查询。

返回的是满足特定搜索条件的序列的代码、名字、数据源及序列描述。

{% highlight r %}
WDIsearch(string='gdp', field='name', cache=NULL)
WDIsearch(string='AG.AGR.TRAC.NO', field='indicator', cache=NULL)
{% endhighlight %}

使用世界银行的API获取需要的数据，解析生成的JSON文件并将结果整理为包含国家和年份信息的长格式数据。






















