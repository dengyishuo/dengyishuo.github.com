---
layout: post
title: 安装mgarch包终极解决方案
comments: true
categories:
- R
tags:
- mgarch
- R
- Rtools
---

`mgarch`包是一个可以拟合和诊断`BEKK`模型的`R`包。包中的主函数很少，只有`mvBEKK.sim`，`mvBEKK.diag`，`mvBEKK.est`三个。
这三个函数各司其职，分别用来模拟`BEKK`数据、诊断`BEKK`模型、拟合`BEKK`模型。照常理说，这样的包很好啦。就只有一样不好，
作者自从2009年更新一次之后，再也不提供更新的`.zip`包了。很多需要拟合`BEKK`模型的同学记得团团转就是不知道怎么安装和使用
这个包。这里提供三个方案：

#### 方案一：

下载[mgarch](http://sourceforge.net/projects/mgarch/?source=directory)的源代码。解压缩到`R`的当前工作文件夹中。如果不
知道当前工作文件夹路径。敲入`get.wd()`函数就可以看到了。解压缩之后，按照`mgarch->>R`的顺序打开文件夹，你会在R文件夹中
看到好几个`.r`格式的文件。用`source()`函数载入进来就可以用了。

#### 方案二：

拿着mgarch包，按照[开发R程序包之忍者篇]（cos.name/2011/05/write-r-packages-like-a-ninja/‎）自己编译mgarch包。

#### 方案三:

安装`Rtools`，安装并将`zoo`、`tseries`、`mvnorm`升级到合适版本。将`mgarch_0.00-1.tar.gz`放到当前工作文件夹中，然后，敲
入下面的代码：

{% highlight r%}
install.packages("mgarch_0.00-1.tar.gz",repos=NULL,type="source")  ##安装源代码文件
library(mgarch)   ##查看是否可以使用
{% endhighlight %}