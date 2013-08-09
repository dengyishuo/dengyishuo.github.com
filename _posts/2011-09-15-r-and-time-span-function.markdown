---
author: admin
comments: true
date: 2011-09-15 10:54:49
layout: post
slug: r-and-time-span-function
title: R与月跨度函数，理论与应用的差距
wordpress_id: 854
categories:
- R语言
tags:
- 差距
- 应用
- 月跨度函数
- 理论
---

R在处理数据方面的灵活性一直都被人们赞誉。当然，理论界的人给的多些，应用界的人相对较少。混迹应用界的人一般会对R有更多的细节要求。比如在处理日期的时候，如果我想获取两个日期，2010年3月25日和2010年6月27日的月跨度，R里面就没有现存的函数。这一点让我意外，因为这是数据处理实务中经常遇到的问题啊。为什么R包的作者没有想到呢？不要抱怨，抱怨没用，这就是理论和应用的差距。应用者的一切以方便为导向，理论者则不同，他们负责提供石头，建筑有时候要靠你自己去完成。
花了一会儿时间，找到了三个石头，length,months,seq。完成了建筑，在代码里面把2010-03-**全部处理为2010-03-01，把2010-06-**全部处理成2010-06-01。
[code]
> length(seq(from=as.Date(paste(substr(d1,1,7),"01",sep="-")),
+                to=as.Date(paste(substr(d2,1,7),"01",sep="-")),
+                by="month"))
[1] 4
[/code]
当然，也可以封装一下：
[code]
> month.span=function(d1,d2){
+ date1=paste(substr(d1,1,7),"01",sep="-")
+ date2=paste(substr(d2,1,7),"01",sep="-")
+ L=length(seq(from=as.Date(date1),to=as.Date(date2),by="month"))
+ L
+ }
> 
> d1="2010-03-25";
> d2="2010-06-24";
> month.span(d1,d2)
[1] 4
[/code] 
