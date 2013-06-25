---
author: admin
comments: true
date: 2011-11-28 21:45:18
layout: post
slug: 3d-graph-of-hcpc-in-r
title: R中的3维HCPC图
wordpress_id: 891
categories:
- R&amp;数据艺术
tags:
- 3D
- r
- 主成分
- 聚类
- 谱系图
---

第四届R会议上，余苓提到了一个叫FactoMineR的包，这个包提供了一个可以绘制立体谱系图的函数plot.HCPC()，因为之前有人在COS问过这个问题，所以我就特别留意了一下。
![](http://ww2.sinaimg.cn/bmiddle/644c05aetw1dnjxoq5y56j.jpg)
上图的R代码是：
[code]
library(FactoMineR)  #载入包
data(iris)        #载入数据
res.hcpc=HCPC(iris[1:4], nb.clust=3)   #基于PC的聚类
plot.HCPC(res.hcpc, choice="3D.map", angle=60)   #3D谱系图
[/code]
但是，这个图不够好，因为这个图缺少该有的交互性。等我有时间了，我会用rgl包重新写一个具有交互功能的立体谱系图。
