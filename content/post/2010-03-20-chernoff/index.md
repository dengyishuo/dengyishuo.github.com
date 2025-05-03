---
title: 脸谱图
author: MatrixSpk
date: '2010-03-20'
slug: chernoff
categories:
  - datavis
tags:
  - data
  - vis
---

<link href="{{< blogdown/postref >}}index_files/htmltools-fill/fill.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>
<script src="{{< blogdown/postref >}}index_files/d3/d3.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/sankey/sankey.js"></script>
<script src="{{< blogdown/postref >}}index_files/sankeyNetwork-binding/sankeyNetwork.js"></script>
<link href="{{< blogdown/postref >}}index_files/htmltools-fill/fill.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>
<script src="{{< blogdown/postref >}}index_files/plotly-binding/plotly.js"></script>
<script src="{{< blogdown/postref >}}index_files/typedarray/typedarray.min.js"></script>
<script src="{{< blogdown/postref >}}index_files/jquery/jquery.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/crosstalk/js/crosstalk.min.js"></script>
<link href="{{< blogdown/postref >}}index_files/plotly-htmlwidgets-css/plotly-htmlwidgets.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/plotly-main/plotly-latest.min.js"></script>

# 脸谱图

出于一种个体的审美原因，我一直都很欣赏Chernoff创造的脸谱图。它让我感觉到了统计学家的浪漫，让我摆脱了对统计学家严谨、保守的刻板印象。

脸谱图工作原理极其简单，它用人类的脸部特征来刻画多维变量，与雷达图、平行坐标图等在本质上并无太大不同。只不过，它带着人类的五官出现，是一种显得可爱又好玩的针对多元数据的可视化方法，可能十分适合用来激发人们对多元数据可视化的兴趣。

一般的Chernoff脸谱图是这样的，以R中自带的鸢尾花数据集（iris）为例:

``` r
library(aplpack)
faces(iris[1:20,1:4],face.type=0)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-1-1.png" width="672" />

    ## effect of variables:
    ##  modified item       Var           
    ##  "height of face   " "Sepal.Length"
    ##  "width of face    " "Sepal.Width" 
    ##  "structure of face" "Petal.Length"
    ##  "height of mouth  " "Petal.Width" 
    ##  "width of mouth   " "Sepal.Length"
    ##  "smiling          " "Sepal.Width" 
    ##  "height of eyes   " "Petal.Length"
    ##  "width of eyes    " "Petal.Width" 
    ##  "height of hair   " "Sepal.Length"
    ##  "width of hair   "  "Sepal.Width" 
    ##  "style of hair   "  "Petal.Length"
    ##  "height of nose  "  "Petal.Width" 
    ##  "width of nose   "  "Sepal.Length"
    ##  "width of ear    "  "Sepal.Width" 
    ##  "height of ear   "  "Petal.Length"

上图可能看起来比较呆板。我们当然可以画一个更好看的：

``` r
faces(iris[1:20,1:4],face.type=1)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" />

    ## effect of variables:
    ##  modified item       Var           
    ##  "height of face   " "Sepal.Length"
    ##  "width of face    " "Sepal.Width" 
    ##  "structure of face" "Petal.Length"
    ##  "height of mouth  " "Petal.Width" 
    ##  "width of mouth   " "Sepal.Length"
    ##  "smiling          " "Sepal.Width" 
    ##  "height of eyes   " "Petal.Length"
    ##  "width of eyes    " "Petal.Width" 
    ##  "height of hair   " "Sepal.Length"
    ##  "width of hair   "  "Sepal.Width" 
    ##  "style of hair   "  "Petal.Length"
    ##  "height of nose  "  "Petal.Width" 
    ##  "width of nose   "  "Sepal.Length"
    ##  "width of ear    "  "Sepal.Width" 
    ##  "height of ear   "  "Petal.Length"

我比较喜欢圣诞老人这个版本：

``` r
faces(iris[1:20,1:4],face.type=2)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />

    ## effect of variables:
    ##  modified item       Var           
    ##  "height of face   " "Sepal.Length"
    ##  "width of face    " "Sepal.Width" 
    ##  "structure of face" "Petal.Length"
    ##  "height of mouth  " "Petal.Width" 
    ##  "width of mouth   " "Sepal.Length"
    ##  "smiling          " "Sepal.Width" 
    ##  "height of eyes   " "Petal.Length"
    ##  "width of eyes    " "Petal.Width" 
    ##  "height of hair   " "Sepal.Length"
    ##  "width of hair   "  "Sepal.Width" 
    ##  "style of hair   "  "Petal.Length"
    ##  "height of nose  "  "Petal.Width" 
    ##  "width of nose   "  "Sepal.Length"
    ##  "width of ear    "  "Sepal.Width" 
    ##  "height of ear   "  "Petal.Length"

# 主流多元数据可视化方法

虽然脸谱图看起来好玩儿有趣，但真正在业界落地数据可视化时，它并不太实用。业界有很多更加实用的多元数据可视化方法值得学习。这些方法大致可以分为以下几类：

## 基于几何的交互式方法

这类方法主要包括常用的散点图矩阵、平行坐标图和雷达图。

### 散点图矩阵

散点图以网格形式展示多个二维散点图，可以直观反映变量间的两两关系。适合探索变量之间的相关性，且可以通过颜色/符号增强信息表达的力度。

看一个例子：

``` r
# 加载包
library(GGally)
```

    ## 载入需要的程序包：ggplot2

    ## Registered S3 method overwritten by 'GGally':
    ##   method from   
    ##   +.gg   ggplot2

``` r
# 绘制散点图矩阵（含密度图和相关系数）
ggpairs(iris, columns = 1:4, 
        mapping = aes(color = Species),  # 按类别着色
        upper = list(continuous = "cor"), 
        lower = list(continuous = "smooth"))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672" />

散点图矩阵的缺点也很突出，当变量很多时，图形阅读难度会大幅提升。

### 平行坐标图

通过平行排列的坐标轴进行多维数据可视化，图上以折线连接各变量值。它的优点是清晰呈现高维数据中的聚类、趋势和异常值。缺点是高维数据易导致线条重叠，需结合交互操作优。

上一个例子:

``` r
library(GGally)

# 绘制平行坐标图（标准化处理）
ggparcoord(iris, columns = 1:4, groupColumn = 5, 
           scale = "uniminmax",  # 标准化到[0,1]
           alphaLines = 0.5) + 
  theme_minimal()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" />

### 雷达图

雷达图在工业界和商业界应用广泛，它是以多边形闭合图形展示多维数据，用顶点代表变量值。雷达图适合多指标对比（如产品性能评估），缺点是数据差异较大时图形易失真。

``` r
# 安装包（如未安装）
# devtools::install_github("ricardo-bion/ggradar")

library(ggradar)
library(dplyr)
```

    ## 
    ## 载入程序包：'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
# 数据预处理（计算各物种均值）
iris_radar <- iris %>%
  group_by(Species) %>%
  summarise(across(1:4, mean)) 

# 绘制雷达图
ggradar(iris_radar, grid.min = 0, grid.max = 8)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="672" />

## 基于像素的密度表现方法

主要包括热力图和像素图。

### 热力图

热力图以色块颜色深浅表示数值大小或分布密度。常用于展示数据矩阵的关联模式（如用户行为聚类）等。

``` r
library(ggplot2)
library(reshape2)

# 数据长格式转换
iris_melt <- melt(iris[,1:4])
```

    ## No id variables; using all as measure variables

``` r
# 绘制热力图（数值分布）
ggplot(iris_melt, aes(x = variable, y = value)) +
  geom_bin2d(bins = 20) +  # 二维密度统计
  scale_fill_viridis_c()    # 颜色渐变
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />

### 像素图

像素图将数据映射为像素的颜色或亮度属性。适合大规模数据的高效呈现。

## 降维和空间映射方法

主要包括主成分分析方法、t-SNE与UMAP方法及气泡图。

### 主成分分析（PCA）

PCA的思想是将高维数据投影到低维空间，保留主要方差信息，再在低维空间对数据进行可视化。

``` r
# PCA分析
pca <- prcomp(iris[,1:4], scale = TRUE)
pca_scores <- data.frame(pca$x, Species = iris$Species)

# 绘制PCA二维投影
ggplot(pca_scores, aes(x = PC1, y = PC2, color = Species)) +
  geom_point(size = 3) +
  stat_ellipse(level = 0.95) +  # 添加置信椭圆
  labs(x = "PC1 (73%)", y = "PC2 (22%)")  # 方差解释率
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

### t-SNE与UMAP方法

这两种方法都是非线性降维方法，更擅长保留局部结构和聚类特征。

``` r
# t-SNE
library(Rtsne)
set.seed(123)
iris <- unique(iris)
tsne <- Rtsne(unique(iris[,1:4]), perplexity = 30)
tsne_df <- data.frame(TSNE1 = tsne$Y[,1], TSNE2 = tsne$Y[,2], Species = iris$Species)

# UMAP
library(umap)
umap_res <- umap(iris[,1:4])
umap_df <- data.frame(UMAP1 = umap_res$layout[,1], UMAP2 = umap_res$layout[,2], Species = iris$Species)

# 可视化对比
library(patchwork)
p1 <- ggplot(tsne_df, aes(TSNE1, TSNE2, color = Species)) + geom_point()
p2 <- ggplot(umap_df, aes(UMAP1, UMAP2, color = Species)) + geom_point()
p1 + p2  # 并排显示
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" width="672" />

### 气泡图

``` r
library(ggplot2)
ggplot(mtcars, aes(x = wt, y = mpg, size = hp, color = factor(cyl))) + 
  geom_point(alpha = 0.7) + 
  scale_size(range = c(3, 15)) +  # 调整气泡尺寸范围
  labs(x = "车重", y = "油耗", color = "气缸数", size = "马力")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-1.png" width="672" />

气泡图可以和热图相结合。

``` r
library(reshape2)
data_melt <- melt(cor(mtcars))  # 数据长格式转换

ggplot(data_melt, aes(Var1, Var2, size = abs(value), color = value)) +
  geom_point() +
  scale_color_gradient2(low = "blue", mid = "white", high = "red") +  # 渐变色
  theme_minimal()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" width="672" />

## 其他方法

主要包括桑基图、三维散点图和表格透镜

### 桑基图

这是一个垂直领域的多元数据可视化的方法，它可以展示流量或资源在多节点间的流转路径（如用户转化漏斗）。

``` r
# 安装包（如未安装）
# devtools::install_github("https://github.com/christophergandrud/networkD3")
library(networkD3)

# 构造示例数据（模拟物种间转化）
nodes <- data.frame(name = c("Setosa", "Versicolor", "Virginica"))
links <- data.frame(source = c(0,1,2), target = c(1,2,0), value = c(10,20,15))

# 绘制桑基图
sankeyNetwork(Links = links, Nodes = nodes, 
              Source = "source", Target = "target",
              Value = "value", NodeID = "name")
```

<div class="sankeyNetwork html-widget html-fill-item" id="htmlwidget-1" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"links":{"source":[0,1,2],"target":[1,2,0],"value":[10,20,15]},"nodes":{"name":["Setosa","Versicolor","Virginica"],"group":["Setosa","Versicolor","Virginica"]},"options":{"NodeID":"name","NodeGroup":"name","LinkGroup":null,"colourScale":"d3.scaleOrdinal(d3.schemeCategory20);","fontSize":7,"fontFamily":null,"nodeWidth":15,"nodePadding":10,"units":"","margin":{"top":null,"right":null,"bottom":null,"left":null},"iterations":32,"sinksRight":true}},"evals":[],"jsHooks":[]}</script>

### 三维散点图

通过三维空间扩展，直观呈现三个变量间的关系。

``` r
library(plotly)
```

    ## 
    ## 载入程序包：'plotly'

    ## The following object is masked from 'package:ggplot2':
    ## 
    ##     last_plot

    ## The following object is masked from 'package:stats':
    ## 
    ##     filter

    ## The following object is masked from 'package:graphics':
    ## 
    ##     layout

``` r
# 交互式三维散点图
plot_ly(iris, x = ~Sepal.Length, y = ~Sepal.Width, z = ~Petal.Length,
        color = ~Species, type = "scatter3d", mode = "markers")
```

<div class="plotly html-widget html-fill-item" id="htmlwidget-2" style="width:672px;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-2">{"x":{"visdat":{"d4b7bd0e4e3":["function () ","plotlyVisDat"]},"cur_data":"d4b7bd0e4e3","attrs":{"d4b7bd0e4e3":{"x":{},"y":{},"z":{},"mode":"markers","color":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":"Sepal.Length"},"yaxis":{"title":"Sepal.Width"},"zaxis":{"title":"Petal.Length"}},"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[5.0999999999999996,4.9000000000000004,4.7000000000000002,4.5999999999999996,5,5.4000000000000004,4.5999999999999996,5,4.4000000000000004,4.9000000000000004,5.4000000000000004,4.7999999999999998,4.7999999999999998,4.2999999999999998,5.7999999999999998,5.7000000000000002,5.4000000000000004,5.0999999999999996,5.7000000000000002,5.0999999999999996,5.4000000000000004,5.0999999999999996,4.5999999999999996,5.0999999999999996,4.7999999999999998,5,5,5.2000000000000002,5.2000000000000002,4.7000000000000002,4.7999999999999998,5.4000000000000004,5.2000000000000002,5.5,4.9000000000000004,5,5.5,4.9000000000000004,4.4000000000000004,5.0999999999999996,5,4.5,4.4000000000000004,5,5.0999999999999996,4.7999999999999998,5.0999999999999996,4.5999999999999996,5.2999999999999998,5],"y":[3.5,3,3.2000000000000002,3.1000000000000001,3.6000000000000001,3.8999999999999999,3.3999999999999999,3.3999999999999999,2.8999999999999999,3.1000000000000001,3.7000000000000002,3.3999999999999999,3,3,4,4.4000000000000004,3.8999999999999999,3.5,3.7999999999999998,3.7999999999999998,3.3999999999999999,3.7000000000000002,3.6000000000000001,3.2999999999999998,3.3999999999999999,3,3.3999999999999999,3.5,3.3999999999999999,3.2000000000000002,3.1000000000000001,3.3999999999999999,4.0999999999999996,4.2000000000000002,3.1000000000000001,3.2000000000000002,3.5,3.6000000000000001,3,3.3999999999999999,3.5,2.2999999999999998,3.2000000000000002,3.5,3.7999999999999998,3,3.7999999999999998,3.2000000000000002,3.7000000000000002,3.2999999999999998],"z":[1.3999999999999999,1.3999999999999999,1.3,1.5,1.3999999999999999,1.7,1.3999999999999999,1.5,1.3999999999999999,1.5,1.5,1.6000000000000001,1.3999999999999999,1.1000000000000001,1.2,1.5,1.3,1.3999999999999999,1.7,1.5,1.7,1.5,1,1.7,1.8999999999999999,1.6000000000000001,1.6000000000000001,1.5,1.3999999999999999,1.6000000000000001,1.6000000000000001,1.5,1.5,1.3999999999999999,1.5,1.2,1.3,1.3999999999999999,1.3,1.5,1.3,1.3,1.3,1.6000000000000001,1.8999999999999999,1.3999999999999999,1.6000000000000001,1.3999999999999999,1.5,1.3999999999999999],"mode":"markers","type":"scatter3d","name":"setosa","marker":{"color":"rgba(102,194,165,1)","line":{"color":"rgba(102,194,165,1)"}},"textfont":{"color":"rgba(102,194,165,1)"},"error_y":{"color":"rgba(102,194,165,1)"},"error_x":{"color":"rgba(102,194,165,1)"},"line":{"color":"rgba(102,194,165,1)"},"frame":null},{"x":[7,6.4000000000000004,6.9000000000000004,5.5,6.5,5.7000000000000002,6.2999999999999998,4.9000000000000004,6.5999999999999996,5.2000000000000002,5,5.9000000000000004,6,6.0999999999999996,5.5999999999999996,6.7000000000000002,5.5999999999999996,5.7999999999999998,6.2000000000000002,5.5999999999999996,5.9000000000000004,6.0999999999999996,6.2999999999999998,6.0999999999999996,6.4000000000000004,6.5999999999999996,6.7999999999999998,6.7000000000000002,6,5.7000000000000002,5.5,5.5,5.7999999999999998,6,5.4000000000000004,6,6.7000000000000002,6.2999999999999998,5.5999999999999996,5.5,5.5,6.0999999999999996,5.7999999999999998,5,5.5999999999999996,5.7000000000000002,5.7000000000000002,6.2000000000000002,5.0999999999999996,5.7000000000000002],"y":[3.2000000000000002,3.2000000000000002,3.1000000000000001,2.2999999999999998,2.7999999999999998,2.7999999999999998,3.2999999999999998,2.3999999999999999,2.8999999999999999,2.7000000000000002,2,3,2.2000000000000002,2.8999999999999999,2.8999999999999999,3.1000000000000001,3,2.7000000000000002,2.2000000000000002,2.5,3.2000000000000002,2.7999999999999998,2.5,2.7999999999999998,2.8999999999999999,3,2.7999999999999998,3,2.8999999999999999,2.6000000000000001,2.3999999999999999,2.3999999999999999,2.7000000000000002,2.7000000000000002,3,3.3999999999999999,3.1000000000000001,2.2999999999999998,3,2.5,2.6000000000000001,3,2.6000000000000001,2.2999999999999998,2.7000000000000002,3,2.8999999999999999,2.8999999999999999,2.5,2.7999999999999998],"z":[4.7000000000000002,4.5,4.9000000000000004,4,4.5999999999999996,4.5,4.7000000000000002,3.2999999999999998,4.5999999999999996,3.8999999999999999,3.5,4.2000000000000002,4,4.7000000000000002,3.6000000000000001,4.4000000000000004,4.5,4.0999999999999996,4.5,3.8999999999999999,4.7999999999999998,4,4.9000000000000004,4.7000000000000002,4.2999999999999998,4.4000000000000004,4.7999999999999998,5,4.5,3.5,3.7999999999999998,3.7000000000000002,3.8999999999999999,5.0999999999999996,4.5,4.5,4.7000000000000002,4.4000000000000004,4.0999999999999996,4,4.4000000000000004,4.5999999999999996,4,3.2999999999999998,4.2000000000000002,4.2000000000000002,4.2000000000000002,4.2999999999999998,3,4.0999999999999996],"mode":"markers","type":"scatter3d","name":"versicolor","marker":{"color":"rgba(252,141,98,1)","line":{"color":"rgba(252,141,98,1)"}},"textfont":{"color":"rgba(252,141,98,1)"},"error_y":{"color":"rgba(252,141,98,1)"},"error_x":{"color":"rgba(252,141,98,1)"},"line":{"color":"rgba(252,141,98,1)"},"frame":null},{"x":[6.2999999999999998,5.7999999999999998,7.0999999999999996,6.2999999999999998,6.5,7.5999999999999996,4.9000000000000004,7.2999999999999998,6.7000000000000002,7.2000000000000002,6.5,6.4000000000000004,6.7999999999999998,5.7000000000000002,5.7999999999999998,6.4000000000000004,6.5,7.7000000000000002,7.7000000000000002,6,6.9000000000000004,5.5999999999999996,7.7000000000000002,6.2999999999999998,6.7000000000000002,7.2000000000000002,6.2000000000000002,6.0999999999999996,6.4000000000000004,7.2000000000000002,7.4000000000000004,7.9000000000000004,6.4000000000000004,6.2999999999999998,6.0999999999999996,7.7000000000000002,6.2999999999999998,6.4000000000000004,6,6.9000000000000004,6.7000000000000002,6.9000000000000004,6.7999999999999998,6.7000000000000002,6.7000000000000002,6.2999999999999998,6.5,6.2000000000000002,5.9000000000000004],"y":[3.2999999999999998,2.7000000000000002,3,2.8999999999999999,3,3,2.5,2.8999999999999999,2.5,3.6000000000000001,3.2000000000000002,2.7000000000000002,3,2.5,2.7999999999999998,3.2000000000000002,3,3.7999999999999998,2.6000000000000001,2.2000000000000002,3.2000000000000002,2.7999999999999998,2.7999999999999998,2.7000000000000002,3.2999999999999998,3.2000000000000002,2.7999999999999998,3,2.7999999999999998,3,2.7999999999999998,3.7999999999999998,2.7999999999999998,2.7999999999999998,2.6000000000000001,3,3.3999999999999999,3.1000000000000001,3,3.1000000000000001,3.1000000000000001,3.1000000000000001,3.2000000000000002,3.2999999999999998,3,2.5,3,3.3999999999999999,3],"z":[6,5.0999999999999996,5.9000000000000004,5.5999999999999996,5.7999999999999998,6.5999999999999996,4.5,6.2999999999999998,5.7999999999999998,6.0999999999999996,5.0999999999999996,5.2999999999999998,5.5,5,5.0999999999999996,5.2999999999999998,5.5,6.7000000000000002,6.9000000000000004,5,5.7000000000000002,4.9000000000000004,6.7000000000000002,4.9000000000000004,5.7000000000000002,6,4.7999999999999998,4.9000000000000004,5.5999999999999996,5.7999999999999998,6.0999999999999996,6.4000000000000004,5.5999999999999996,5.0999999999999996,5.5999999999999996,6.0999999999999996,5.5999999999999996,5.5,4.7999999999999998,5.4000000000000004,5.5999999999999996,5.0999999999999996,5.9000000000000004,5.7000000000000002,5.2000000000000002,5,5.2000000000000002,5.4000000000000004,5.0999999999999996],"mode":"markers","type":"scatter3d","name":"virginica","marker":{"color":"rgba(141,160,203,1)","line":{"color":"rgba(141,160,203,1)"}},"textfont":{"color":"rgba(141,160,203,1)"},"error_y":{"color":"rgba(141,160,203,1)"},"error_x":{"color":"rgba(141,160,203,1)"},"line":{"color":"rgba(141,160,203,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

### 表格透镜

以交互式表格结合横条/点状图，快速比较大量数据与属性。

``` r
library(gt)
library(gtExtras)
# 创建交互式表格（含条形图）
iris %>%
  gt() %>%
  gt_plt_bar(column = Sepal.Length, width = 50) %>%  # 添加条形图
  gt_theme_nytimes()  # 主题风格
```

<div id="achbaiwgmt" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>@import url("https://fonts.googleapis.com/css2?family=Source+Sans+Pro:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
@import url("https://fonts.googleapis.com/css2?family=Libre+Franklin:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
@import url("https://fonts.googleapis.com/css2?family=Source+Sans+Pro:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap");
#achbaiwgmt table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#achbaiwgmt thead, #achbaiwgmt tbody, #achbaiwgmt tfoot, #achbaiwgmt tr, #achbaiwgmt td, #achbaiwgmt th {
  border-style: none;
}
&#10;#achbaiwgmt p {
  margin: 0;
  padding: 0;
}
&#10;#achbaiwgmt .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: none;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#achbaiwgmt .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#achbaiwgmt .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#achbaiwgmt .gt_heading {
  background-color: #FFFFFF;
  text-align: left;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_bottom_border {
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_col_headings {
  border-top-style: none;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: none;
  border-bottom-width: 1px;
  border-bottom-color: #334422;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 12px;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#achbaiwgmt .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 12px;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#achbaiwgmt .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#achbaiwgmt .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#achbaiwgmt .gt_column_spanner {
  border-bottom-style: none;
  border-bottom-width: 1px;
  border-bottom-color: #334422;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#achbaiwgmt .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#achbaiwgmt .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#achbaiwgmt .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#achbaiwgmt .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#achbaiwgmt .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#achbaiwgmt .gt_row {
  padding-top: 7px;
  padding-bottom: 7px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#achbaiwgmt .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#achbaiwgmt .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#achbaiwgmt .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#achbaiwgmt .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#achbaiwgmt .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#achbaiwgmt .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#achbaiwgmt .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#achbaiwgmt .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#achbaiwgmt .gt_table_body {
  border-top-style: none;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #FFFFFF;
}
&#10;#achbaiwgmt .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#achbaiwgmt .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#achbaiwgmt .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#achbaiwgmt .gt_left {
  text-align: left;
}
&#10;#achbaiwgmt .gt_center {
  text-align: center;
}
&#10;#achbaiwgmt .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#achbaiwgmt .gt_font_normal {
  font-weight: normal;
}
&#10;#achbaiwgmt .gt_font_bold {
  font-weight: bold;
}
&#10;#achbaiwgmt .gt_font_italic {
  font-style: italic;
}
&#10;#achbaiwgmt .gt_super {
  font-size: 65%;
}
&#10;#achbaiwgmt .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#achbaiwgmt .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#achbaiwgmt .gt_indent_1 {
  text-indent: 5px;
}
&#10;#achbaiwgmt .gt_indent_2 {
  text-indent: 10px;
}
&#10;#achbaiwgmt .gt_indent_3 {
  text-indent: 15px;
}
&#10;#achbaiwgmt .gt_indent_4 {
  text-indent: 20px;
}
&#10;#achbaiwgmt .gt_indent_5 {
  text-indent: 25px;
}
&#10;#achbaiwgmt .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#achbaiwgmt div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" style="color: #A9A9A9; font-family: 'Source Sans Pro'; text-transform: uppercase;" scope="col" id="Sepal.Length">Sepal.Length</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #A9A9A9; font-family: 'Source Sans Pro'; text-transform: uppercase;" scope="col" id="Sepal.Width">Sepal.Width</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #A9A9A9; font-family: 'Source Sans Pro'; text-transform: uppercase;" scope="col" id="Petal.Length">Petal.Length</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" style="color: #A9A9A9; font-family: 'Source Sans Pro'; text-transform: uppercase;" scope="col" id="Petal.Width">Petal.Width</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" style="color: #A9A9A9; font-family: 'Source Sans Pro'; text-transform: uppercase;" scope="col" id="Species">Species</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='79.38' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='76.27' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='73.16' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='71.60' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.6</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='84.05' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='71.60' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='68.49' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='76.27' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='84.05' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='74.71' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='74.71' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='66.93' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='90.28' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.2</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='88.72' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='84.05' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='79.38' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='88.72' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='79.38' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='84.05' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='79.38' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='71.60' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.6</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='79.38' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='74.71' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='80.94' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='80.94' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='73.16' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='74.71' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='84.05' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='80.94' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='85.61' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='76.27' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.2</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='85.61' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='76.27' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.6</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='68.49' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='79.38' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='70.04' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='68.49' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.6</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='79.38' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='74.71' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='79.38' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='71.60' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='82.50' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">0.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">setosa</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='108.96' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='99.62' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='107.40' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='85.61' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='101.18' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='88.72' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='98.06' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='76.27' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='102.73' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='80.94' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='91.84' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.2</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='93.39' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='94.95' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='87.17' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='104.29' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='87.17' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='90.28' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='96.51' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='87.17' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='91.84' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.8</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='94.95' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='98.06' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='94.95' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='99.62' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='102.73' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='105.85' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.8</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='104.29' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.7</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='93.39' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='88.72' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='85.61' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.8</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='85.61' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='90.28' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='93.39' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='84.05' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='93.39' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='104.29' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='98.06' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='87.17' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='85.61' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='85.61' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='94.95' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='90.28' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='77.83' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='87.17' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.2</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='88.72' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.2</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='88.72' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.2</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='96.51' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='79.38' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='88.72' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">versicolor</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='98.06' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='90.28' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.9</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='110.52' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='98.06' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='101.18' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.8</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='118.30' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='76.27' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.7</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='113.63' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.9</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='104.29' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.8</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='112.07' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.6</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='101.18' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='99.62' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.9</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='105.85' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='88.72' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='90.28' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='99.62' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.3</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='101.18' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='119.85' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='119.85' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='93.39' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='107.40' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='87.17' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='119.85' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='98.06' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.7</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='104.29' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='112.07' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='96.51' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.8</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='94.95' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='99.62' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='112.07' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.8</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.6</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='115.18' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.9</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='122.97' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='99.62' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.2</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='98.06' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.8</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='94.95' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.6</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='119.85' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">6.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='98.06' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='99.62' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.5</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='93.39' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">4.8</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='107.40' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.1</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='104.29' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.6</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.4</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='107.40' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.1</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='105.85' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.2</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.9</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='104.29' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.3</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.7</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='104.29' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.2</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='98.06' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.5</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.0</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.9</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='101.18' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.2</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.0</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='96.51' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.4</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.4</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">2.3</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
    <tr><td headers="Sepal.Length" class="gt_row gt_left" style="font-family: 'Source Sans Pro'; font-weight: 400;"><?xml version='1.0' encoding='UTF-8' ?><svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' class='svglite' width='141.73pt' height='14.17pt' viewBox='0 0 141.73 14.17'><defs>  <style type='text/css'><![CDATA[    .svglite line, .svglite polyline, .svglite polygon, .svglite path, .svglite rect, .svglite circle {      fill: none;      stroke: #000000;      stroke-linecap: round;      stroke-linejoin: round;      stroke-miterlimit: 10.00;    }    .svglite text {      white-space: pre;    }  ]]></style></defs><rect width='100%' height='100%' style='stroke: none; fill: none;'/><defs>  <clipPath id='cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw=='>    <rect x='0.00' y='0.00' width='141.73' height='14.17' />  </clipPath></defs><g clip-path='url(#cpMC4wMHwxNDEuNzN8MC4wMHwxNC4xNw==)'><rect x='6.27' y='0.89' width='91.84' height='12.40' style='stroke-width: 1.07; stroke: none; stroke-linecap: butt; stroke-linejoin: miter; fill: #A020F0;' /><line x1='6.27' y1='14.17' x2='6.27' y2='0.0000000000000018' style='stroke-width: 1.07; stroke-linecap: butt;' /></g></svg></td>
<td headers="Sepal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">3.0</td>
<td headers="Petal.Length" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">5.1</td>
<td headers="Petal.Width" class="gt_row gt_right" style="font-family: 'Source Sans Pro'; font-weight: 400;">1.8</td>
<td headers="Species" class="gt_row gt_center" style="font-family: 'Source Sans Pro'; font-weight: 400;">virginica</td></tr>
  </tbody>
  &#10;  
</table>
</div>
