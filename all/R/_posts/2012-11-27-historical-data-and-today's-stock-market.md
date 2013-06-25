---
layout: post
title: 从历史数据看今日股市
comments: true
categories:
- 投资
tags:
- 潜在合理增长线
- 投资
- 股市
---
  
在股市发展史上，人性的贪婪和恐惧总是交替出现的。如果我们假设股市存在一个潜在的合理增长线，
那么，贪婪和恐惧则周期性地驱动着股市围绕潜在合理增长线上下波动。在这个假设下，找到潜在的
合理增长线、最大偏离幅度及偏离持续期对于我们进行投资就显得很有意义。

观察一下1999年-2012年中国股市数据的直方图和经验累积分布函数图。我将大于`quantile(ssec,p=0.9)`
的数据定义为异常值（下图中的黑点部分）。剔除异常值数据之后，拟合出股市的潜在合理增长线（蓝色线）。
图形显示，中国股市已经步入低估时代（恐惧驱动的时代）一段时间了，然而，还没有见底。未来的底部可能
偏离潜在合理增长线在1.5倍标准差附近。

制作上图的R代码为：

{% highlight r %}
library(quantmod)
getSymbols("^SSEC",from="1991-01-01")
ssec=coredata(Cl(SSEC))

png("ssec.png",bg="transparent")
layout(m=matrix(c(1,2,
                  3,3),nc=2,byrow=T))

hist(ssec,prob=T)
lines(density(ssec))

plot(ecdf(ssec))
abline(h=0.9,lty=2)
abline(v=quantile(ssec,0.9),lty=2)

plot(ssec,pch=20)
points((1:length(ssec))[ssec< =quantile(ssec,0.9)],ssec[ssec<=quantile(ssec,0.9)],col="red",pch=20)
l=lm(ssec[ssec<=quantile(ssec,0.9)]~(1:length(ssec))[ssec<=quantile(ssec,0.9)])
abline(l,col="blue")

h=fitted(l)+2*sd(residuals(l))
lines((1:length(ssec))[ssec<=quantile(ssec,0.9)],h,col="green")

h=fitted(l)-2*sd(residuals(l))
lines((1:length(ssec))[ssec<=quantile(ssec,0.9)],h,col="green")
dev.off()

{% endhighlight r %}