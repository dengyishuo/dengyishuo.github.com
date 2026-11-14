---
title: 符号偏误检验
author: MatrixSpk
date: '2011-05-02'
slug: use-r-to-do-sign-bias-test
categories:
- econometrics
tags:
- Joint Test
- JT
- Negative Sign Bias Test
- NSBT
- Positive Sign Bias Test
- PSBT
- SBT
- Sign Bias Test
- 正符号偏误检验
- 符号偏误检验
- 联合检验
- 负符号偏误检验
---

Engle和Ng（1993）提出了四种检验条件方差对称性的方法，分别是：

1.符号偏误检验（Sign Bias Test）

$$
\epsilon_t=a_1+b_1S_{t-1}^{-}+Z_{1t}
$$

2.负符号偏误检验(Negative Sign Bias Test)

$$
\epsilon_t=a_2+b_2S_{t-1}^{-}\epsilon_{t-1}+Z_{2t}
$$

3.正符号偏误检验（Positive Sign Bias Test）

$$
\epsilon_t=a_3+b_3S_{t-1}^{+}\epsilon_{t-1}+Z_{3t}
$$
其中： `\(S_{t-1}^{-}\)` 为虚拟变量，当 `\(\epsilon_{t-1}<0\)` 时， `\(S_{t-1}^{-}=1\)` ，否则为0。 `\(S_{t-1}^{+}=1-S_{t-1}^{-}\)` ，Z为残差。

4.联合检验（Joint Test）

$$
\epsilon_t=c_0+c_1S_{t-1}^{-}+c_2S_{t-1}^{-}\epsilon_{t-1}+c_3S_{t-1}^{+}\epsilon_{t-1}+Z_t
$$
联合检验的统计量服从自由度为3的卡方分布。

在实践中，可以直接用R软件进行符号偏误检验：


``` r
library(rgarch)
data(dmbp)             #载入数据
spec = ugarchspec()    #设定模型为默认
fit = ugarchfit(data = dmbp[,1], spec = spec)   # 拟合模型
signbias(fit)                                   # 提取符号偏误检验结果
```

检验结果如下：

```
                      t-value      prob sig
Sign Bias          1.50254937 0.1331156    
Negative Sign Bias 0.02483478 0.9801893    
Positive Sign Bias 0.79126111 0.4288869    
Joint Effect       3.07511135 0.3801888  
```
