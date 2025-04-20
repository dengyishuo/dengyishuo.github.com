---
layout: post
title: 用R拟合缺项的ARIMA模型
comments: true
categories:
- econometrics
tags:
- ARIMA
- ARMA
- 缺项
---

标准的ARMA（p,q）模型是这样的：
[latex]X_t=a_1X_{t-1}+\ldots+a_pX_{t-p}+\epsilon_t+b_1\epsilon_{t-1}+\ldots+b_q\epsilon_{t-q}[/latex]
比如ARMA(3,2)：
[latex]X_t=a_1X_{t-1}+a_2X_{t-2}+a_3X_{t-3}+\epsilon_t+b_1\epsilon_{t-1}+b_2\epsilon_{t-2}[/latex]
拟合ARMA（3,2）模型的R代码如下：
`
> arima(lh, order = c(3,0,2))

Call:
arima(x = lh, order = c(3, 0, 2))

Coefficients:
         ar1     ar2      ar3     ma1      ma2  intercept
      0.0402  0.4567  -0.4164  0.6602  -0.1109     2.3911
s.e.  0.3952  0.2032   0.2310  0.4403   0.3977     0.1010

sigma^2 estimated as 0.1711:  log likelihood = -26.2,  aic = 66.4
`
代码很了然吧，order=c(3,0,2)中的3便是模型中的p,2是模型中的q。中间的0是序列X在建立ARMA模型前的差分次数。

有时候，我们不需要拟合完整的ARMA模型。比如要拟合的模型如下：
[latex]X_t=a_1X_{t-1}+a_3X_{t-3}+\epsilon_t+b_1\epsilon_{t-1}+b_2\epsilon_{t-2}[/latex]
虽然模型的最高阶依然是（3,2）可是AR项里面缺少了第二项。
其实，这个问题解决起来很简单的。分3步：
1.观察完整的ARMA模型有几个参数，上例中共有6个参数。
2.观察缺失项的参数在原模型参数中的位置，上例中缺失项是6个参数中的第2个参数。
3.在arima()函数中，加入fixed=c(NA,0,NA,NA,NA,NA),transform.pars = FALSE。上例中的R代码如下：
`
> arima(lh, order = c(3,0,2),fixed=c(NA,0,NA,NA,NA,NA),transform.pars = FALSE)

Call:
arima(x = lh, order = c(3, 0, 2), transform.pars = FALSE, fixed = c(NA, 0, NA, 
    NA, NA, NA))

Coefficients:
         ar1  ar2      ar3     ma1     ma2  intercept
      0.4367    0  -0.2255  0.2294  0.0742     2.3935
s.e.  0.4278    0   0.1560  0.4537  0.2919     0.1008

sigma^2 estimated as 0.1776:  log likelihood = -26.97,  aic = 65.93
`
arima()中fixed=c(NA,0,NA,NA,NA,NA)的长度为6，与不缺项的ARMA（3,2）模型的参数个数相同。第二个参数为0，意思是把6个参数中的第二个参数固定为0。transform.pars = FALSE是一个辅助项。

当然了，如果你愿意，也可以将参数固定为其它数值，比如0.5,0.6之类的，这些都无伤大雅。
