---
layout: post
title: 自动下载财务套表
comments: true
categories:
- R语言
tags:
- 财务报表
- R
---


在国内获取上市公司的财务数据是一件叫人头疼的事儿。对于没有Wind终端的个人而言，只有一条路：那就是从网络上抓取。当然，这还是有前提的，那就是网上得有数据可抓。很长一段时间，我都受此困扰，跋山涉水之后，终于从sina财经找到了一个可以下载上市公司历年财务套表的接口，用R写一段自动下载的代码，就可以轻松获取上市公司财务数据了（耶！好开心，妈妈再也不用担心我的的数据来源了！）。代码真相在这里：

{% highlight r %}
####symbol:股票代码
####type：报表类型。BS为资产负债表；PS为利润表；CF为现金流量表
####file:存储下载文件的地址。比如file="D://"

getsheets=function(symbol,type,file){
pre="http://money.finance.sina.com.cn/corp/go.php/vDOWN_";
mid="/displaytype/4/stockid/";
end="/ctrl/all.phtml";

if(type=="BS"){
url=paste(pre,"BalanceSheet",mid,symbol,end,sep="");
destfile=paste(file,"BalanceSheet_",symbol,".xls",sep="");
}
if(type=="PS"){
url=paste(pre,"ProfitStatement",mid,symbol,end,sep="");
destfile=paste(file,"ProfitStatement_",symbol,".xls",sep="");
}
if(type=="CF"){
url=paste(pre,"CashFlow",mid,symbol,end,sep="");
destfile=paste(file,"CashFlow_",symbol,".xls",sep="");
}
download.file(url, destfile);
}
{% endhighlight %}

举个例子；
{% highlight r%}
# 下载000065的资产负债表，并存放在D盘
getsheets("000065","BS","D://")
{% endhighlight %}

D盘里面有一个叫BalanceSheet_000065.xls的文件，打开就可以看到历年的资产负债表数据了。