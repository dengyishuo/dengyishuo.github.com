---
title: R中的3维HCPC图
author: MatrixSpk
date: '2011-11-28'
slug: 3d-graph-of-hcpc-in-r
categories:
- R
tags:
- 3D
- r
- 主成分
- 聚类
- 谱系图
---
第四届R会议上，余苓提到了一个叫FactoMineR的包，这个包提供了一个可以绘制立体谱系图的函数plot.HCPC()。我记得之前有人在COS论坛上问过这个问题，我就特别留意了一下这个函数。

它的用法如下：



``` r
# 安装包,如果未安装
# install.packages("FactoMineR")
library(FactoMineR)  #加载包
data(iris)           #加载数据
res.hcpc <- HCPC(iris[1:4], nb.clust=3)   #基于PC的聚类
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-1-1.png" width="672" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-1-2.png" width="672" /><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-1-3.png" width="672" />

``` r
plot.HCPC(res.hcpc, choice="3D.map", angle=60)   #3D谱系图
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-1-4.png" width="672" />

但是，这个图不够好，因为这个图缺少该有的交互性。等我有时间了，我会用rgl包重新写一个具有交互功能的立体谱系图。
