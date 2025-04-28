---
title: 脸谱图
author: MatrixSpk
date: '2010-03-20'
slug: 'chernoff'
categories:
  - datavisualization
tags: [visualization]
---
出于一种特殊的审美原因，我一直都很欣赏Chernoff创造的脸谱图。它让我感觉到了统计学家的浪漫，让我摆脱了对统计学家严谨、保守的刻板印象。

脸谱图工作原理极其简单，它用人类的脸部特征来刻画多维变量，与雷达图等在本质上并无太大不同。只不过，它带着人类的五官出现，是一种显得可爱又好玩的针对多元数据的可视化方法，可能十分适合用来激发人们对多元数据可视化的兴趣。

一般的Chernoff脸谱图是这样的:


``` r
library(aplpack)
faces(rnorm(5),face.type=0)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-1-1.png" width="672" />

```
## effect of variables:
##  modified item       Var   
##  "height of face   " "Var1"
##  "width of face    " "Var2"
##  "structure of face" "Var3"
##  "height of mouth  " "Var4"
##  "width of mouth   " "Var5"
##  "smiling          " "Var1"
##  "height of eyes   " "Var2"
##  "width of eyes    " "Var3"
##  "height of hair   " "Var4"
##  "width of hair   "  "Var5"
##  "style of hair   "  "Var1"
##  "height of nose  "  "Var2"
##  "width of nose   "  "Var3"
##  "width of ear    "  "Var4"
##  "height of ear   "  "Var5"
```

上图使用的是随机数据，可能看起来比较呆板。我们当然可以画一个更好看的：


``` r
faces(rnorm(5),face.type=1)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" />

```
## effect of variables:
##  modified item       Var   
##  "height of face   " "Var1"
##  "width of face    " "Var2"
##  "structure of face" "Var3"
##  "height of mouth  " "Var4"
##  "width of mouth   " "Var5"
##  "smiling          " "Var1"
##  "height of eyes   " "Var2"
##  "width of eyes    " "Var3"
##  "height of hair   " "Var4"
##  "width of hair   "  "Var5"
##  "style of hair   "  "Var1"
##  "height of nose  "  "Var2"
##  "width of nose   "  "Var3"
##  "width of ear    "  "Var4"
##  "height of ear   "  "Var5"
```

我比较喜欢圣诞老人这个版本：


``` r
faces(rnorm(5),face.type=2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```
## effect of variables:
##  modified item       Var   
##  "height of face   " "Var1"
##  "width of face    " "Var2"
##  "structure of face" "Var3"
##  "height of mouth  " "Var4"
##  "width of mouth   " "Var5"
##  "smiling          " "Var1"
##  "height of eyes   " "Var2"
##  "width of eyes    " "Var3"
##  "height of hair   " "Var4"
##  "width of hair   "  "Var5"
##  "style of hair   "  "Var1"
##  "height of nose  "  "Var2"
##  "width of nose   "  "Var3"
##  "width of ear    "  "Var4"
##  "height of ear   "  "Var5"
```
