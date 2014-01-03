---
author: admin
comments: true
layout: post
title: R中的MINE方法
categories:
- R
tags:
- MINE方法
---

提示：本文归格物堂所有，转载请注明出处！


这是http://www.exploredata.net网站设计的关于MINE（Maximal information-based nonparametric exploration）的一个函数代码。

用这段代码之前需要先下载一个[Java](http://www.java.com/en/download/index.jsp)；然后，下载一个[MINE.jar](http://www.exploredata.net/ftp/MINE.jar)放到R的工作目录下，当然，你还得保证自己安装了rJava和PortfolioAnalytics包，接下来运行下列代码得到一个示例：


> 

>     
>     <span style="color: #ff0000;">>   require(rJava)</span>
>      <span style="color: #ff0000;"> >   #load market data</span>
>      <span style="color: #ff0000;"> >   require(PortfolioAnalytics)</span>
>      <span style="color: #ff0000;"> >   data(indexes)</span>
>      <span style="color: #ff0000;"> >   datafilename <- "indexes.csv"</span>
>      <span style="color: #ff0000;"> >   write.table(indexes, datafilename, sep=",", col.names=TRUE,row.names=FALSE, quote=FALSE, na="NA")</span>
>      <span style="color: #ff0000;"> >   source('http://www.exploredata.net/ftp/MINE.r', encoding='UTF-8')</span>
>      <span style="color: #ff0000;"> >   MINE(datafilename,"all.pairs")</span>
>      <span style="color: #0000ff;"> MINE version 1.0.1c</span>
>      <span style="color: #0000ff;"> Copyright 2011 by David Reshef and Yakir Reshef.</span>
> 
> 

>     
>     <span style="color: #0000ff;">This application is licensed under a Creative Commons</span>
>      <span style="color: #0000ff;"> Attribution-NonCommercial-NoDerivs 3.0 Unported License.</span>
>      <span style="color: #0000ff;"> See</span>
>      <span style="color: #0000ff;"> http://creativecommons.org/licenses/by-nc-nd/3.0/ for</span>
>      <span style="color: #0000ff;"> more information.</span>
>     <span style="color: #0000ff;">input file = indexes.csv</span>
>      <span style="color: #0000ff;"> analysis style = allpairs</span>
>      <span style="color: #0000ff;"> results file name = 'indexes.csv,allpairs,cv=0.0,B=n^0.6,Results.csv'</span>
>      <span style="color: #0000ff;"> print status frequency = every 100 variable pairs</span>
>      <span style="color: #0000ff;"> status file name = 'indexes.csv,allpairs,cv=0.0,B=n^0.6,Status.txt'</span>
>      <span style="color: #0000ff;"> alpha = 0.6</span>
>      <span style="color: #0000ff;"> numClumpsFactor = 15.0</span>
>      <span style="color: #0000ff;"> debug level = 0</span>
>      <span style="color: #0000ff;"> required common values fraction = 0.0</span>
>      <span style="color: #0000ff;"> garbage collection forced every 2147483647 variable pairs</span>
>      <span style="color: #0000ff;"> reading in dataset...</span>
>      <span style="color: #0000ff;"> done.</span>
>      <span style="color: #0000ff;"> Analyzing...</span>
>      <span style="color: #0000ff;"> 1 calculating: US Equities vs US Bonds...</span>
>      <span style="color: #0000ff;"> 15 variable pairs analyzed.</span>
>      <span style="color: #0000ff;"> Sorting results in descending order...</span>
>      <span style="color: #0000ff;"> done. printing results</span>
>      <span style="color: #0000ff;"> Analysis finished. See file "indexes.csv,allpairs,cv=0.0,B=n^0.6,Results.csv" for output</span>
>      <span style="color: #ff0000;">>   x<-read.csv("indexes.csv,allpairs,cv=0.0,B=n^0.6,Results.csv",header=TRUE)</span>
>      <span style="color: #ff0000;"> >   m1<-apply(x,2,table)</span>
>      <span style="color: #ff0000;"> >   m2x<-as.matrix(m1$X.var)</span>
>      <span style="color: #ff0000;"> >   m2y<-as.matrix(m1$Y.var)</span>
>      <span style="color: #ff0000;"> >   #get frequencies</span>
>      <span style="color: #ff0000;"> >   testx<-as.matrix(m2x[x$X.var])</span>
>      <span style="color: #ff0000;"> >   testy<-as.matrix(m2y[x$Y.var])</span>
>      <span style="color: #ff0000;"> >   #add the frequencies to the original data</span>
>      <span style="color: #ff0000;"> >   x2<-cbind(x,testx,testy)</span>
>      <span style="color: #ff0000;"> >   #sort rows based on frequency of second then first variable</span>
>      <span style="color: #ff0000;"> >   x2<-x2[order(x2$testy,decreasing=FALSE),]</span>
>      <span style="color: #ff0000;"> >   fx <- x2[order(x2$testx,decreasing=TRUE),]</span>
>      <span style="color: #ff0000;"> >   #fx is now sorted in decreasing frequency of col testvec and</span>
>      <span style="color: #ff0000;"> >   #  within those groups, ascending frequency of testvec2</span>
>      <span style="color: #ff0000;"> >   #create the correct sized matrix</span>
>      <span style="color: #ff0000;"> >   z<-diag(length(m2x)+1)</span>
>      <span style="color: #ff0000;"> >   #Now extract the data we want, in this case column 3 (MIC)</span>
>      <span style="color: #ff0000;"> > z[row(z)>col(z)]<-fx[,3]</span>
>      <span style="color: #ff0000;"> > z<-z+t(z)</span>
>      <span style="color: #ff0000;"> > diag(z)<-1</span>
>      <span style="color: #ff0000;"> > #create col/row names</span>
>      <span style="color: #ff0000;"> > fxnames<-c(names(m2x[order(m2x,decreasing=TRUE),]),</span>
>      <span style="color: #ff0000;"> +             labels(m2y[order(m2y,decreasing=TRUE),][1]))</span>
>      <span style="color: #ff0000;"> > colnames(z)<-fxnames</span>
>      <span style="color: #ff0000;"> > rownames(z)<-fxnames</span>
>      <span style="color: #ff0000;"> > z</span>
>      <span style="color: #0000ff;">Inflation US Tbill Commodities Int'l Equities US Equities</span>
>      <span style="color: #0000ff;"> Inflation        1.00000  0.23388     0.23122        0.15027     0.17174</span>
>      <span style="color: #0000ff;"> US Tbill         0.23388  1.00000     0.21476        0.16822     0.20829</span>
>      <span style="color: #0000ff;"> Commodities      0.23122  0.21476     1.00000        0.19439     0.18633</span>
>      <span style="color: #0000ff;"> Int'l Equities   0.15027  0.16822     0.19439        1.00000     0.33740</span>
>      <span style="color: #0000ff;"> US Equities      0.17174  0.20829     0.18633        0.33740     1.00000</span>
>      <span style="color: #0000ff;"> US Bonds         0.20486  0.26657     0.19237        0.16480     0.17298</span>
>      <span style="color: #0000ff;"> US Bonds</span>
>      <span style="color: #0000ff;"> Inflation       0.20486</span>
>      <span style="color: #0000ff;"> US Tbill        0.26657</span>
>      <span style="color: #0000ff;"> Commodities     0.19237</span>
>      <span style="color: #0000ff;"> Int'l Equities  0.16480</span>
>      <span style="color: #0000ff;"> US Equities     0.17298</span>
>      <span style="color: #0000ff;"> US Bonds        1.00000</span>
> 
> 

