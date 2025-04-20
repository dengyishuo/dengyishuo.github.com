---
comments: TRUE
layout: post
title: R数据分析实例：稳健回归
categories:
- R
tags:
- 数据分析
- 实例
- 稳健回归
- Robust Regression
---

**按语：**当数据含有离群点（Outliar）或者强影响点（influential observation）时，稳健回归（Robust Regression）会比普通最小二乘法(OLS)的表现要更优异。稳健回归也可以用来检测数据中的强影响点。

**提示:** 本文旨在介绍与稳健回归相关的R命令，因此，并未全面覆盖稳健回归的相关知识，也不涉及数据清洗、数据检测、模型假设和模型诊断等内容。

文档内容基于R 2.14.0，最后更新于2011年12月19日。

#### 简介


介绍几个线性回归（linear regression）中的术语：

**残差（Residual）**:  基于回归方程的预测值与观测值的差。

**离群点（Outlier）**:  线性回归（linear regression）中的离群点是指对应残差较大的观测值。也就是说，当某个观测值与基于回归方程的预测值相差较大时，该观测值即可视为离群点。  离群点的出现一般是因为样本自身较为特殊或者数据录入错误导致的，当然也可能是其他问题。

**杠杆率（Leverage）**: 当某个观测值所对应的预测值为极端值时，该观测值称为高杠杆率点。杠杆率衡量的是独立变量对自身均值的偏异程度。高杠杆率的观测值对于回归方程的参数有重大影响。

**影响力点：（Influence）**: 若某观测值的剔除与否，对回归方程的系数估计有显著相应，则该观测值是具有影响力的，称为影响力点。影响力是高杠杆率和离群情况引起的。

**Cook距离（Cook's distance**）: 综合了杠杆率信息和残差信息的统计量。

使用最小二乘回归时，有时候会遇到离群点和高杠杆率点。此时，若认定离群点或者高杠杆率点的出现并非因为数据录入错误或者该该观测值来自另外一个总体的话，使用最小二乘回归会变得很棘手，因为数据分析者因为没有充分的理由剔除离群点和高杠杆率。此时稳健回归是个极佳的替代方案。稳健回归在剔除离群点或者高杠杆率点和保留离群点或高杠杆率点并像最小二乘法那样平等使用各点之间找到了一个折中。其在估计回归参数时，根据观测值的稳健情况对观测值进行赋权。简而言之，稳健回归是加权最小二乘回归，或称文艺最小二乘回归。

**MASS** 包中的 **rlm**命令提供了不同形式的稳健回归拟合方式。接下来，以基于Huber方法和bisquare方法下的M估计为例来进行演示。这是两种最为基本的M估计方法。在M估计中，要做的事情是在满足约束 ∑ i=1 n wi (yi-x'b) xi' = 0 时，求出使得 ∑wi2ei2 最小的参数。由于权重的估计依赖于残差，而残差的估计又反过来依赖于权重，因此需用迭代重复加权最小二乘（ **I**teratively **R**eweighted **L**east **S**quares ，IRLS）来估计参数。举例，第j次迭代得到的系数矩阵为: Bj = [ X' Wj-1 X ] -1 X' Wj-1 Y ，这里下脚标表示求解过程中的迭代次数，而不是通常的行标或者列标，持续这一过程，直到结果收敛为止。Huber方法下，残差较小的观测值被赋予的权重为1，残差较大的观测值的权重随着残差的增大而递减，具体函数为：w(e)={1  for  |e|<=kk|e|  for  |e|>k . 而bisquare方法下，所有的非0残差所对应观测值的权重都是递减的。


#### 数据描述


下面用到的数据是Alan Agresti和Barbara Finlay所著的《_Statistical Methods for Social Sciences_》_(Third Edition_，Prentice Hall, 1997)中的crime数据集。该数据集的变量分别是：


> state id (**sid**),

state name (**state**),

violent crimes per 100,000 people (**crime**),

murders per 1,000,000 (**murder**),

the percent of the population living in metropolitan areas (**pctmetro**),

the percent of the population that is white (**pctwhite**),

percent of population with a high school education or above (**pcths**),

percent of population living under poverty line (**poverty**),

percent of population that are single parents (**single**).


该数据集共有51个观测值。接下来用数据集中的**poverty** 和 **single** 变量来预测 **crime**.


> 

>     
>     <strong> library(foreign) cdata <- read.dta("http://www.ats.ucla.edu/stat/data/crime.dta") summary(cdata)</strong>
>         sid          state               crime          murder
>     Min.   : 1.0   Length:51          Min.   :  82   Min.   : 1.60
>     1st Qu.:13.5   Class :character   1st Qu.: 326   1st Qu.: 3.90
>     Median :26.0   Mode  :character   Median : 515   Median : 6.80
>     Mean   :26.0                      Mean   : 613   Mean   : 8.73
>     3rd Qu.:38.5                      3rd Qu.: 773   3rd Qu.:10.35
>     Max.   :51.0                      Max.   :2922   Max.   :78.50
>        pctmetro        pctwhite        pcths         poverty         single
>     Min.   : 24.0   Min.   :31.8   Min.   :64.3   Min.   : 8.0   Min.   : 8.4
>     1st Qu.: 49.5   1st Qu.:79.4   1st Qu.:73.5   1st Qu.:10.7   1st Qu.:10.1
>     Median : 69.8   Median :87.6   Median :76.7   Median :13.1   Median :10.9
>     Mean   : 67.4   Mean   :84.1   Mean   :76.2   Mean   :14.3   Mean   :11.3
>     3rd Qu.: 84.0   3rd Qu.:92.6   3rd Qu.:80.1   3rd Qu.:17.4   3rd Qu.:12.1
>     Max.   :100.0   Max.   :98.5   Max.   :86.6   Max.   :26.4   Max.   :22.1
> 
> 





#### 稳健回归


先对数据进行OLS回归，重点观察回归结果中的残差、拟合值、Cook距离和杠杆率。


> 

>     
>     <strong>ols <- lm(crime ~ poverty + single, data = cdata) summary(ols)</strong>
>     
>     Call:
>     lm(formula = crime ~ poverty + single, data = cdata)
>     
>     Residuals:
>        Min     1Q Median     3Q    Max
>     -811.1 -114.3  -22.4  121.9  689.8 
>     
>     Coefficients:
>                 Estimate Std. Error t value Pr(>|t|)
>     (Intercept) -1368.19     187.21   -7.31  2.5e-09 ***
>     poverty         6.79       8.99    0.76     0.45
>     single        166.37      19.42    8.57  3.1e-11 ***
>     ---
>     Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 
>     
>     Residual standard error: 244 on 48 degrees of freedom
>     Multiple R-squared: 0.707,	Adjusted R-squared: 0.695
>     F-statistic:   58 on 2 and 48 DF,  p-value: 1.58e-13
>     <strong>opar <- par(mfrow = c(2,2),oma = c(0, 0, 1.1, 0)) plot(ols, las = 1) par(opar) <img src="http://www.ats.ucla.edu/stat/R/dae/rreg.png" alt="" height="606" class="alignleft" width="834"></img> </strong>
> 
> 



从图上看出，第 9, 第25和第5个观测值可能是离群点，看看这些观测值所属的是哪些州。


> 

>     
>     <strong>cdata[c(9, 25, 51), 1:2]</strong>
>        sid state
>     9    9    fl
>     25  25    ms
>     51  51    dc
> 
> 



可以猜测，DC, Florida 和Mississippi这三个地方所对应的观测值可能具有较大的残差或者杠杆率。下面观察一下Cook距离较大的观测值有哪些。在判断Cook距离大小的时候，通常采用过的经验分界点是Cook距离序列的4/n处，其中n是观测值的个数。


> 

>     
>     <strong>library(MASS) d1 <- cooks.distance(ols) r <- stdres(ols) a <- cbind(cdata, d1, r) a[d1 > 4/51, ]</strong>
>     
>        sid state crime murder pctmetro pctwhite pcths poverty single     d1      r
>     1    1    ak   761    9.0     41.8     75.2  86.6     9.1   14.3 0.1255 -1.397
>     9    9    fl  1206    8.9     93.0     83.5  74.4    17.8   10.6 0.1426  2.903
>     25  25    ms   434   13.5     30.7     63.3  64.3    24.7   14.7 0.6139 -3.563
>     51  51    dc  2922   78.5    100.0     31.8  73.1    26.4   22.1 2.6363  2.616
> 
> 



本来应当先删除DC所对应的观测值，因为DC对应的并不是州。然而，由于DC所对应的Cook距离较大保留DC有助于我们进行观察。下面生成一个**absr1**变量, 其对应的为残差序列的绝对值，取出残差绝对值较大的观测值：


> 

>     
>     <strong>rabs <- abs(r) a <- cbind(cdata, d1, r, rabs) asorted <- a[order(-rabs), ] asorted[1:10, ]</strong>
>     
>        sid state crime murder pctmetro pctwhite pcths poverty single      d1      r  rabs
>     25  25    ms   434   13.5     30.7     63.3  64.3    24.7   14.7 0.61387 -3.563 3.563
>     9    9    fl  1206    8.9     93.0     83.5  74.4    17.8   10.6 0.14259  2.903 2.903
>     51  51    dc  2922   78.5    100.0     31.8  73.1    26.4   22.1 2.63625  2.616 2.616
>     46  46    vt   114    3.6     27.0     98.4  80.8    10.0   11.0 0.04272 -1.742 1.742
>     26  26    mt   178    3.0     24.0     92.6  81.0    14.9   10.8 0.01676 -1.461 1.461
>     21  21    me   126    1.6     35.7     98.5  78.8    10.7   10.6 0.02233 -1.427 1.427
>     1    1    ak   761    9.0     41.8     75.2  86.6     9.1   14.3 0.12548 -1.397 1.397
>     31  31    nj   627    5.3    100.0     80.8  76.7    10.9    9.6 0.02229  1.354 1.354
>     14  14    il   960   11.4     84.0     81.0  76.2    13.6   11.5 0.01266  1.338 1.338
>     20  20    md   998   12.7     92.8     68.9  78.4     9.7   12.0 0.03570  1.287 1.287
> 
> 



现在转向稳健回归。再提示一下，稳健回归是通过迭代重复加权最小二乘（iterated re-weighted least squares ，IRLS)来完成的。其对应的R函数是**MASS**包中的**rlm**。IRLS对应的有多个权重函数（ weighting functions），首先演示一下Huber方法。 演示过程中，重点关注IRLS过程得出的权重结果。


> 

>     
>     <strong>rr.huber <- rlm(crime ~ poverty + single, data = cdata) summary(rr.huber)</strong>
>     
>     Call: rlm(formula = crime ~ poverty + single, data = cdata)
>     Residuals:
>        Min     1Q Median     3Q    Max
>     -846.1 -125.8  -16.5  119.2  679.9 
>     
>     Coefficients:
>                 Value     Std. Error t value
>     (Intercept) -1423.037   167.590     -8.491
>     poverty         8.868     8.047      1.102
>     single        168.986    17.388      9.719
>     
>     Residual standard error: 182 on 48 degrees of freedom
>     <strong> hweights <- data.frame(state = cdata$state, resid = rr.huber$resid, weight = rr.huber$w) hweights2 <- hweights[order(rr.huber$w), ] hweights2[1:15, ]</strong>
>     
>        state   resid weight
>     25    ms -846.09 0.2890
>     9     fl  679.94 0.3595
>     46    vt -410.48 0.5956
>     51    dc  376.34 0.6494
>     26    mt -356.14 0.6865
>     21    me -337.10 0.7252
>     31    nj  331.12 0.7384
>     14    il  319.10 0.7661
>     1     ak -313.16 0.7807
>     20    md  307.19 0.7958
>     19    ma  291.21 0.8395
>     18    la -266.96 0.9159
>     2     al  105.40 1.0000
>     3     ar   30.54 1.0000
>     4     az  -43.25 1.0000
> 
> 



容易看出来，观测值的残差绝对值越大，其被赋予的权重越小。结果表明Mississippi所对应的观测值被赋予的权重是最小的，其次是Florida所对应的观测值，而所有未被展示的观测值的权重皆为1。由于OLS回归中所有观测值的权重都为1，因此，稳健回归中权重为1的观测值越多，则稳健回归于OLS回归的分析结果越相近。

接下来，用bisquare方法来进行稳健回归过程。


> 

>     
>     <strong>rr.bisquare <- rlm(crime ~ poverty + single, data=cdata, psi = psi.bisquare) summary(rr.bisquare)</strong>
>     
>     Call: rlm(formula = crime ~ poverty + single, data = cdata, psi = psi.bisquare)
>     Residuals:
>        Min     1Q Median     3Q    Max
>       -906   -141    -15    115    668 
>     
>     Coefficients:
>                 Value     Std. Error t value
>     (Intercept) -1535.334   164.506     -9.333
>     poverty        11.690     7.899      1.480
>     single        175.930    17.068     10.308
>     
>     Residual standard error: 202 on 48 degrees of freedom<strong> biweights <- data.frame(state = cdata$state, resid = rr.bisquare$resid, weight = rr.bisquare$w) biweights2 <- biweights[order(rr.bisquare$w), ] biweights2[1:15, ]</strong>
>     
>        state  resid   weight
>     25    ms -905.6 0.007653
>     9     fl  668.4 0.252871
>     46    vt -402.8 0.671495
>     26    mt -360.9 0.731137
>     31    nj  346.0 0.751348
>     18    la -332.7 0.768938
>     21    me -328.6 0.774103
>     1     ak -325.9 0.777662
>     14    il  313.1 0.793659
>     20    md  308.8 0.799066
>     19    ma  297.6 0.812597
>     51    dc  260.6 0.854442
>     50    wy -234.2 0.881661
>     5     ca  201.4 0.911714
>     10    ga -186.6 0.924033
> 
> 



与Huber方法相比，bisquare方法下的 Mississippi观测值被赋予了极小的权重，并且两种方法估计出的回归参数也相差甚大。通常，当稳健回归跟OLS回归的分析结果相差较大时，数据分析者采用稳健回归较为明智。稳健回归和OLS回归的分析结果的较大差异通常暗示着离群点对模型参数产生了较大影响。所有的方法都有长处和软肋，稳健回归也不例外。稳健回归中，Huber方法的软肋在于无法很好的而处理极端离群点，而bisquare方法的软肋在于回归结果不易收敛，以至于经常有多个最优解。

除此之外，两种方法得出的参数结果极为不同，尤其是**single**变量的系数和截距项(**intercept**)。不过，一般而言无需关注截距项，除非事先已经对预测变量进行了中心化，此时截距项才显的有些用处。再有， 变量** poverty**的系数在两种方法下都不显著，而变量 **single**则刚好相反，都较为显著。


#### 思考：





	
  * 稳健回归没有解决OLS回归中的异方差问题，有关这一问题可以参见**sandwich**包中的 **lm**函数。

	
  * 这里展示的只是在**R**实现M估计的一种方法，读者尚可以在**rlm**中发现更多方法，比如MM等。此外，**robustbase**包中**ltsReg**可以用来实现最小截平方（ Least trimmed squares）。




#### 参考资料：





	
  * Li, G. 1985. _ Robust regression_. In _Exploring Data Tables, Trends, and Shapes_, ed. D. C. Hoaglin, F. Mosteller, and J. W. Tukey, Wiley.

	
  * John Fox, _ Applied regression analysis, linear models, and related models_, Sage publications, Inc, 1997




#### 更多内容：





	
  * [ R documentation for **rlm**](http://stat.ethz.ch/R-manual/R-patched/library/MASS/html/rlm.html)




#### 本文翻译自：[http://www.ats.ucla.edu/stat/R/dae/rreg.htm](http://www.ats.ucla.edu/stat/R/dae/rreg.htm)
