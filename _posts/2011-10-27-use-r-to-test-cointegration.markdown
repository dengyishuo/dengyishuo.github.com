---
comments: true
layout: post
title: 用R检验股票的协整关系
categories:
- R&amp;数据艺术
tags:
- 协整
- 股票
---

## 用到的R包：


xts和zoo。
xts和zoo是两个强大的处理时序对象的R包，xts包本身又相当于是一个加强版的zoo包。因此，这里只说zoo包。
zoo包处理的对象是zoo，zoo对象与数据框（dataframe)类似，由行列构成。不同的是，zoo对象比数据框（data frame）多了一个时间戳。假设我们有一个zoo对象t，index(t)返回时间戳，也就是一个表示日期的向量。start(t)和end（t）可以查看zoo对象的起始值和末端值。


## 数据预处理：


分四个步骤：
1.读入数据（data frame格式）
2.将日期转化为Date对象
3.将data frame数据转换为zoo对象
4.合并数据
相应的R代码：
`
library(zoo) #载入zoo包
##读入csv数据
gld=read.csv("http://ichart.finance.yahoo.com/table.csv?s=GLD&ignore=.csv", stringsAsFactors=F)
gdx=read.csv("http://ichart.finance.yahoo.com/table.csv?s=GDX&ignore=.csv", stringsAsFactors=F)
##数据框的第一列数据为日期数据。用as.Date函数将字符型日期转化为Date对象
gld_dates=as.Date(gld[,1])
gdx_dates=as.Date(gdx[,1])
##数据框的第七列为相应的调整收盘价。用zoo函数将调整收盘价转换为zoo对象。
gld=zoo(gld[,7],gld_dates)
gdx=zoo(gdx[,7],gdx_dates)
##用merge将数据合并
t.zoo=merge(gld,gdx,all=FALSE)
#因为R中的大部分数据分析函数的输入参数是dataframe，我们将t。zoo转化为数据框（data frame)
t=as.data.frame(t.zoo)
##返回杀数据的时间跨度
cat("数据的时间跨度是",format(start(t.zoo)),"至",format(end(t.zoo)),"\n")
`


## 构建分布：


在Ernie的书中，他先检验协整，在构建分布。在这里，我们采用相反的步骤以便于读者理解：我们先构建一个分布，然后再对分布进行单位根检验：如果没有单位根，则两个股票序列是协整的。
构建分布：
S=y-(\beta*X)
\beta表示对冲比率。可以用OLS法算出来。
y=(-\beta)*X
估计上式即可得出\beta.
R代码：
`
m=lm(gld~gdx+0,data=t)
beta=coef(m)[1]
cat("对冲比率是",beta,"\n")
#计算分布
sprd=t$gld-beta*t$gdx
`
其对应的具体数据为：
GLD_i=\beta*GDX_i+\epsilon_i


## 检验协整：


可以用增广（Augmented）Diickey-Fuller检验来检验分布的单位根。R中的tseries包中的adf.test()可以实现这一过程。
`
library(tseries) #载入tseries包
#令alternative=stationary，K=0
ht=adf.test(sprd,alternative="stationary",k=0)
cat("ADF检验的P值是",ht$p-value,"\n")
#将alternative设定为stationary很重要，这意味着，零假设为分布是非平稳的。
#如果p值很小，意味着分布是均值回复的。
if(ht$p.valuecat("分布是均值回复的.\n")
}else{
cat("分布不是均值回复的.\n")
}
`
整合代码：
`
library(zoo)
library(tseries)
gld <- read.csv("http://ichart.finance.yahoo.com/table.csv?s=GLD&ignore;=.csv", stringsAsFactors=F)
gdx <- read.csv("http://ichart.finance.yahoo.com/table.csv?s=GDX&ignore;=.csv", stringsAsFactors=F)
cat("数据的时间跨度是",format(start(t.zoo)),"至",format(end(t.zoo)),"\n")
t.zoo <- merge(gld, gdx, all=FALSE)
t <- as.data.frame(t.zoo)
m <- lm(gld ~ gdx + 0, data=t)
beta <- coef(m)[1]
cat("对冲比率是",beta,"\n")
sprd <- t$gld - beta*t$gdx
ht <- adf.test(sprd, alternative="stationary", k=0)
cat("ADF检验的P值是",ht$p-value,"\n")
if(ht$p.value cat("分布是均值回复的.\n")
}else{
cat("分布不是均值回复的.\n")
}
#返回结果
数据的时间跨度是 2006-05-23 至 2011-10-25
对冲比率是2.224323
分布不是均值回复的.
`
参考资料：http://quanttrader.info/public/testForCoint.html
