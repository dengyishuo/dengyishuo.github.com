---
layout: post
title: R中的斯皮尔曼等级相关检验与异方差
comments: true
categories:
- R语言
tags:
- speraman
- spearman test
- 异方差
- 斯皮尔曼等级相关 
---
  
有一种异方差表现为模型的残差与自变量相关，也就是说，模型残差随着自变量增大而变大或者反之。在
这种情况下只要度量模型的残差与自变量的相关性就可以确定是否有异方差了。如果自变量是连续变量，
则普通的相关性检验就可以奏效。倘若自变量是年龄、职业、气候等定型变量时就得考虑别的方法了。

此时，斯皮尔曼等级相关检验是个不错的选择。斯皮尔曼等级相关检验是一种非参数检验方法，它的大致原理是这样的：
如果变量和变量相关，那么，将两者按照大小排序，则两者的顺序应该是相仿的，若两者相关性弱，则两者的顺序没有明显的一致性。
举个简单的例子：

{% highlight c %}
 25 40 54 58 68 
 1.6 2.9 10.7 14.8 5.7 
{% endhighlight %}

上下对应，下面按照的大小进行排序，则能看到下面的结果：

{% highlight c %}
x排序号（秩） y排序号（秩） 序号差 
1 1 0 
2 2 0 
3 4 -1 
4 5 -1 
5 3 2 
{% endhighlight %}

构造统计量，容易知道等于1时，两者正相关，等于-1时两者负相关。设定原假设统计量为零，该统计量
近似服从均值为0，方差为的正态分布，由此可对其进行假设检验。

R中`pspearman`包中的`spearman.test`函数可以完成斯皮尔曼等级相关检验：

{% highlight c %}
library(pspearman)
x=c(25,40,53,58,68)
y=c(1.6,2.9,10.7,14.8,5.7)
spearman.test(x,y)
Spearman's rank correlation rho
data:?? x and y
 S = 6, p-value = 0.2333
 alternative hypothesis: true rho is not equal to 0
 sample estimates:
 rho 
 0.7
{% endhighlight %}

也可用`cor.test`函数来检验：

{% highlight c %}
> cor.test(x,y,method="spearman")
Spearman's rank correlation rho
data:?? x and y
 S = 6, p-value = 0.2333
 alternative hypothesis: true rho is not equal to 0
 sample estimates:
 rho
 0.7
{% endhighlight %}

