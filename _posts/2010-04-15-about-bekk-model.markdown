---
author: admin
comments: true
date: 2010-04-15 13:47:26
layout: post
slug: about-bekk-model
title: 关于BEKK模型
wordpress_id: 324
categories:
- R语言
tags:
- BEKK
- mgarch
- 多元garch模型
---

BEKK模型是目前比较流行的多变量波动性模型，可以看做是GARCH模型在多维空间的实现。BEKK模型在应用过程中也有诸多缺点，其中最大的一个不足之处在于，模型的待估计参数会随着模型维数的增加指数型增长。然而，这一点肯定会随着计算机的发展而被逐渐克服的。R软件中提供了mgarch和mgarchBEKK两个Pkg来帮忙估计BEKK模型参数。

注：
1.材料：[BEKK模型的理论推导](http://fedc.wiwi.hu-berlin.de/xplore/tutorials/sfehtmlnode68.html)
2.下载：[mgarchBEKK_0.07-8.zip](http://yishuo.cos.name/wp-content/uploads/2010/04/mgarchBEKK_0.07-81.zip)
3.下载：[mgarch_0.00-1.zip](http://yishuo.cos.name/wp-content/uploads/2010/04/mgarch_0.00-1.zip)
