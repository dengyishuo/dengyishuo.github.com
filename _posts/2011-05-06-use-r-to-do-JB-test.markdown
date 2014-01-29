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

统计检验过程是建立在假设随机误差[latex]u_t[/latex]服从正态分布的基础之上的。然而，我们不能直接地观察真实的误差项[latex]u_t[/latex]，那么，如何验证[latex]u_t[/latex]服从正态分布呢？聪明的朋友肯定知道答案：用[latex]u_t[/latex]的近似值——残差[latex]e_t[/latex]，因此，可通过[latex]e_t[/latex]来获悉[latex]u_t[/latex]的正态性。
一种常用的正态性检验是Jarque-Bera(雅克-贝拉)检验，简称JB 检验。它是依据OLS残差，针对大样本的一种检验方法(或称为渐近检验)。
首先计算偏度系数sk(对概率密度函数对称性的度量)：
[latex]sk=\frac{\sum(x_t-\bar x)^3}{n\sigma_{x}^3}[/latex]
及峰度系数k(对概率密度函数的“胖瘦”的度量)：
[latex]k=\frac{\sum(x_t-\bar x)^4}{n\sigma_{x}^4}[/latex]
正态分布的偏度为0，峰度为3。
Jarqe和Bera 建立了如下检验统计量——JB统计量：
[latex]JB=\frac{n}{6}(sk^2+\frac{(k^2}{4})[/latex]
他们证明了，在正态性假定下，JB统计量渐近地服从自由度为2的[latex]\chi ^2[/latex]分布。
如果变量服从正态分布，则S为零，K为3，因而JB 统计量的值为零。但是如果变量不是正态变量，则JB 统计量将为一个逐渐增大值。而针对每一个JB统计量，我们可以轻易算出其对应的P值，根据P值和事先确定的置信水平便可以确定是否拒绝变量为正态分布的假设。
在R软件中，Jarque-Bera检验可以用tseries包中的jarque.bera.test()来实现。
一个例子：
`
x=rnorm(20)
 jarque.bera.test(x)

Jarque Bera Test

data:  x
X-squared = 1.0972, df = 2, p-value = 0.5778
#p-value大于0.05，因此在95%置信水平下，无法拒绝x为正态分布的假设。
`
另外一个例子：
`
>x=1:200
>jarque.bera.test(x)

Jarque Bera Test

data:  x
X-squared = 12.0012, df = 2, p-value = 0.002477
#p-value远小于0.05，因此在95%置信水平下，拒绝x为正态分布的假设。
`
参考文献:
孙敬水，《计量经济学教程》
