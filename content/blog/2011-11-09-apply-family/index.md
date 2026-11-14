---
title: apply函数族入门
author: MatrixSpk
date: '2011-11-09'
slug: apply-family
categories:
- R
tags:
- apply
- r
- 翻译
---

在任何一个R语言问答网站或者论坛，你都能看见这样的问题：

> 
Q:如何用循环做【...各种奇怪的事情...】
A:不用用循环哦，亲！apply函数可以解决这个问题哦，亲！

上面答案中提到的这个神奇的apply函数到底是什么？下面通过一些简单的操作示范一下。

打开R，敲入??apply函数，选定base包部分你会看到下面的东西：

```
base::apply Apply Functions Over Array Margins
base::by Apply a Function to a Data Frame Split by Factors
base::eapply Apply a Function Over Values in an Environment
base::lapply Apply a Function over a List or Vector
base::mapply Apply a Function to Multiple List or Vector Arguments
base::rapply Recursively Apply a Function to a List
base::tapply Apply a Function Over a Ragged Array
```

下面一一示范。

* apply

先看看帮助文档中对其的描述：

> “Returns a vector or array or list of values obtained by applying a function to margins of an array or matrix. ”

好吧，vector、array和function是神马我都明白，margins是什么？我来翻译一下吧，margins为1时是指行，margins为2时是指列，如果是c(1:2)，好吧，这个啰嗦的举动，指的是整个array或者matrix。

例子如下:


``` r
#创建一个10行2列的矩阵
m <- matrix(c(1:10,11:20),nrow=10,ncol=2)

#求m的每一行的均值
apply(m,1,mean)
```

```
##  [1]  6  7  8  9 10 11 12 13 14 15
```

``` r
#求m的每一列的均值
apply(m,2,mean)
```

```
## [1]  5.5 15.5
```

``` r
#将m的每个值除以2
apply(m,1:2,function(x) x/2)
```

```
##       [,1] [,2]
##  [1,]  0.5  5.5
##  [2,]  1.0  6.0
##  [3,]  1.5  6.5
##  [4,]  2.0  7.0
##  [5,]  2.5  7.5
##  [6,]  3.0  8.0
##  [7,]  3.5  8.5
##  [8,]  4.0  9.0
##  [9,]  4.5  9.5
## [10,]  5.0 10.0
```

最后一个例子仅仅是为了示范，我们有更简单的方法一秒钟实现。


``` r
m/2
```

```
##       [,1] [,2]
##  [1,]  0.5  5.5
##  [2,]  1.0  6.0
##  [3,]  1.5  6.5
##  [4,]  2.0  7.0
##  [5,]  2.5  7.5
##  [6,]  3.0  8.0
##  [7,]  3.5  8.5
##  [8,]  4.0  9.0
##  [9,]  4.5  9.5
## [10,]  5.0 10.0
```

* by

帮助文档中的描述：

> 
“Function by is an object-oriented wrapper for tapply applied to data frames. ”


事实上，by的功能绝不是这一句话所能描述的。接着读下去，你会看到

> “A data frame is split by row into data frames subsetted by the values of one or more factors, and function FUN is applied to each subset in turn. ”


这里，我们用一个带有定性变量的数据进行示范。这个数据集就是著名的iris。


``` r
attach(iris)
head(iris)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

``` r
#根据Species分类，求前4个变量的均值
by(iris[,1:4],Species,mean)
```

```
## Warning in mean.default(data[x, , drop = FALSE], ...):
## 参数不是数值也不是逻辑值：返回NA
## Warning in mean.default(data[x, , drop = FALSE], ...):
## 参数不是数值也不是逻辑值：返回NA
## Warning in mean.default(data[x, , drop = FALSE], ...):
## 参数不是数值也不是逻辑值：返回NA
```

```
## Species: setosa
## [1] NA
## ------------------------------------------------------------ 
## Species: versicolor
## [1] NA
## ------------------------------------------------------------ 
## Species: virginica
## [1] NA
```

其实，就是根据一个定性变量将数据分为若干个子集，再对各子集进行apply操作。

* eapply

帮助文档的描述：

> “eapply applies FUN to the named values from an environment and returns the results as a list. The user can request that all named objects are used (normally names that begin with a dot are not). The output is not sorted and no enclosing environments are searched. ”

有理解这句话，重点是理解environment这个东西。environment相当于是R里面的一个小系统，这个系统包含有自己的变量和函数等内容。

用一个简单的例子来示范：


``` r
#创建一个新的environment
e=new.env()
#在e中创建两个变量
e$a=1:10
e$b=11:20
#求e中变量的均值
eapply(e,mean)
```

```
## $a
## [1] 5.5
## 
## $b
## [1] 15.5
```

一般人儿可能不常用environment这个东西。不过，Bioconductor们是例外。

* lapply

帮助文档的描述：

> “lapply returns a list of the same length as X, each element of which is the result of applying FUN to the corresponding element of X. ”

这是apply函数的帮助文档中最简明扼要的一个。直接给示范：


``` r
#创建一个list
l=list(a=1:10,b=11:20)
#计算list中每个元素的均值
lapply(l,mean)
```

```
## $a
## [1] 5.5
## 
## $b
## [1] 15.5
```

``` r
#计算list中每个元素的和
lapply(l,sum)
```

```
## $a
## [1] 55
## 
## $b
## [1] 155
```

lapply的文档中让我们进一步参考sapply、vapply和replicate。那我们走去看看。

* sapply

帮助文档的描述：

>  “sapply is a user-friendly version and wrapper of lapply by default returning a vector, matrix or, if simplify="array", an array if appropriate, by applying simplify2array(). sapply(x, f, simplify=FALSE, USE.NAMES=FALSE) is the same as lapply(x,f). ”

上面一堆简单说就是，lapply返回的是一个含有两个元素$a和$b的list，而sapply返回的是一个含有元素[["a"]]和[["b"]]的vector，或者列名为a和b的矩阵。

示范如下：


``` r
#创建一个list
l=list(a=1:10,b=11:20)
#用sapply求均值
l.mean=sapply(l,mean)
#观察返回结果的类型
class(l.mean)
```

```
## [1] "numeric"
```

``` r
l.mean[['a']]
```

```
## [1] 5.5
```

* vapply

帮助文档的描述：

> “vapply is similar to sapply, but has a pre-specified type of return value, so it can be safer (and sometimes faster) to use.”

直接示范：


``` r
l=list(a=1:10,b=11:20)
#用vapply函数计算五分位数
l.fivenum=vapply(l,fivenum,c(Min.=0,"lst Qu."=0,Median=0,"3rd Qu."=0,Max.=0))
class(l.fivenum)
```

```
## [1] "matrix" "array"
```

``` r
#结果
l.fivenum
```

```
##            a    b
## Min.     1.0 11.0
## lst Qu.  3.0 13.0
## Median   5.5 15.5
## 3rd Qu.  8.0 18.0
## Max.    10.0 20.0
```

从结果可以看到，vapply返回的是一个矩阵。矩阵的列名是list的元素，行名取决于函数的输出结果。

* replicate

帮助文档的描述:

>“replicate is a wrapper for the common use of sapply for repeated evaluation of an expression (which will usually involve random number generation). ”

replicate是一个非常强大的函数，它有两个强制参数：replications,即操作的重复次数；function，及要重复的操作。还有一个可选择参数：simplify=T，是否将操作结果转化为vector或者matrix。

示范：


``` r
replicate(10,rnorm(10))
```

```
##              [,1]       [,2]        [,3]       [,4]       [,5]        [,6]
##  [1,]  0.09404565  0.6900446  0.20266413  0.5129547  1.0128168  0.05653415
##  [2,] -0.91284275  0.4148158  0.52344728  1.6220620 -0.1530737  0.05569266
##  [3,] -2.82534108 -0.8308159 -0.80378790 -0.4079487 -2.1890716 -0.63564857
##  [4,] -0.88857743 -0.3077837 -1.04967642  0.3230530  0.1094893  0.38889519
##  [5,]  0.21849109  1.2910931 -1.31689751 -0.8643641 -1.6985050 -0.72514369
##  [6,]  0.42406931  1.0962243  0.03433455 -0.3644647 -1.1519254 -0.51264405
##  [7,] -0.95389493  0.8339559 -0.48655834  0.0271446  0.8224275 -0.75322140
##  [8,]  1.30411129  0.6961557 -0.94826540  3.8187493  1.9491568 -0.70021472
##  [9,]  1.42619896  1.3484791 -1.77604799  0.2154067  0.3761675 -0.24362034
## [10,] -0.12993140  0.2320959 -0.08696657  1.2382602  0.5781700 -1.26176561
##              [,7]       [,8]       [,9]      [,10]
##  [1,]  0.29583451  1.7547814 -0.4761433 -2.9786950
##  [2,] -1.51743386 -2.1529347  0.3729536  0.2775196
##  [3,] -0.46015526 -0.7021302 -0.3539648 -0.6730854
##  [4,]  0.89778909  0.1765478  1.9319342  0.3784471
##  [5,]  1.42831439 -0.3437932  0.3734149  0.3974802
##  [6,]  0.07412502 -2.5053443 -1.0342991  0.8934034
##  [7,]  0.04454659 -0.1709211 -0.4627233  1.0121957
##  [8,] -0.46424059 -0.2812505 -0.3270812  0.2869938
##  [9,]  0.11599570  1.5177862  0.2759767  0.8952857
## [10,]  0.59676528 -0.1538958 -0.9503086 -0.3969758
```

* mapply

帮助文档的描述：

>“mapply is a multivariate version of sapply. mapply applies FUN to the first elements of each ... argument, the second elements, the third elements, and so on. Arguments are recycled if necessary. ”

如果你认真看看mapply的帮助文档的话，我打赌你会看到头大。这里给看官两个简单的例子：


``` r
l1=list(a=1:10,b=11:20)
l2=list(c=21:30,d=31:40)
l1
```

```
## $a
##  [1]  1  2  3  4  5  6  7  8  9 10
## 
## $b
##  [1] 11 12 13 14 15 16 17 18 19 20
```

``` r
l2
```

```
## $c
##  [1] 21 22 23 24 25 26 27 28 29 30
## 
## $d
##  [1] 31 32 33 34 35 36 37 38 39 40
```

``` r
#计算l1,l2中各元素的和
mapply(sum,l1$a,l1$b,l2$c,l2$d)
```

```
##  [1]  64  68  72  76  80  84  88  92  96 100
```

竖直看下来，加总就得到了上面的结果。

* rapply

帮助文档的描述：

> “rapply is a recursive version of lapply. ”

这个描述是史上最差描述之一。因为rapply跟recursive并没有太大关系。rapply的创造性在于提供了一个结果输出形式的参数。

示范：


``` r
#创建list
l=list(a=1:10,b=11:20)
#计算l中元素的log2
rapply(l,log2)
```

```
##       a1       a2       a3       a4       a5       a6       a7       a8 
## 0.000000 1.000000 1.584963 2.000000 2.321928 2.584963 2.807355 3.000000 
##       a9      a10       b1       b2       b3       b4       b5       b6 
## 3.169925 3.321928 3.459432 3.584963 3.700440 3.807355 3.906891 4.000000 
##       b7       b8       b9      b10 
## 4.087463 4.169925 4.247928 4.321928
```

``` r
#将结果的输出形式设定为list

rapply(l,log2,how="list")
```

```
## $a
##  [1] 0.000000 1.000000 1.584963 2.000000 2.321928 2.584963 2.807355 3.000000
##  [9] 3.169925 3.321928
## 
## $b
##  [1] 3.459432 3.584963 3.700440 3.807355 3.906891 4.000000 4.087463 4.169925
##  [9] 4.247928 4.321928
```

``` r
#计算均值
rapply(l,mean)
```

```
##    a    b 
##  5.5 15.5
```

``` r
rapply(l,mean,how="list")
```

```
## $a
## [1] 5.5
## 
## $b
## [1] 15.5
```

综上，rapply函数的输出结果取决于函数和how参数。当how="list"时，数据的原始结构被保留，否则，输出结果被转化为vector。

当然，看官还可以将classes函数传递给rapply函数。例如在混合型list中，可以通过classes=numeric，是的函数子对数字型元素进行操作。

* tapply

帮助文档的描述：

>“Apply a function to each cell of a ragged array, that is to each (non-empty) group of values given by a unique combination of the levels of certain factors.”

语焉不详。翻译一下大概是：

“tapply(X, INDEX, FUN = NULL, ..., simplify = TRUE)”中的“X”是
“an atomic object, typically a vector.”，而“INDEX”是“list of factors, each of same length as X. The elements are coerced to factors by as.factor.”

依然以iris数据集为例示范一下：


``` r
attach(iris)
```

```
## The following objects are masked from iris (pos = 3):
## 
##     Petal.Length, Petal.Width, Sepal.Length, Sepal.Width, Species
```

``` r
#根据sprcies进行分类，计算petal的均值
tapply(iris$Petal.Length,Species,mean)
```

```
##     setosa versicolor  virginica 
##      1.462      4.260      5.552
```

简短的总结：

这里给出的都是极其简单的例子，基于最简单的数据，和最简单的函数。因为对于每一个操作而言，看官都可查看数据的操作前状态和操作后状态，这样便于看官知道，操作到底对数据干了什么事情。

当然了，apply函数的功能不限于文中介绍的这些，进一步的功用期待看官自己去挖掘。

给出几个使用apply函数的建议，在使用之前应当思考：

* 原始数据是什么类型？vector?matrix?data frame?....
* 想对原始数据的哪些子集进行操作？行?列？所有元素？....
* 操作将返回什么结果？原始数据的结构是如何变化的？

只是一个老生常谈的关于“输入——操作——输出”的故事：你有什么？你想要什么？两者之间需要什么？
