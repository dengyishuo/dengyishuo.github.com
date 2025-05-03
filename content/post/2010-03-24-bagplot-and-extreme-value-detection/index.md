---
title: 布袋图与极值检测
author: MatrixSpk
date: '2010-03-24'
slug: bagplot and extreme value detection
categories:
  - data visualization
tags:
  - data
  - vis
  - extreme value
---

有一种趣味横生的检测异常值的方法叫bagplot。它首先定义一个二维数据的center,之后将与center较为疏离的点定义为野值。

以经典的car数据为例：

    
    library(aplpack);
    library(rpart);
    cardata<-car.test.frame[,6:7];
    par(mfrow=c(1,1))
    bagplot(cardata,verbose=F,factor=3,show.baghull=T,
    dkmethod=2,show.loophull=T,precision=1)
    title("car data Chambers/Hastie 1992")
    


生成一个正态数据，是什么样子？

    
    seed=222;
    set.seed(seed);
    n=200;
    data=rnorm(n,mean=0);
    datan<-cbind(data,c(rnorm(n-2,mean=20),10,30));
    datan[,2]<-datan[,2]*300;
    bagplot(datan,factor=3,create.plot=T,approx.limit=300,
    show.outlier=T,show.looppoints=T,
    show.bagpoints=T,dkmethod=2,
    show.whiskers=T,show.loophull=T,
    show.baghull=T,verbose=F)
    title(paste("seed: ",seed,"/ n: ",n));
    



如果数据规模巨大呢？

    
    seed=194
    n=3000
    set.seed(seed)
    data=rnorm(n)
    datan<-cbind(data,c(rnorm(n-2,mean=76,sd=20),105,50));
    datan[,2]<-datan[,2]*300
    bagplot(datan,factor=3,create.plot=T,approx.limit=300,
    show.outlier=T,show.looppoints=T,
    show.bagpoints=T,dkmethod=2,
    show.whiskers=T,show.loophull=T,
    show.baghull=T,verbose=F)
    title(paste("seed: ",seed,"/ n: ",n))
    

