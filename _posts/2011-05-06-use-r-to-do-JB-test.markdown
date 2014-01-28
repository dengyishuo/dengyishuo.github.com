---
comments: true
layout: post
title: 用R进行Jarque Bera检验
wordpress_id: 690
categories:
- econometrics
tags:
- jarque bera检验
- jb检验
- 正态性检验
---

线性回归模型的检验是建立在假设随机误差$ u_t $服从正态分布的基础之上的。但问题是我们没有办法直接观察到真实的$ u_t $，那么，如何验证它是否服从正态分布呢？一般来说，会用残差$ e_t $近似表示$ u_t $，因此，可以通过$ e_t $的正态性来推断$ u_t $的正态性。

一种比较常用的正态性检验 Jarque-Bera(雅克-贝拉)检验，简称JB 检验。它是依据 OLS 残差，针对大样本的一种检验方法(或称为渐近检验)。其思路大概是这样的：

首先，计算偏度系数$ sk $ 和 峰度系数 $ k $：

$$
sk=\frac{\sum\(x_t-\bar x\)^3}{n\sigma\_{x}^3}

k=\frac{\sum(x_t-\bar x)^4}{n\sigma\_{x}^4}
$$

Jarqe 和 Bera 建立了如下检验统计量——JB统计量：

$$
JB=\frac{n}{6}(sk^2+\frac{(k-3)^2}{4})
$$

在正态性假定下，JB 统计量渐近服从自由度为 2 的$ \chi ^2 $分布。

显然，如果变量服从正态分布，则 S 为零，K 为 3，因而 JB 统计量的值为零。如果变量不是正态变量，则 JB 统计量将为一个逐渐增大值。而针对每一个 JB 统计量，都可以算出其对应的 P 值，根据 P 值和事先确定的置信水平便可以确定是否拒绝变量为正态分布的假设。

在 R 软件中，Jarque-Bera 检验可以用 tseries 包中的 jarque.bera.test 来实现。我们这里虚构两个数据，第一个例子中的数据服从正态分布，第二例子中的数据是1到200的序列。

{% highlight r %}
 library(tseries)
 set.seed(123)
 x=rnorm(20)
 jarque.bera.test(x)

        Jarque Bera Test

data:  x
X-squared = 0.0819, df = 2, p-value = 0.9599
{% endhighlight %}

p-value 大于 0.05 ，因此在 95% 置信水平下，无法拒绝 x 为正态分布的假设。

另外一个例子：


{% highlight r %}
 library(tseries)
 x=1:200
 jarque.bera.test(x)

        Jarque Bera Test

data:  x
X-squared = 12.0012, df = 2, p-value = 0.002477
{% endhighlight %}

p-value远小于0.05，因此在 95% 置信水平下，拒绝 x 为正态分布的假设。
