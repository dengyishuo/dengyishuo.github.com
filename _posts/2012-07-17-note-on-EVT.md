---
layout: post
title: R中的关于极值理论的包
comments: true
categories:
- R
tags:
- EVT
- POT
- R
- 极值理论
---

第一部分：包evir
一、探索性函数：
{% highlight r%}
library(evir)
data(danish)
findthresh(danish, 50)
{% endhighlight %}
寻找阀值，例子中寻找出来的阀值使得超越它的为50个数。

data(danish)
emplot(danish) #经验分布函数，如果得到的结果是直线那么符合帕累托分布。

data(bmw)
exindex(bmw, 100) #估计极值指标

data(danish)
hill(danish) #Hill 图 基于帕累托分布

data(danish)
meplot(danish) #简单均值剩余图
如果图形是向上直线，说明有厚尾，如果直线有正的斜率，说明服从帕累托分布。图

形如果是向下的直线，说明薄尾，如果直线0斜率，服从指数分布。

data(danish)
records(danish) #极值记录函数
二、分布拟合函数
data(bmw)
out <- gev(bmw, "month") #拟合GEV分布。
rlevel.gev(out, 40) 

data(nidd.annual)
out <- gumbel(nidd.annual, method = "BFGS", control = list(maxit = 500)) #

拟合gumbel分布。

data(danish)
out <- gpd(danish, 10) #拟合GPD分布。

data(danish)
shape(danish) #估计GPD参数图

data(danish)
quant(danish, 0.999) #GPD高分位数尾估计图

data(danish)
out <- gpd(danish, 10) #拟合gpd模型
tp=tailplot(out) #Plot Tail Estimate From GPD Model
gpd.q(tp, 0.999) # Add Quantile Estimates to plot.gpd
gpd.sfall(tp, 0.999) # Add Expected Shortfall Estimates to a GPD Plot

data(danish)
out <- pot(danish, 10)
#拟合POT模型

data(bmw)
data(siemens)
out <-gpdbiv(-bmw, -siemens, ne1 = 100, ne2 = 100) #拟合二元gpd模型
interpret.gpdbiv(out, 0.05, 0.05) #解释二元gpd模型
plot(out) #其中有5张图可以画

三、风险损失估计函数
data(danish)
out <- gpd(danish, 10)
riskmeasures(out, c(0.999, 0.9999))

第二部分：包evd
一、探索型函数
par(mfrow = c(1,2))
smdat1 <- rbvevd(1000, dep = 0.6, model = "log")
smdat2 <- rbvevd(1000, dep = 1, model = "log")
chiplot(smdat1) #针对二元极值度量依赖度 依赖为1，否则接近于0.
chiplot(smdat2) # 独立为0

data(portpirie)
tlim <- c(3.6, 4.2)
tcplot(portpirie, tlim) #阀值选择
tcplot(portpirie, tlim, nt = 100, lwd = 3, type = "l")
tcplot(portpirie, tlim, model = "pp")

data(portpirie)
clusters(portpirie, 4.2, 3) #甄别超限簇
clusters(portpirie, 4.2, 3, cmax = TRUE) #cmax=F
clusters(portpirie, 4.2, 3, 3.8, plot = TRUE)
clusters(portpirie, 4.2, 3, 3.8, plot = TRUE, lvals = FALSE)
tvu <- c(rep(4.2, 20), rep(4.1, 25), rep(4.2, 20))
clusters(portpirie, tvu, 3, plot = TRUE)

data(portpirie)
exi(portpirie, 4.2, r = 3, ulow = 3.8) #估计极值指标
tvu <- c(rep(4.2, 20), rep(4.1, 25), rep(4.2, 20))
exi(portpirie, tvu, r = 1)
exi(portpirie, tvu, r = 0) 

sdat <- mar(100, psi = 0.5)
tlim <- quantile(sdat, probs = c(0.4,0.9))
exiplot(sdat, tlim) #画极值指标图
exiplot(sdat, tlim, r = 4, add = TRUE, lty = 2)
exiplot(sdat, tlim, r = 0, add = TRUE, lty = 4)

data(portpirie)
mrlplot(portpirie) #经验平均剩余寿命图

二、分布估计函数
bvdata <- rbvevd(100, dep = 0.7, model = "log")
abvnonpar(seq(0, 1, length = 10), data=bvdata,convex=T) #二元极值分布的依

赖函数的非参数估计
abvnonpar(data = bvdata, method = "pick", plot = TRUE) #二元极值分布的依赖

函数的非参数估计
M1 <- fitted(fbvevd(bvdata, model = "log"))
abvevd(dep = M1["dep"], model = "log", plot = TRUE) #二元极值分布依赖函数

的参数估计
abvnonpar(data = bvdata, add = TRUE, lty = 2) #二元极值分布的依赖函数的非

参数估计

amvevd(dep = 0.5, model = "log") #多元极值分布依赖函数标准型
s3pts <- matrix(rexp(30), nrow = 10, ncol = 3)
s3pts <- s3pts/rowSums(s3pts)
amvevd(s3pts, dep = 0.5, model = "log") #多元极值分布依赖函数的参数估计
amvevd(dep = 0.05, model = "log", plot = TRUE, blty = 1)
amvevd(dep = 0.95, model = "log", plot = TRUE, lower = 0.94)

asy <- list(.4, .1, .6, c(.3,.2), c(.1,.1), c(.4,.1), c(.2,.3,.2))
amvevd(s3pts, dep = 0.15, asy = asy, model = "alog")
amvevd(dep = 0.15, asy = asy, model = "al", plot = TRUE, lower = 0.7)

s5pts <- matrix(rexp(50), nrow = 10, ncol = 5)
s5pts <- s5pts/rowSums(s5pts)
sdat <- rmvevd(100, dep = 0.6, model = "log", d = 5) #生成多元极值分布的伪

随机数
amvnonpar(s5pts, sdat, d = 5) #多元极值分布依赖函数的非参数估计

amvnonpar(data = sdat, plot = TRUE)
amvnonpar(data = sdat, plot = TRUE, ord = c(2,3,1), lab = LETTERS[1:3])
amvevd(dep = 0.6, model = "log", plot = TRUE)
amvevd(dep = 0.6, model = "log", plot = TRUE, blty = 1) 

bvdata <- rbvevd(100, dep = 0.7, model = "log")
qcbvnonpar(c(0.9,0.95), data = bvdata, plot = TRUE)
qcbvnonpar(c(0.9,0.95), data = bvdata, epmar = TRUE, plot = TRUE)

bvdata <- rbvevd(100, dep = 0.7, model = "log")
M1 <- fitted(fbvevd(bvdata, model = "log"))
hbvevd(dep = M1["dep"], model = "log", plot = TRUE)

uvdata <- rgev(100, loc = 0.13, scale = 1.1, shape = 0.2) #
trend <-(-49:50)/100
M1 <- fgev(uvdata, nsloc = trend) #极大似然法拟合GEV分布
M2 <- fgev(uvdata)
M3 <- fgev(uvdata, shape = 0)
anova(M1, M2, M3) #方差分析

data(portpirie)
m1 <- fgev(portpirie)
confint(m1) #参数的置信区间
pm1 <- profile(m1) #描述拟合结果，优化结果
plot(pm1) #
confint(pm1) #

uvdata <- rgev(100, loc = 0.13, scale = 1.1, shape = 0.2)
trend <- (-49:50)/100
M1 <- fgev(uvdata, nsloc = trend, control = list(trace = 1))
M2 <- fgev(uvdata)
M3 <- fgev(uvdata, shape = 0)
M4 <- fgev(uvdata, scale = 1, shape = 0)
anova(M1, M2, M3, M4)
par(mfrow = c(2,2))
plot(M2)
M2P <- profile(M2)
plot(M2P)

rnd <- runif(100, min = -.5, max = .5)
fgev(uvdata, nsloc = data.frame(trend = trend, random = rnd))
fgev(uvdata, nsloc = data.frame(trend = trend, random = rnd), locrandom = 

0)

uvdata <- rgev(100, loc = 0.13, scale = 1.1, shape = 0.2)
M1 <- fgev(uvdata, prob = 0.1)
M2 <- fgev(uvdata, prob = 0.01)
M1P <- profile(M1, which = "quantile")
M2P <- profile(M2, which = "quantile")
plot(M1P)
plot(M2P)

uvdata <- rgev(100,0.13,1.1,0.2)
M1 <- fgev(uvdata)
M1P <- profile(M1)
M1JP <- profile2d(M1, M1P, which = c("scale", "shape"))
plot(M1JP)

uvd <- rorder(100, qnorm, mean = 0.56, mlen = 365, j = 2)
forder(uvd, list(mean = 0, sd = 1), distn = "norm", mlen = 365, j = 2)
forder(uvd, list(rate = 1), distn = "exp", mlen = 365, j = 2)
forder(uvd, list(scale = 1), shape = 1, distn = "gamma", mlen = 365, j = 

2)
forder(uvd, list(shape = 1, scale = 1), distn = "gamma", mlen = 365, j = 

2)

uvdata <- rgpd(100, loc = 0, scale = 1.1, shape = 0.2)
M1 <- fpot(uvdata, 1)
M2 <- fpot(uvdata, 1, shape = 0)
anova(M1, M2)
par(mfrow = c(2,2))
plot(M1)
M1P <- profile(M1)
plot(M1P)

M1 <- fpot(uvdata, 1, mper = 10)
M2 <- fpot(uvdata, 1, mper = 100)
M1P <- profile(M1, which = "rlevel", conf=0.975, mesh=0.1)
M2P <- profile(M2, which = "rlevel", conf=0.975, mesh=0.1)
plot(M1P) #诊断图
plot(M2P)

bvdata <- rbvevd(100, dep = 0.75, model = "log") #
M1 <- fbvevd(bvdata, model = "log")
M2 <- fbvevd(bvdata, model = "log", dep = 0.75)
M3 <- fbvevd(bvdata, model = "log", dep = 1)
anova(M1, M2)
anova(M1, M3, half = TRUE)

bvdata <- rbvevd(100, dep = 0.6, model = "log", mar1 = c(1.2,1.4,0.4))
M1 <- fbvevd(bvdata, model = "log")
M2 <- fbvevd(bvdata, model = "log", dep = 0.75)
anova(M1, M2)
par(mfrow = c(2,2))
plot(M1) #诊断图
plot(M1, mar = 1)
plot(M1, mar = 2)
par(mfrow = c(1,1))
M1P<-profile(M1, which = "dep")
plot(M1P)

trend <- (-49:50)/100
rnd <- runif(100, min = -.5, max = .5)
fbvevd(bvdata, model = "log", nsloc1 = trend)
fbvevd(bvdata, model = "log", nsloc1 = trend, nsloc2 = data.frame(trend= 

trend, random = rnd))
fbvevd(bvdata,model="log",nsloc1=trend,nsloc2=data.frame

(trend=trend,random = rnd), loc2random = 0)

bvdata <- rbvevd(100, dep = 1, asy = c(0.5,0.5), model = "anegl")
anlog <- fbvevd(bvdata, model = "anegl")
amixed <- fbvevd(bvdata, model = "amix")
mixed <- fbvevd(bvdata, model = "amix", beta = 0)
mixed <- fbvevd(bvdata, model = "anegl", dep = 1, sym = TRUE)
anova(anlog, mixed)
anova(amixed, mixed)

bvdata <- rbvevd(1000, dep = 0.5, model = "log")
u <- apply(bvdata, 2, quantile, probs = 0.9)
M1 <- fbvpot(bvdata, u, model = "log")
M2 <- fbvpot(bvdata, u, "log", dep = 0.5)
anova(M1, M2)

uvdata <- rextreme(100, qnorm, mean = 0.56, mlen = 365)
fextreme(uvdata, list(mean = 0, sd = 1), distn = "norm", mlen = 365)
fextreme(uvdata, list(rate = 1), distn = "exp", mlen = 365)
fextreme(uvdata, list(scale = 1), shape = 1, distn = "gamma", mlen = 365)
fextreme(uvdata, list(shape = 1, scale = 1), distn = "gamma", mlen = 365)

三、数据模拟函数
library(evd)
marma(100, p = 1, q = 1, psi = 0.75, theta = 0.65) #模拟marmag过程
mar(100, psi = 0.85, n.start = 20) #模拟mar过程
mma(100, q = 2, theta = c(0.75, 0.8)) #模拟mma过程

evmc(100, alpha = 0.1, beta = 0.1, model = "bilog") #基于极值结构模拟马尔

科夫过程
evmc(100, dep = 10, model = "hr", margins = "gum") #

第三部分、包POT
该包主要针对GPD分布。这一点初学者应该知道，以免产生不必要的疑问。
大致可以分为3个过程，即模型探索阶段、模型拟合阶段、模型诊断阶段。其中探索

阶段主要包括探索数据的可能分布形式、数据的阀值选取、数据的超限簇分布等。模

型拟合主要包括GPD模型、二元GPD模型、马尔科夫POT模型。模型诊断主要有画图诊

断、qq诊断、pp诊断等。还有一些辅助性结果展示如谱密度、密度等。
模型探索用到的函数主要有判断相关性函数chimeas()、tsdep.plot()、ts2tsd（）

、tailind.test（） ；超限簇函数clust()；阀值选取函数tcplot()、lmomplot()；

平均剩余寿命函数mrlplot()。阀值选取函数和平均剩余寿命函数要与超限簇函数配

合使用。
拟合模型的函数主要有fitexi()、fitgpd()、fitbvgpd()、fitmcgpd()、fitpp()。

给出参数置信区间主要有gpd.fishape(）、gpd.fiscale（）、gpd.firl（）[给出的

的是费希尔置信区间]、gpd.pfrl（）、gpd.pfshape（）、gpd.pfshape（）给出

profile置信区间。logLik（）可以给出模型估计的极大似然值。confint（）可以直

接给出置信区间。
模型诊断函数主要有，anova()可以比较不同的模型拟合结果。plot()给出模型诊断

图。convassess()估计参数对初值的敏感性。pp()和qq()检验拟合结果，如果是直线

说明拟合效果良好。retlev()得到return level值。
模型诊断个函数都是以模型拟合结果为操作对象的。
specdens（）给出拟合结果的谱密度。dens（）,模型的密度图。dexi（）给出机制

指标密度图。diplot（）极值指标扩散图，基于clust()函数的结果。

第一部分：探索性函数
1.判断相关性函数
library(POT)
mc<-simmc(2000, alpha = 0.9)
mc2<-simmc(1000, alpha = 0.2)

par(mfrow = c(1,2))
chimeas(cbind(mc[1:1000], mc2))

par(mfrow = c(1,2))
chimeas(cbind(mc[seq(1,2000, by = 2)], mc[seq(2,2000,by = 2)]))

par(mfrow = c(1,2))
chimeas(cbind(mc[seq(1,2000, by = 2)], mc[seq(2,2000,by = 2)]), boot 

=TRUE)#判断相关性

tsdep.plot(runif(5000), u = 0.95, lag.max = 5)
mc <- simmc(5000, alpha = 0.2)
tsdep.plot(mc, u = 0.95, lag.max = 5) #tsdep.plot判断时间序列的相关性

data(ardieres)
tsd <- ts2tsd(ardieres, 3 / 365) #

plot(ardieres, type = "l", col = "blue")
lines(tsd, col = "green")

##A total independence example
x <- rbvgpd(7000, alpha = 1, mar1 = c(0, 1, 0.25))
tailind.test(x)

y <- rbvgpd(7000, alpha = 0.75, model = "nlog", mar1 = c(0, 1, 0.25),
mar2 = c(2, 0.5, -0.15))
tailind.test(y)

z <- rnorm(7000)
tailind.test(cbind(z, 2*z - 5)) #检验尾部独立性

data(ardieres)
ardieres <- clust(ardieres, 4, 10 / 365, clust.max = TRUE)
flows <- ardieres[, "obs"]
lmomplot(flows, identify = FALSE) #L-moment阀值选择，很有用

data(ardieres)
ardieres <- clust(ardieres, 4, 10 / 365, clust.max = TRUE)
flows <- ardieres[, "obs"]
mrlplot(flows) #经验平均剩余寿命阀值选择，有用

data(ardieres)
ardieres <- clust(ardieres, 4, 10 / 365, clust.max = TRUE)
flows <- ardieres[, "obs"]
par(mfrow=c(1,2))
tcplot(flows, u.range = c(0, 15) ) #tcplot选择阀值

data(ardieres)
par(mfrow=c(1,2))
clust(ardieres, 4, 10 / 365)
clust(ardieres, 4, 10 / 365, clust.max = TRUE)
clust(ardieres, 4, 10 / 365, clust.max = TRUE, plot = TRUE)
##The same but with optional arguments passed to function ``plot''
clust(ardieres, 4, 10 / 365, clust.max = TRUE, plot = TRUE,
xlab = "Time (Years)", ylab = "Flood discharges",
xlim = c(1972, 1980)) #判断时间序列的超限簇

x<-rgpd(75, 1, 2, 0.1)
pwmu <- fitgpd(x, 1, "pwmu")
dens(pwmu) #密度图

mc<-simmc(1000, alpha = 0.25)
mc<-qgpd(mc, 0, 1, 0.25)
log <- fitmcgpd(mc, 2, shape = 0.25, scale = 1)
dexi(log, n.sim = 200) #计算极值指标的密度图

data(ardieres)
ardieres <- clust(ardieres, 4, 10 / 365, clust.max = TRUE)
diplot(ardieres) #极值指标散开图
二、模型拟合
1.拟合极值指标
data(ardieres)
exi<-fitexi(ardieres, 6)
exi
clust(ardieres, 6, tim.cond=exi$tim.cond/365.25,clust.max=TRUE)

2.拟合二元GPD分布
x<-rgpd(1000, 0, 1, -0.25)
y<-rgpd(1000, 2, 0.5, 0)
M0<-fitbvgpd(cbind(x,y), c(0, 2))
M1<-fitbvgpd(cbind(x,y), c(0,2), model = "alog")
anova(M0, M1)

##Non regular case
M0 <- fitbvgpd(cbind(x,y), c(0, 2))
M1 <- fitbvgpd(cbind(x,y), c(0, 2), alpha = 1)
anova(M0, M1, half=TRUE)

x <- rgpd(1000, 0, 1, 0.25)
y <- rgpd(1000, 3, 1, -0.25)
ind <- fitbvgpd(cbind(x, y), c(0, 3), "log")
ind
ind2 <- fitbvgpd(cbind(x, y), c(0, 3), "log", alpha = 1)
ind2
ind3 <- fitbvgpd(cbind(x, y), c(0, 3), cscale = TRUE)
ind3
dep <- fitbvgpd(cbind(x, x + 3), c(0, 3), "mix")
dep

x <- rbvgpd(1000, alpha = 0.55, mar1 = c(0,1,0.25), mar2 = c(2,0.5,0.1))
Mlog <- fitbvgpd(x, c(0, 2), "log")
layout(matrix(c(1,1,2,2,0,3,3,0), 2, byrow = TRUE))
plot(Mlog) 

3．拟合GPD分布

data(ardieres)
ardieres <- clust(ardieres, 4, 10 / 365, clust.max = TRUE)
fitted <- fitgpd(ardieres[, "obs"], 6, 'mle')
npy <- fitted$nat / 33.4 ##33.4 is the total record length (in year)
par(mfrow=c(2,2))
plot(fitted, npy = npy)

x<-rgpd(1000, 0, 1, -0.15)
M0<-fitgpd(x, 0, shape = -0.15)
M1<-fitgpd(x, 0)
anova(M0, M1) 

x <- rgpd(100, 0, 1, 0.25)
mle <- fitgpd(x, 0)
confint(mle, prob = 0.2)
confint(mle, parm = "shape") #估计GPD参数置信区间

data(ardieres)
ardieres <- clust(ardieres, 4, 10 / 365, clust.max = TRUE)
fitted <- fitgpd(ardieres[,"obs"], 5, 'mle')
gpd.fishape(fitted)
gpd.fiscale(fitted) #费希尔置信区

data(ardieres)
events <- clust(ardieres, u = 4, tim.cond = 8 / 365,
clust.max = TRUE)
MLE <- fitgpd(events[, "obs"], 4, 'mle')
gpd.pfshape(MLE, c(0, 0.8)) #profile 置信区间
rp2prob(10, 2)
gpd.pfrl(MLE, 0.95, c(12, 25)) 

##Univariate Case
x <- rgpd(30, 0, 1, 0.2)
med <-fitgpd(x, 0, "med")
convassess(med)

##Bivariate Case
x <- rbvgpd(50, model = "log", alpha = 0.5, mar1 = c(0, 1, 0.2))
log <- fitbvgpd(x, c(0,0))
convassess(log) #参数的稳定性

x <- rgpd(500, 0, 1, -0.15)
mle <- fitgpd(x, 0)
logLik(mle) #GPD的极大似然值
convassess（mle）
4.拟合马尔科夫POT模型
mc <- simmc(200, alpha = 0.5)
mc <- qgpd(mc, 0, 1, 0.25)
Mclog <- fitmcgpd(mc, 1)
par(mfrow=c(2,2))
rlMclog <- plot(Mclog)
rlMclog(T = 3)

data(ardieres)
Mcalog <- fitmcgpd(ardieres[,"obs"], 5, "alog")
retlev(Mcalog, opy = 990)

x <- rgpd(200, 1, 2, 0.25)
mle <- fitgpd(x, 1, "mle")$param
pwmu <- fitgpd(x, 1, "pwmu")$param
pwmb <- fitgpd(x, 1, "pwmb")$param
pickands <- fitgpd(x, 1, "pickands")$param ##Check if Pickands estimates
##are valid or not !!!
med <- fitgpd(x, 1, "med", ##Sometimes the fitting algo is not
start = list(scale = 2, shape = 0.25))$param ##accurate. So specify
##good starting values is
##a good idea.
mdpd <- fitgpd(x, 1, "mdpd")$param
lme <- fitgpd(x, 1, "lme")$param
mple <- fitgpd(x, 1, "mple")$param
ad2r <- fitgpd(x, 1, "mgf", stat = "AD2R")$param

print(rbind(mle, pwmu, pwmb, pickands, med, mdpd, lme,mple, ad2r))

##Use PWM hybrid estimators
fitgpd(x, 1, "pwmu", hybrid = FALSE)

##Now fix one of the GPD parameters
##Only the MLE, MPLE and MGF estimators are allowed !
fitgpd(x, 1, "mle", scale = 2)
fitgpd(x, 1, "mple", shape = 0.25) 

mc <- simmc(1000, alpha = 0.25)
mc <- qgpd(mc, 0, 1, 0.25)
##A first application when marginal parameter are estimated
fitmcgpd(mc, 0)
##Another one where marginal parameters are fixed
mle <- fitgpd(mc, 0)
fitmcgpd(mc, 0, scale = mle$param["scale"], shape = mle$param["shape"])

x<-rgpd(1000, 0, 1, 0.2)
fitpp(x, 0) #拟合PP方法

x <- rbvgpd(1000, alpha = 0.9, model = "mix", mar1 = c(0,1,0.25),
mar2 = c(2,0.5,0.1))
Mmix <- fitbvgpd(x, c(0,2), "mix")
pickdep(Mmix) #pickand 相关性检验

x <- rgpd(75, 1, 2, 0.1)
pwmb <- fitgpd(x, 1, "pwmb")
pp(pwmb)
#ppplot，检验模型，如果是直线，模型拟合很好。

x <- rgpd(75, 1, 2, 0.1)
pwmu <- fitgpd(x, 1, "pwmu")
qq(pwmu)#检验模型，直线。

x <- rbvgpd(1000, alpha = 0.25, mar1 = c(0, 1, 0.25))
Mlog <- fitbvgpd(x, c(0, 0), "log")
retlev(Mlog)

x <- rgpd(75, 1, 2, 0.1)
pwmu <- fitgpd(x, 1, "pwmu")
rl.fun <- retlev(pwmu)
rl.fun(100)

par(mfrow=c(1,2))
##Spectral density for a Markov Model
mc <- simmc(1000, alpha = 0.25, model = "log")
mc <- qgpd(mc, 0, 1, 0.1)
Mclog <- fitmcgpd(mc, 0, "log")
specdens(Mclog)
##Spectral density for a bivariate POT model
x <- rgpd(500, 5, 1, -0.1)
y <- rgpd(500, 2, 0.2, -0.25)
Manlog <- fitbvgpd(cbind(x,y), c(5,2), "anlog")
specdens(Manlog) #谱密度

第四部分：包fExtremes
包中寻找阀值的函数为findThreshold（），blockMaxima（），pointProcess

(),deCluster()。机制指标估计函数、exindexPlot()、exindexesPlot()，注意这两

者的不同。emdPlot（）经验分布函数。qqparetoPlot（）、mePlot（）、mrlPlot（

）、msratioPlot（）、recordsPlot（）、ssrecordsPlot（）、sllnPlot（）、

lilPlot（）、xacfPlot（）、ghMeanExcessFit（）、hypMeanExcessFit（）、

nigMeanExcessFit（）、ghtMeanExcessFit（）
blockTheta()、clusterTheta()、runTheta()、ferrosegersTheta()计算Theta。

计算VaR和ES的函数分别是VaR()和CVaR()。
包里面有两个模型演示函数分别是tailSlider()、gevSlider()、gpdSlider()。
library(fExtremes)。
模拟GEV分布gevSim（）。gumbelSim（）。gpdSim()。thetaSim()。
拟合模型的函数有gevFit()、gumbelFit（）、gpdFit()看拟合结果用summay()，诊

断模型plot()。tailPlot()、tailRisk()、gpdTailPlot（）、gpdShapePlot（）。
gevMoments（）模拟gev过程并返回真是均值等。gpdMoments（）。
hillplot()、shaparmPlot()，shaparmPickands(),shaparmHill()，shaparmDEHaan

（）。gpdQPlot()、gpdQuantPlot（）、
计算风险损失的函数tailRisk()、gpdRiskMeasures（）、gpdSfallPlot（）、VaR()

、CVaR()
gevrlevelPlot()
x = as.timeSeries(data(danishClaims))
findThreshold(x, n = c(10, 50, 100)) #寻找阀值

BMW = as.timeSeries(data(bmwRet))
colnames(BMW) = "BMW.RET"
head(BMW)
x=blockMaxima( BMW, block = 65)
head(x)
y=blockMaxima(-BMW, block = 65) #寻找超限数据集
head(y)
y = blockMaxima(-BMW, block = "monthly")
head(y)

PP=pointProcess(x = -BMW, u = quantile(as.vector(x), 0.75))
PP
nrow(PP)

DC=deCluster(x = PP, run = 15, doplot = TRUE)
DC
nrow(DC)

## Extremal Index for the right and left tails
## of the BMW log returns:
data(bmwRet)
par(mfrow = c(2, 2), cex = 0.7)
exindexPlot( as.timeSeries(bmwRet), block = "quarterly")
exindexPlot(-as.timeSeries(bmwRet), block = "quarterly") 

## Extremal Index for the right and left tails
## of the BMW log returns:
exindexesPlot( as.timeSeries(bmwRet), block = 65)
exindexesPlot(-as.timeSeries(bmwRet), block = 65)
#注意两者的不同，返回的参数是不同的。

gevSlider(method = "dist")
gevSlider(method = "rvs")

#这个很好玩儿。对于gpd同样适用。

探索性数据分析函数：
# Simulate GEV Data, use default length n=1000
x = gevSim(model = list(xi = 0.25, mu = 0 , beta = 1), n = 1000)
head(x)

## gumbelSim -
# Simulate GEV Data, use default length n=1000
x = gumbelSim(model = list(xi = 0.25, mu = 0 , beta = 1))

## gevFit -
# Fit GEV Data by Probability Weighted Moments:
fit = gevFit(x, type = "pwm")
print(fit)

## summary -
# Summarize Results:
par(mfcol = c(2, 2))
summary(fit)

## gpdSim -
x = gpdSim(model = list(xi = 0.25, mu = 0, beta = 1), n = 1000)
## gpdFit -
par(mfrow = c(2, 2), cex = 0.7)
fit = gpdFit(x, u = min(x), type = "pwm")
print(fit)
summary(fit) 

gevMoments:
# Returns true mean and variance:
gevMoments(xi = 0, mu = 0, beta = 1)

## gevSim -
# Simulate GEV Data, use default length n=1000
x = gevSim(model = list(xi = 0.25, mu = 0 , beta = 1), n = 1000)
head(x)

## gumbelSim -
# Simulate GEV Data, use default length n=1000
x = gumbelSim(model = list(xi = 0.25, mu = 0 , beta = 1))

## gevFit -
# Fit GEV Data by Probability Weighted Moments:
fit = gevFit(x, type = "pwm")
print(fit)

## summary -
# Summarize Results:
par(mfcol = c(2, 2))
summary(fit)

## Load Data:
# BMW Stock Data - negative returns
x = -as.timeSeries(data(bmwRet))
colnames(x)<-"BMW"
head(x)

## gevFit -
# Fit GEV to monthly Block Maxima:
fit = gevFit(x, block = "month")
print(fit)

## gevrlevelPlot -
# Return Level Plot:
gevrlevelPlot(fit)
#估计排雷托分布
## gpdSim -
x = gpdSim(model = list(xi = 0.25, mu = 0, beta = 1), n = 1000)
## gpdFit -
par(mfrow = c(2, 2), cex = 0.7)
fit = gpdFit(x, u = min(x), type = "pwm")
print(fit)
summary(fit) 

## Load Data:
danish = as.timeSeries(data(danishClaims))

## Tail Plot:
x = as.timeSeries(data(danishClaims))
fit = gpdFit(x, u = 10)
tailPlot(fit)

## Try Tail Slider:
# tailSlider(x) 

## Tail Risk:
tailRisk(fit)
#GPD有关函数
gpdQPlot estimation of high quantiles,
gpdQuantPlot variation of high quantiles with threshold,
gpdRiskMeasures prescribed quantiles and expected shortfalls,
gpdSfallPlot expected shortfall with confidence intervals,
gpdShapePlot variation of shape with threshold,
gpdTailPlot plot of the tail,
tailPlot ,
tailSlider ,
tailRisk .
gpdSim generates data from the GPD,
gpdFit fits empirical or simulated data to the distribution,
print print method for a fitted GPD object of class ...,
plot plot method for a fitted GPD object,
summary summary method for a fitted GPD object. 

gevSim generates data from the GEV distribution,
gumbelSim generates data from the Gumbel distribution,
gevFit fits data to the GEV distribution,
gumbelFit fits data to the Gumbel distribution,
print print method for a fitted GEV object,
plot plot method for a fitted GEV object,
summary summary method for a fitted GEV object,
gevrlevelPlot k-block return level with confidence intervals. 

可以直接计算VaR CVaR
?VaR
?CVaR

Search Results
The search string was "garch"
________________________________________
bayesGARCH
Bayesian Estimation of the GARCH(1,1) Model with Student-t Innovations
Garch
Daily Observations on Exchange Rates of the US Dollar Against Other 

Currencies
fGarch-package
GARCH Modelling Package
absMoments
Absolute Moments of GARCH Distributions
fGARCH-class
Class "fGARCH"
fGARCHSPEC-class
Class "fGARCHSPEC"
garchFit
Univariate GARCH Time Series Fitting
garchFitControl
GARCH Fitting Algorithms and Control
garchSim
Univariate GARCH/APARCH Time Series Simulation
garchSpec
Univariate GARCH Time Series Specification
coef-methods
GARCH Coefficients Methods
fitted-methods
Extract GARCH Model Fitted Values
formula-methods
Extract GARCH Model formula
plot-methods
GARCH Plot Methods
predict-methods
GARCH Prediction Function
residuals-methods
Extract GARCH Model Residuals
show-methods
GARCH Modelling Show Methods
summary-methods
GARCH Summary Methods
volatility-methods
Extract GARCH Model Volatility
RcmdrepackPlugin-internal
Internal RcmdrepackPlugin objects
gBox
Generalized Portmanteau Tests for GARCH Models
garch.sim
Simulate a GARCH process
garch-methods
Methods for Fitted GARCH Models
garch
Fit GARCH Models to Time Series
summary.garch
Summarizing GARCH Model Fits