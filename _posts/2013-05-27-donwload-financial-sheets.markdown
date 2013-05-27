---
layout: post
title: 自动下载上市公司财务套表
categories:
- 量化投资
- R
tags:
- 财务报表
- R
---

在国内获取上市公司的财务数据，一直都叫人头疼。对于没有Wind这些终端的个人而言，只能一条路，那就是从网络上抓取。这还是有前提的：
网上得有数据可抓。好在从sina财经找到了一个可下载财务套表的接口，不慌不忙写一段自动下载的代码。

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