---
title: 有用但不易被发现的R函数：file.choose
author: MatrixSpk
date: '2013-06-03'
slug: useful-functions-in-R
categories:
- R
tags:
- file.choose
- R
---
用R进行数据分析的时候，常常需要从外部载入数据或者函数。比如，我们有一个名为`example.txt`的数据位于E盘中的R文件夹中，我们可以用下面的命令把数据读取到R里：


``` r
dat = read.table("E://R/example.txt",header=TRUE)
```

在同样的文件夹中，有一个现成的函数脚本文件命名为`fun.r`，现在需要将其载入到R中使用。可以用下面的命令:


``` r
soure("E://R/fun.r")
```

上面这两种做法有一个共同点就是得记住文件的绝对路径。绝对路径短的话，没有任何问题。当绝对路径很长，长到记不清楚的时候就麻烦了。

一个偷懒的做法是使用`setwd()`设定工作文件夹。比如，我们可以把R的工作路径设定为`E://R/`：


``` r
setwd("E://R/")
```

然后，载入数据或者函数就可以用简化的命令了：


``` r
source("fun.r")
dat <- read.table("example.txt",header=TRUE)
```

如果连`E://R/`都记不清楚呢？那就只能搞一个浏览窗口了。R中恰好有这个函数：`file.choose()`


``` r
source(file.choose())
dat <- read.table(file.choose(),header=TRUE)
```

运行之后，R会弹出一个`Select File`的小窗口，挥动鼠标就可以对各个盘符和文件夹进行选择了。
