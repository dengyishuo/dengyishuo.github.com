---
comments: true
layout: post
title: 13.1 蒙特卡洛模拟
wordpress_id: 846
categories:
- R语言
tags:
- r
- 模拟
- 蒙特卡洛
---

首先，生成25个服从正态分布的随机数组成的一个向量，命名为x.按照下列公式生成y
y=2+3x+\epsilon 

y对x做回归，把斜率系数存在事先生成的空数组A中。将上述过程重复500次。计算这500个斜率系数的均值和方差。系数估计量的理论方差与模拟的方差相比较。
[code]
>A <- array(0, dim=c(500,1))
>x <- rnorm(25,mean=2,sd=1)
>for(i in 1:500){
+ y <- rnorm(25, mean=(3*x+2), sd=1)
+ beta <- lm(y~x)
+ A[i] <- beta$coef[2]
+ }
>Abar <- mean(A)
>varA <- var(A)
[/code] 
