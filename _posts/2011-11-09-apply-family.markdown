---
comments: true
layout: post
title: apply函数族入门
categories:
- R语言
tags:
- apply
- r
- 翻译
---

在任何一个R语言问答网站或者论坛，你都能看见这样的问题：
[code]
Q:如何用循环做【...各种奇怪的事情...】
A:不用用循环哦，亲！apply函数可以解决这个问题哦，亲！
[/code]
那么，这个神奇的apply函数到底是神马呢？下面通过一些简单的操作示范给各位看官。
打开R，敲入??apply函数，选定base包部分你会看到下面的东西：
[code]
base::apply Apply Functions Over Array Margins
base::by Apply a Function to a Data Frame Split by Factors
base::eapply Apply a Function Over Values in an Environment
base::lapply Apply a Function over a List or Vector
base::mapply Apply a Function to Multiple List or Vector Arguments
base::rapply Recursively Apply a Function to a List
base::tapply Apply a Function Over a Ragged Array
[/code]
下面一一示范。
1.apply
先看看帮助文档中对其的描述：
[code]
“Returns a vector or array or list of values obtained by applying a function to margins of an array or matrix. ”
[/code]
好吧，vector、array和function是神马我都明白，margins是神马东东？简单来说，margins为1时是指行，margins为2时是指列，如果是c(1:2),好吧，这个啰嗦的举动，指的是整个array或者matrix。例子如下:
[code]
#创建一个10行2列的矩阵
m=matrix(c(1:10,11:20),nrow=10,ncol=2)
#求m的每一行的均值
apply(m,1,mean)
[1] 6 7 8 9 10 11 12 13 14 15
#求m的每一列的均值
apply(m,2,mean)
[1] 5.5 15.5
#将m的每个值除以2
apply(m,1:2,function(x) x/2)
[,1] [,2]
[1,] 0.5 5.5
[2,] 1.0 6.0
[3,] 1.5 6.5
[4,] 2.0 7.0
[5,] 2.5 7.5
[6,] 3.0 8.0
[7,] 3.5 8.5
[8,] 4.0 9.0
[9,] 4.5 9.5
[10,] 5.0 10.0
[/code]
最后一个例子仅仅是为了示范，我们有更简单的方法来实现。
[code]
m/2
[,1] [,2]
[1,] 0.5 5.5
[2,] 1.0 6.0
[3,] 1.5 6.5
[4,] 2.0 7.0
[5,] 2.5 7.5
[6,] 3.0 8.0
[7,] 3.5 8.5
[8,] 4.0 9.0
[9,] 4.5 9.5
[10,] 5.0 10.0
[/code]

2.by
帮助文档中的描述：
[code]
“Function by is an object-oriented wrapper for tapply applied to data frames. ”
[/code]
事实上，by的功能绝不是这一句话所能描述的。接着读下去，你会看到
[code]
“A data frame is split by row into data frames subsetted by the values of one or more factors, and function FUN is applied to each subset in turn. ”
[/code]
这里，我们用一个带有定性变量的数据进行示范。
这个数据集就是著名的iris。
[code]
attach(iris)
head(iris)
Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1 5.1 3.5 1.4 0.2 setosa
2 4.9 3.0 1.4 0.2 setosa
3 4.7 3.2 1.3 0.2 setosa
4 4.6 3.1 1.5 0.2 setosa
5 5.0 3.6 1.4 0.2 setosa
6 5.4 3.9 1.7 0.4 setosa
#根据Species分类，求前4个变量的均值
by(iris[,1:4],Species,mean)
Species: setosa
Sepal.Length Sepal.Width Petal.Length Petal.Width
5.006 3.428 1.462 0.246
---------------------------------------------------------
Species: versicolor
Sepal.Length Sepal.Width Petal.Length Petal.Width
5.936 2.770 4.260 1.326
--------------------------------------------------------
Species: virginica
Sepal.Length Sepal.Width Petal.Length Petal.Width
6.588 2.974 5.552 2.026
[/code]
其实，就是根据一个定性变量将数据分为若干个子集，然后在对自己进行apply操作。
3.eapply
帮助文档的描述：
[code]
“eapply applies FUN to the named values from an environment and returns the results as a list. The user can request that all named objects are used (normally names that begin with a dot are not). The output is not sorted and no enclosing environments are searched. ”
[/code]
有理解这句话，重点是理解environment这个东西。environment相当于是R里面的一个小系统，这个系统包含有自己的变量和函数等内容。用一个简单的例子来示范：
[code]
#创建一个新的environment
e=new.env()
#在e中创建两个变量
e$a=1:10
e$b=11:20
#求e中变量的均值
eapply(e,mean)
$a
[1] 5.5
$b
[1] 15.5
[/code]
一般人儿可能不常用environment这个东西。不过,Bioconductor们是例外哦！
4.lapply
帮助文档的描述：
[code]
“lapply returns a list of the same length as X, each element of which is the result of applying FUN to the corresponding element of X. ”
[/code]
这是apply函数的帮助文档中最简明扼要的一个。直接给示范：
[code]
#创建一个list
l=list(a=1:10,b=11:20)
#计算list中每个元素的均值
lapply(l,mean)
$a
[1] 5.5
$b
[1] 15.5
#计算list中每个元素的和
lapply(l,sum)
$a
[1] 55
$b
[1] 155
[/code]
lapply的文档中让我们进一步参考sapply、vapply和replicate。那我们走去看看咯！
4.1 sapply
帮助文档的描述：
[code]
“sapply is a user-friendly version and wrapper of lapply by default returning a vector, matrix or, if simplify="array", an array if appropriate, by applying simplify2array(). sapply(x, f, simplify=FALSE, USE.NAMES=FALSE) is the same as lapply(x,f). ”
[/code]
上面一堆简单说就是，lapply返回的是一个含有两个元素$a和$b的list，而sapply返回的是一个含有元素[["a"]]和[["b"]]的vector，或者列名为a和b的矩阵。
示范如下：
[code]
#创建一个list
l=list(a=1:10,b=11:20)
#用sapply求均值
l.mean=sapply(l,mean)
#观察返回结果的类型
class(l.mean)
[1] "numeric"
#提取元素a的均值
1.mean[['a']]
[1] 5.5
[/code]
4.2 vapply
帮助文档的描述：
[code]
“vapply is similar to sapply, but has a pre-specified type of return value, so it can be safer (and sometimes faster) to use.”
[/code]
直接示范：
[code]
l=list(a=1:10,b=11:20)
#用vapply函数计算五分位数
l.fivenum=vapply(l,fivenum,c(Min.=0,"lst Qu."=0,Median=0,"3rd Qu."=0,Max.=0))
class(l.fivenum)
[1] "matrix"
#结果
l.fivenum
a b
Min. 1.0 11.0
lst Qu. 3.0 13.0
Median 5.5 15.5
3rd Qu. 8.0 18.0
Max. 10.0 20.0
[/code]
所以，亲，你看到了，vapply返回的是一个矩阵。矩阵的列名是list的元素，行名取决于函数的输出结果。
4.3 replicate
帮助文档的描述:
[code]
“replicate is a wrapper for the common use of sapply for repeated evaluation of an expression (which will usually involve random number generation). ”
[/code]
replicate是一个非常强大的函数，它有两个强制参数：replications,即操作的重复次数；function，及要重复的操作。还有一个可选择参数：simplify=T，是否将操作结果转化为vector或者matrix。
示范：
[code]
replicate(10,rnorm(10))
[,1] [,2] [,3] [,4] [,5] [,6]
[1,] 0.0615684 0.5398778 0.9815460 -1.352409971 -0.46670108 -0.5609335
[2,] 0.7501444 1.3515495 -1.1324161 0.482136905 0.01806138 -0.2143325
[3,] -1.6764568 -0.5816864 0.4668710 0.016770345 -1.19560774 0.6414898
[4,] -0.4259504 1.6960433 -0.1759500 0.293043551 -0.13894691 1.8681723
[5,] -2.4212326 1.1064597 1.6042605 -1.157019574 2.60824933 -0.6255382
[6,] -0.6131776 -1.7253104 -1.1349404 0.009324671 -2.11739811 -0.8523519
[7,] 0.6331760 -0.5458755 -0.1237157 -0.874786715 0.16970787 -0.3328544
[8,] 0.3754509 0.1577973 1.5376246 0.109439826 -0.30158661 -0.6086636
[9,] 1.1086812 -2.1814234 -0.4258651 -0.152788898 -0.25801517 -0.9072564
[10,] 1.9340591 0.5341643 0.4909151 0.877046384 1.13504362 0.3492340
[,7] [,8] [,9] [,10]
[1,] 0.55758137 -0.2411162 -2.66867275 -1.009182336
[2,] -0.10909235 1.2934438 1.13655059 -0.462670113
[3,] -1.13680550 -0.5422744 0.19473334 -2.053553409
[4,] 0.17695953 -0.9123063 -0.03708775 0.019742325
[5,] 0.08053346 -1.3154510 -1.05838904 0.211655454
[6,] 1.08128078 -1.0607662 -0.25984969 -0.150065431
[7,] 1.45707769 0.3940861 0.59462210 -0.270396491
[8,] -0.24380501 -1.0949531 0.45358256 0.005766857
[9,] -2.00170358 -1.8108618 -0.86100307 2.014660900
[10,] -0.94547942 1.6362386 -0.19392441 -0.729144393
[/code]
5.mapply
帮助文档的描述：
[code]
“mapply is a multivariate version of sapply. mapply applies FUN to the first elements of each ... argument, the second elements, the third elements, and so on. Arguments are recycled if necessary. ”
[/code]
如果你认真看看mapply的帮助文档的话，我打赌你会看到头大。这里给看官两个简单的例子：
[code]
l1=list(a=1:10,b=11:20)
l2=list(c=21:30,d=31:40)
#计算l1,l2中各元素的和
mapply(sum,l1$a,l1$b,l2$c,l2$d)
[1] 64 68 72 76 80 84 88 92 96 100
l1
$a
[1] 1 2 3 4 5 6 7 8 9 10
$b
[1] 11 12 13 14 15 16 17 18 19 20
l2
$c
[1] 21 22 23 24 25 26 27 28 29 30
$d
[1] 31 32 33 34 35 36 37 38 39 40
[/code]
竖直看下来，加总就得到了上面的结果。
6.rapply
帮助文档的描述：
[code]
“rapply is a recursive version of lapply. ”
[/code]
这个描述是史上最差描述之一。因为rapply跟recursive并没有太大关系。rapply的创造性在于提供了一个结果输出形式的参数。
示范：
[code]
#创建list
l=list(a=1:10,b=11:20)
#计算l中元素的log2
rapply(l,log2)
a1 a2 a3 a4 a5 a6 a7 a8
0.000000 1.000000 1.584963 2.000000 2.321928 2.584963 2.807355 3.000000
a9 a10 b1 b2 b3 b4 b5 b6
3.169925 3.321928 3.459432 3.584963 3.700440 3.807355 3.906891 4.000000
b7 b8 b9 b10
4.087463 4.169925 4.247928 4.321928
#将结果的输出形式设定为list
rapply(l,log2,how="list")
$a
[1] 0.000000 1.000000 1.584963 2.000000 2.321928 2.584963 2.807355 3.000000
[9] 3.169925 3.321928
$b
[1] 3.459432 3.584963 3.700440 3.807355 3.906891 4.000000 4.087463 4.169925
[9] 4.247928 4.321928
#计算均值
rapply(l,mean)
a b
5.5 15.5
rapply(l,mean,how="list")
$a
[1] 5.5
$b
[1] 15.5
[/code]
综上，rapply函数的输出结果取决于函数和how参数。当how="list"时，数据的原始结构被保留，否则，输出结果被转化为vector。
当然，看官还可以将classes函数传递给rapply函数。例如在混合型list中，可以通过classes=numeric，是的函数子对数字型元素进行操作。
7.tapply
帮助文档的描述：
[code]
“Apply a function to each cell of a ragged array, that is to each (non-empty) group of values given by a unique combination of the levels of certain factors.”
[/code]
哇哦，亲，被吓到了吧。亲莫怕。详细说明中：
“tapply(X, INDEX, FUN = NULL, ..., simplify = TRUE)”中的“X”是
“an atomic object, typically a vector.”，而“INDEX”是“list of factors, each of same length as X. The elements are coerced to factors by as.factor.”
依然以iris数据集为例。
[code]
attach(iris)
#根据sprcies进行分类，计算petal的均值
tapply(iris$Petal.Length,Species,mean)
setosa versicolor virginica
1.462 4.260 5.552
[/code]
简短的总结：
这里给出的都是极其简单的例子，基于最简单的数据，和最简单的函数。因为对于每一个操作而言，看官都可查看数据的操作前状态和操作后状态，这样便于看官知道，操作到底对数据干了什么事情。
当然了，apply函数的功能不限于文中介绍的这些，进一步的功用期待看官自己去挖掘。
给出几个使用apply函数的建议，在使用之前应当思考：
原始数据是什么类型？vector?matrix?data frame?....
想对原始数据的哪些子集进行操作？行?列？所有元素？....
操作将返回什么结果？原始数据的结构是如何变化的？
只是一个老生常谈的关于“输入——操作——输出”的故事：你有什么？你想要什么？两者之间需要什么？
翻译自:http://nsaunders.wordpress.com/2010/08/20/a-brief-introduction-to-apply-in-r/。
更多译文：http://yishuo.org
