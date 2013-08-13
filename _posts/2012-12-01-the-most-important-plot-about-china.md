---
layout: post
title: 里昂证券最重要的图表：中国外储增长表
comments: true
categories:
- investment(R)
tags:
- 外汇储备
- 证券
- 图表
---



  
几天前看到华尔街日报的一则报道，该报道采访了法国里昂证券的研究员Russel Napier。Russel Napier认为，全球经济已进入早期复苏阶段的希望可能过于乐观了。他说，中国外汇储备增长将出现令人担忧的停滞,而中国外汇储备增长一直是全球经济增长的动力。

从下图可以看到，中国外汇储备增长率已经在过去五年里急剧下降，并且现在已经接近零增长。Napier说下面这张图表是“世界上最重要的图表”。他说：“在过去20年中，中国外储增长决定了金融市场所有的关键发展动向。印钱措施将美国国债收益率曲线人为压低。它是全球经济增长的基石，而现在这一切结束了。”

 

与之相佐证的是eFinancial News的一则报道：

上一次中国外储增长低于10%出现在1990年代末，接着就是科技股市场泡沫破裂，经济衰退。自2001年增长恢复后，经济在那十年间也蓬勃发展。但是在2007年金融危机爆发前，中国外储增长再度下降。

在这里有必要厘清一下Russel Napier和eFinancial News背后的逻辑。在长久的一段时间里，世界经济的增长一直靠中美之间的金融配合驱动的。具体的逻辑是这样的：起点是美国开动印钞机，导致美国消费、投资增加；进一步导致以引入外资和出口为导向的国家（以中国为主）的外汇储备的增加（通过出口赢得外汇）；这些国家利用外储购买美国国债，使资金重新回流到美国，美国信贷增加，消费、投资增加。如此循环不已。

随着中国经济的发展，中国改变现行发展模式的动力越来越大。这意味着中国将不再像过去那样参与上面的信贷循环。这无疑将在短期内给世界经济带来沉重的打击。世界经济要恢复增长的路径无非两条：第一条，让中国重回过去的角色，这似乎不太可行。那么，就只有寻找一个替代中国的国家；第二条，中国开始扮演接近美国的角色，这样一来，中国需要进行大量的改革措施来适应这一角色。任重道远。

无论如何世界经济将经历一个艰难的再平衡过程，这个过程已经进行了3年，根据历史经验，还需要2-4年的时间才能走完。对投资者而言，这可能是个好机会。每当经济运行到底部，总是有一堆被低估的证券可供选择。

获取数据和绘制图形的R代码如下：

```
library(XML)
getFX=function(pg){
url=paste("http://data.caixin.com/macro/macro_indicator_more.html?id=F0010&cpage=",pg,"&pageSize=30&url=macro_indicator_more.html#top",sep="");
url=htmlParse(url,encoding="utf-8");
table=readHTMLTable(url)[[2]]
}
table=getFX(1)
for(i in 2:7){
temp=getFX(i)
table=rbind(table,temp)
}
write.csv(table,"FX.csv")
FX=read.csv("FX.csv")[,4]
growth=diff(rev(FX))/rev(FX)*100
growth.ts=ts(growth,start=c(1995,5),frequency=12)
png("fx.growth.png",bg="transparent")
plot(growth.ts,type="h",col="yellow2")
abline(h=0.5,col="red",lty=2)
text(1998,1,"1998")
text(2008,1,"2008")
text(2012,1,"2012")
dev.off()
```