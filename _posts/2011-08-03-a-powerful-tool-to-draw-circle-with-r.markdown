---
author: admin
comments: true
layout: post
title: draw.circle，R中的绘圆利器
categories:
- R语言
tags:
- 圆
- 绘图
---

R用户经常要在图形中绘圆，如果你是其中的一员的话，你就不得不了解一下plotrix包中的draw.circle()函数。draw.circle()函数的优点有：
	
  * 任意指定位置
  * 随意设定圆内的颜色
  * 随意设定圆的线型
  * 随意设定圆线的颜色


[code]
library(plotrix)
plot(1:5,seq(1,10,length=5),type="n",xlab="",ylab="",main="Test draw.circle")
draw.circle(2,4,c(1,0.66,0.33),border="purple",
col=c("#ff00ff","#ff77ff","#ffccff"),lty=1,lwd=1)
draw.circle(2.5,8,0.6,border="red",lty=3,lwd=3)
draw.circle(4,3,0.7,border="green",lty=1,lwd=1)
draw.circle(3.5,7,0.8,border="blue",lty=2,lwd=2)
[/code]
[![](http://yishuo.org/wp-content/uploads/2011/08/circle1.png)](http://yishuo.org/wp-content/uploads/2011/08/circle1.png)
