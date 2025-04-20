---
author: admin
comments: true
date: 2011-02-28 14:08:40
layout: post
slug: income-position
title: 收入温度计：看看你的收入位置在哪里
wordpress_id: 545
categories:
- economics
tags:
- 收入
- 温度计
---

在这个贫富迥异的年代，看看你的收入位置在哪里？
[![](http://yishuo.cos.name/wp-content/uploads/2011/02/d.png)](http://yishuo.cos.name/wp-content/uploads/2011/02/d.png)
`
library(plotrix)
plot(0,xlim=c(-6,5),ylim=c(0,5),type="n",axes=F,ylab="",xlab="")
draw.circle(0,1,1.5,border="wheat4",col="wheat4")
draw.circle(0,1,1,border="yellow2",col="yellow2")
draw.circle(0,1,0.7,border="red",col="red")
polygon(c(-0.4,-0.4,0.4,0.4),c(1.7,4.5,4.5,1.7),col="wheat4",border="wheat4")
polygon(c(-0.25,-0.25,0.25,0.25),c(1.5,4.5,4.5,1.5),col="yellow2",border="yellow2")
polygon(c(-0.1,-0.1,0.1,0.1),c(1.3,4.2,4.2,1.3),col="red",border="red")
lines(c(-5,-0.4),c(1.5,1.5),col="wheat4")
lines(c(-5.2,-0.4),c(2,2),col="wheat4")
lines(c(-5.4,-0.4),c(2.5,2.5),col="wheat4")
lines(c(-5.6,-0.4),c(3,3),col="wheat4")
lines(c(-5.8,-0.4),c(3.5,3.5),col="wheat4")
lines(c(-6,-0.4),c(4,4),col="wheat4")
text(-4,4.1,"富人家庭：年入200万以上",cex=0.8)
text(-3.8,3.6,"富裕家庭：年入80万-200万",cex=0.8)
text(-3.6,3.1,"中产家庭：年入40万-80万",cex=0.8)
text(-3.4,2.6,"小康家庭：年入20万-40万",cex=0.8)
text(-3.2,2.1,"贫穷家庭：年入10万-20万",cex=0.8)
text(-3,1.6,"贫困家庭：年入10万以下",cex=0.8)
lines(c(0.4,1),c(2.5,2.5),col="red")
text(2,2.5,"你在哪里？")
text(0,1,"收入",cex=1.5)
`
