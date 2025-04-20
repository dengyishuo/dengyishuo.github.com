---
layout: post
title: 安装mgarchBEKK包
comments: true
categories:
- R
tags:
- mgarchBEKK
- R
- Rtools
---

`R`中另外一个拟合`BEKK`模型的包是`mgarchBEKK`。这个包跟前面提到的`mgarch`包类似。主函数也基本一样，分别是`mvBEKK.sim`、`mvBEKK.est`、`mvBEKK.diag`等。这个包作者已经很久没有更新了，好像已经放弃更新。但是有不少人还想用它。我们现在能在`quantmod`包的主页找到该包的源代码，但不巧的是源代码包中缺失了`namespace`。不过，没关系，我们可以为其添加一个`namespace`即可。添加完之后，压缩为`.tar`格式的压缩包（已添加完`namespace`的`mgarchBEKK`可以到[这里](https://github.com/dengyishuo/dengyishuo.github.com/blob/master/media/mgarchBEKK.tar)下载）。
然后，按照前面提到的安装方式进行安装即可。