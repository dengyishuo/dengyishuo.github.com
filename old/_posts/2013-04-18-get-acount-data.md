---
layout: post
title: 从东方财富网获取股票开户数据
comments: true
categories:
- R
tags:
- 抓取数据
- 股票开户数据
---
#从东方财富网获取股票开户数据
#http://data.eastmoney.com/cjsj/weeklystockaccounts.aspx?p=1

#载入XML包
require(XML)
#下面是抓取数据的函数
get_stock_acount=function(page){
url=paste("http://data.eastmoney.com/cjsj/weeklystockaccounts.aspx?p=",page,sep="")
url2=htmlParse(url,encoding="gbk")
tables=readHTMLTable(url2)[[1]]
return(tables)
}

#处理1-13页数据
for(i in 1:13){
dat=get_stock_acount(i)[2:21,2:7];
write.table(dat,"stock_acount.txt",append=TRUE,col.names="")
}
#处理第14页数据
dat=get_stock_acount(14)[2:8,2:7]
write.table(dat,"stock_acount.txt",append=TRUE,col.names="")