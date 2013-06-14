---
layout: post
title: quantmod:R中的金融分析包
comments: true
categories:
- R
tags:
- quantmod
- R
---


##  1.导入、导出及删除数据

要想用[quantmod](http://www.quantmod.com)进行数据分析，第一步自然是得把数据导入到R里面。将数据导入R里面的最著名的教程是[数据导入与导出]（）。里面对大部分关于导入和导出数据的内容都讲的很明晰，读者可以直接去看，这里不在赘述。下面只说一下针对[quantmod](http://www.quantmod.com)特有的一些数据导入和导出的做法。

[quantmod](http://www.quantmod.com)中从外部获取数据的途径有三种：

* 基于`getSymobls()`函数从网络上抓取
* 基于`getSymbols.csv()`函数从`.csv`的文件中读取
* 基于`read.table`、`read.csv`等函数读取数据并转化为quantmod可适应的格式

`getSymbols`是quantmod包中主函数之一。主要作用是从外部读取数据。

{% highlight r%}
 ?getSymbols
{% endhighlight %}



