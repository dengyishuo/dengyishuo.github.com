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