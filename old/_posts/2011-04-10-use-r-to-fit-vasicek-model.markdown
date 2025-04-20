---
comments: true
layout: post
title: 用R拟合Vasicek模型
categories:
- R
tags:
- 利率模型
- Vasicek
---

Vasicek模型几乎可以说是最常见的利率模型。在金融领域有着很大的用处，可以用R来做Vasicek模型的人显然不够多。这里给出一个拟合Vasicek模型的代码：
`
#Vasicek negloglike函数:
VASICEKnegloglike<-function(param,data,times){ n.obs<-length(data)
  dum<-sort.list(times)
  data<-data[dum]
  times<-times[dum]
  delta<-diff(times,1)
  mv<-data[1:(n.obs-1)]*exp(-param[2]*delta)+param[1]*(1-exp(-param[2]*delta))
  variance<-param[3]^2*(1-exp(-2*param[2]*delta))/(2*param[2])
  VASICEKnegloglike<--sum(log(dnorm(data[2:n.obs],mv,sqrt(variance))))/n.obs
  }
#VASICEKyield函数
VASICEKyield<-function(r,tau,Pparam,riskpremium=0)
{ b<-Pparam[1]+riskpremium
  a<-Pparam[2]
  sig<-Pparam[3]
  Btau<-(1-exp(-a*tau))/a
  Atau<-((Btau-tau)*(a^2*b-0.5*sig^2)/a^2 - sig^2*Btau^2/(4*a))
  VASICEKyield<-r*Btau/tau-Atau/tau
}
# 数据实例
maturities<-c(0.25,0.5,1,2,5,10)
spliceddata<-matrix(scan("http://www.math.ku.dk/~rolf/teaching/mfe04/USrates.52to04.dat"),byrow=T,ncol=7)
obs<-spliceddata[,2]
N<-length(obs)-1
dt<-1/12
data<-obs[2:(N+1)]
lagdata<-obs[1:N]
dates<-spliceddata[,1]
#Closed form estimators
bhat<-(sum(data*lagdata) - sum(data)*sum(lagdata)/N)/(sum(lagdata*lagdata) - sum(lagdata)*sum(lagdata)/N)
kappahat<--log(bhat)/dt
ahat<-sum(data)/N-bhat*sum(lagdata)/N
thetahat<-ahat/(1-bhat)
s2hat<-sum((data-lagdata*bhat-ahat)^2)/N
sigmahat<-sqrt(2*kappahat*s2hat/(1-bhat^2))
#plot the data (or more accurately, the short rate)
plot(dates[2:(N+1)],data,type='l', xlab="date", ylab="US 3M rate", main="US short rate 1952-2004")
abline(h=thetahat, lty=3)
text(dates[10], thetahat, "thetahat")
`
[![](http://yishuo.org/wp-content/uploads/2011/04/1.png)](http://yishuo.org/wp-content/uploads/2011/04/1.png)
`
tstVAS<-optim(par=c(thetahat,kappahat,sigmahat),
              fn=VASICEKnegloglike,method = "BFGS", data=obs,times=dates)
#analyze average yield curves
meanyield<-2:7
for(i in 1:6) meanyield[i]<-mean(spliceddata[,i+1])
plot(maturities,meanyield,type='l',ylim=c(0.05,0.068),xlim=c(0,14),
     ylab="mean/average/typical yield",
	 main="Typical yield curves w/ US  1952-2004 data")
text(maturities[6],meanyield[6], "Average observed yield curve")
points(maturities,VASICEKyield(meanyield[1],maturities,tstVAS$par,riskpremium=0),type='l',lty=2)
text(maturities[6],VASICEKyield(meanyield[1],maturities[6],tstVAS$par,riskpremium=0)+0.001,
                       "Typical Vasicek model curve, I (r0 = avr. short rate, risk premium=0) ")
points(maturities,VASICEKyield(thetahat,maturities,tstVAS$par,riskpremium=0),type='l',lty=2)
text(maturities[6],VASICEKyield(thetahat,maturities[6],tstVAS$par,riskpremium=0)-0.0005,
     "Typical Vasicek model curve, II (r0 = thetahat, risk premium=0) ")`
[![](http://yishuo.org/wp-content/uploads/2011/04/2.png)](http://yishuo.org/wp-content/uploads/2011/04/2.png)
`
rpfit<-function(rp){
rpfit<-sum(abs(meanyield-VASICEKyield(meanyield[1],maturities,tstVAS$par,riskpremium=rp)))
}
rp<-optim(par=c(0),fn=rpfit,method = "BFGS")$par
theory<-VASICEKyield(meanyield[1],maturities,tstVAS$par,riskpremium=rp)
points(maturities,theory,type='l',lty=2)
text(maturities[6],theory[6],
        "Typical Vasicek model curve, III (r0=avr. short rate, risk premium='what fits best') ")
`
[![](http://yishuo.org/wp-content/uploads/2011/04/3.png)](http://yishuo.org/wp-content/uploads/2011/04/3.png)
`
plot(maturities,spliceddata[(N+1),2:7],type='l',ylab="yield",
             ylim=c(0.01,0.06),xlim=c(0,13), main="On the last day in the sample")
text(maturities[6],spliceddata[(N+1),7], "Observed yield curve")
points(maturities,VASICEKyield(spliceddata[(N+1),3],maturities,tstVAS$par,riskpremium=rp),type='l',lty=2)
text(maturities[6],VASICEKyield(spliceddata[(N+1),3],maturities[6],tstVAS$par,riskpremium=rp),
"Vasicek model 'prediction' (w/ all the estimates) ")
`
[![](http://yishuo.org/wp-content/uploads/2011/04/4.png)](http://yishuo.org/wp-content/uploads/2011/04/4.png)

