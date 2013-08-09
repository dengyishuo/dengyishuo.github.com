---
comments: true
layout: post
title: 用四个参数拟合大象
categories:
- 未分类
tags:
- 参数
- 大象
---

冯·诺依曼说过一句话，
`
With four parameters I can fit an elephant, and with five I can make him wiggle his trunk.
`
冯·诺依曼说这句话的时候，当然是一种隐喻。他的大致意思是说，当一个模型能够完美拟合一个数据集的时候，不要沾沾自喜或者得意到脱掉下巴。因为之所以出现这种情况很可能是因为模型的参数太多，而不是模型的形式很好。如果给模型足够多的参数，我们实际上可以完美的拟合任何数据集。
虽然用四个参数来拟合大象并非是冯·诺依曼的本意，可是打他说出来这句话起，就有很多人开始前赴后继地研究如何用四个参数来真的拟合出来一头大象。
后来，Jurgen Mayer, Khaled Khairy, and Jonathon Howard在论文“Drawing an elephant with four complex parameters”当真实现了这句话。
[![](http://yishuo.org/wp-content/uploads/2011/06/elephant.png)](http://yishuo.org/wp-content/uploads/2011/06/elephant.png)

上图所用的R代码如下：
`
p1=50-30i
p2=18+8i
p3=12-10i
p4=-14-60i
p5=40+20i

fourier=function(tt,CC){
f=numeric(length(tt));
A=Re(CC);
B=Im(CC);
k=1:length(CC);
for(i in 1:length(tt)){
co=cos(tt[i]*k)
si=sin(tt[i]*k)
f[i]=sum(A*co+B*si)
f
}
f
}

elephant=function(tt,p1,p2,p3,p4,p5){
n=6
Cx=complex(n);
Cy=complex(n);
Cx[1]=Re(p1)*1i
Cx[2]=Re(p2)*1i
Cx[3]=Re(p3)
Cx[5]=Re(p4)
Cy[1]=Im(p4)+Im(p1)*1i
Cy[2]=Im(p2)*1i
Cy[3]=Im(p3)*1i

x=fourier(tt,Cx)
y=fourier(tt,Cy)
res=cbind(y,-x)
res
}

tt=seq(from=0,to=2*pi,length=100)
el=elephant(tt,p1,p2,p3,p4,p5)

plot(el,type="l",col="red",ylab="",xlab="",lwd=2)
points(Im(p5),Im(p5),pch=20,col="red")  
`

