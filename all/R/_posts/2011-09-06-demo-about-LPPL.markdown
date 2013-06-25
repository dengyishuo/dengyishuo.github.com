---
author: admin
comments: true
date: 2011-09-06 16:21:25
layout: post
slug: r%e7%a4%ba%e4%be%8b%ef%bc%9alppl
title: R示例：LPPL
wordpress_id: 836
categories:
- R&amp;数据艺术
tags:
- LPPL
- r
- 示例
- 股市拐点
- 金融
---

library(quantmod)

 LPPL1<-function(p,dtc=20,alpha=0.35,omega=0.1,phi=1)
 {
 	#function in page 26 of http://arxiv.org/abs/0905.0220
 	#the basic form of LPPL
 	dtc=abs(floor(dtc))
 	tc<-length(p)+dtc
 	dt<-abs(tc-(1:length(p)))

 	x1<-dt^alpha
 	x2<-(dt^alpha)*cos(omega*log(dt)+phi)
 	
 	f<-lm(log(p) ~ x1+x2)
 	
 	f$para<-list(recno=dim(f$model)[1],dtc=dtc,alpha=alpha,omega=omega,phi=phi,sigma=summary(f)$sigma)
 	return(f)
 }

 opt.lppl<-function(x)
 {
 	#derived function for optim
 	return(LPPL1(p,dtc=x[1],alpha=x[2],omega=x[3],phi=x[4])$para$sigma)
 }

 LPPL1.x<-function(lpplf,pt=100)
 {
 	#x axis for predicting
 	dt<-abs((lpplf$recno+lpplf$dtc)-(1:(lpplf$recno+lpplf$dtc+pt)))
 	dt[dt==0]<-0.5
 	
 	x1<-dt^lpplf$alpha
 	x2<-(dt^lpplf$alpha)*cos(lpplf$omega*log(dt)+lpplf$phi)
 	return(list(x1=x1,x2=x2))
 	
 }

 #get the SP500 index
 pr<-getSymbols("^GSPC",auto.assign=FALSE,from="2003-10-1",to="2007-05-16")[,4]
 p<-as.numeric(pr)

 plot(p,type="l",log="y",xlim=c(0,length(p)+100),ylim=c(min(p),max(p)*1.2))
 abline(v=length(p),col="green")

 #something like the Fig. 23 in  Page 39 of http://arxiv.org/abs/0905.0220
 #but obviously the result is not calibrated well
 #using optim like this can not calibrate the LPPL model
 opts<-sapply(seq(1,50,10),function(x){
 			o<-optim(c(x,0.6,20,1),opt.lppl)
 			f3<-LPPL1(p,dtc=o$par[1],alpha=o$par[2],omega=o$par[3],phi=o$par[4])
 			xp<-LPPL1.x(f3$para,200)
 			f3p<-predict(f3,data.frame(x1=xp$x1,x2=xp$x2))
 			lines(exp(f3p),col="blue")
 			lines(exp(fitted(f3)),col="red")
 			f3$para
 		})



 ##crash point after dtc days
 dtc<-seq(1,100,1)

 ##appropraite range of the parametes of LPPL
 ##according to Dr. W.X. Zhou's new book which is in Chinese
 ##the increments of the sequences are added according to my own judement
 alpha<-seq(0.01,1.2,0.1)
 omega<-seq(0,40,1)
 phi<-seq(0,7,0.1)

 ##millions possible combinations
 #complete test would be difficult
 para<-expand.grid(dtc=dtc,alpha=alpha,omega=omega,phi=phi)
 dim(para)
 system.time(sigs<-apply(para[1:100,],1,function(x){LPPL1(p,dtc=x[1],alpha=x[2],omega=x[3],phi=x[4])$para$sigma}))
[![](http://yishuo.org/wp-content/uploads/2011/09/LPPL.png)](http://yishuo.org/wp-content/uploads/2011/09/LPPL.png)
