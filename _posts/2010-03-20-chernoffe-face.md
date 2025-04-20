---
layout: post
title: Chernoff脸谱图
comments: true
categories:
- R
tags:
- Chernoff
- faces
- 可视化
- 脸谱图
---

处于一种特殊的审美原因，我一直都很欣赏 Chernoff 创造的脸谱图，经常对此唏嘘不已：世界上竟然有如此浪漫的统计学家。脸谱图工作原理十分简单，它用人类的脸部特征来刻画多维变量。是一种可爱又好玩的多元数据的可视化方法。
一般的Chernoff脸谱图是这样的:

    
    library(aplpack);
    faces(rnorm(5),face.type=0)
    


[![](http://yishuo.cos.name/wp-content/uploads/2010/03/chernoff1.png)](http://yishuo.cos.name/wp-content/uploads/2010/03/chernoff1.png)
当然也有更好看的：

    
    faces(rnorm(5),face.type=1)
    


[![](http://yishuo.cos.name/wp-content/uploads/2010/03/chernoff2.png)](http://yishuo.cos.name/wp-content/uploads/2010/03/chernoff2.png)
我比较喜欢圣诞老人这个版本：

    
    faces(rnorm(5),face.type=2)
    


[![](http://yishuo.cos.name/wp-content/uploads/2010/03/chernoff3.png)](http://yishuo.cos.name/wp-content/uploads/2010/03/chernoff3.png)

上面表情过于严肃，画个微笑的。
[![](http://yishuo.cos.name/wp-content/uploads/2010/03/chernoff5.png)](http://yishuo.cos.name/wp-content/uploads/2010/03/chernoff5.png)
