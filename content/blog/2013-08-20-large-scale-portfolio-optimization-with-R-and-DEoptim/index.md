---
title: 使用R和DEoptim求解大规模投资组合
author: MatrixSpk
date: '2013-08-20'
slug: large-scale-portfolio-optimization-with-R-and-DEoptim
categories:
- 量化投资
tags:
- 投资组合
- DEoptim
---

### 1.楔子

第四届上海 R 语言会议时，在演讲中提到过一个 R 包：DEoptim 。这是一个用来做优化的包，它实现了几个差分进化算法（ Differential Evolution algorithms ）。差分进化算法是个什么东西呢？从“进化算法”这四个字可以看出它似乎跟生物学有点沾边，事实上，它算是遗传算法（ Genetic algorithms ）的一种。

诸位知道，遗传算法总的来说是借鉴了生物学中生物进化（其实，说优化可能更准确）过程，这种思路还是比较巧妙的。差分进化算法也类似，差分进化算法的主要过程是这样的：生成随机种子的群体、对各群体进行杂交、对群体进行变异、筛选优秀的群体作为后代。不断重复这一过程直到群体后代的优秀程度没法得到显著的提高为止。如果把目标函数（ objective function ）看作衡量群体优秀程度的标准、把目标函数的输入参数看作群体，显然，可以用差分遗传算法来对目标函数进行优化。

作为一种优化算法，差分进化算法可以应用到很多领域，金融领域的优化问题很多，求解投资组合就是其中一个应用。所以，这篇文章想看一看差分进化算法在求解投资组合方面的表现。选择投资组合的准则有很多，这里我们根据组合的 CVaR 对组合进行优化。具体来说，在各资产对组合贡献的 CVaR 的权重不超过 5% 的条件下，使得组合的 CVaR 的值最小。

具体的技术细节可参考 Portfolio Optimization with CVaR budgets 。

这里的组合优化对应的是一个非凸优化问题。用传统的局部最优方法，比如， optim 包和 nlminb 包中的 L-BFGS-B 方法和 Nelder-Mead 方法，在求解此类优化问题时，常常收敛到次优解，而非最优解。DEoptim 算法属于随机全局优化算法，相比较而言，它的优化效果会更好。

为了是文章更接近现实，下面使用的组合中的证券数目设定为 100 只股票。

### 2.系统环境说明

文中所有的结果和代码都基于 R 3.0.1 。获取数据用的是 quantmod 包中的 getSymbols 函数。目标函数中的风险度量函数来自 PerformanceAnalytics 包。DEoptim 函数的初始群落则由 PortfolioAnalytics 包中的 random_portfolios 函数生成。

DEoptim 函数会反复计算目标函数的值，直到把群落逼近全局最小值。对提高 DEoptim 函数的性能感兴趣的同学，必须集中活力解决目标函数的进化速度。对于纯 R 代码而言，最好的途径是并行。当然，最根本的道路还是用 c或者Fortran 对该算法进行重写。

### 3.获取数据

下面从 S&P 500中随意选取 100支股票作为组合中基础股票。然后，用 quantmod 包中的 getSymbols 函数来下载得到它们的10年间的月度数据，并计算指数收益率序列、均值序列及协方差矩阵。


``` r
 tickers = c( "VNO" , "VMC" , "WMT" , "WAG" , "DIS" , "WPO" , "WFC" , "WDC" ,
 "WY" , "WHR" , "WMB" , "WEC" , "XEL" , "XRX" , "XLNX" ,"ZION" ,"MMM" ,
 "ABT", "ADBE" , "AMD" , "AET" , "AFL" , "APD" , "ARG" ,"AA" , "AGN" ,
 "ALTR" , "MO" , "AEP" , "AXP" , "AIG" , "AMGN" , "APC" ,"ADI" , "AON" ,
 "APA", "AAPL" , "AMAT" ,"ADM" , "T" , "ADSK" , "ADP" , "AZO" , "AVY" ,
 "AVP", "BHI" , "BLL" , "BAC" , "BK" , "BCR" , "BAX" , "BBT" , "BDX" ,
 "BMS" , "BBY" , "BIG" , "HRB" , "BMC" , "BA" , "BMY" , "CA" , "COG" ,
 "CPB" , "CAH" , "CCL" , "CAT" , "CELG" , "CNP" , "CTL" , "YHOO", "CERN" ,
 "SCHW" , "CVX" , "CB" , "CI" ,"CINF" ,"CTAS" , "CSCO" , "C" , "CLF" ,
 "CLX", "CMS" , "KO" , "CCE" , "CL" , "CMCSA" ,"CMA" , "CSC" , "CAG" ,
 "COP" , "ED" , "QQQ" ,"GLW" , "COST" , "CVH" , "CSX" , "CMI" , "CVS" ,
 "DHR" , "DE")

 library(quantmod);
 getSymbols(tickers, from = "2000-12-01", to = "2010-12-31")
 P <- NULL; seltickers <- NULL
 for(ticker in tickers) {
 tmp <- Cl(to.monthly(eval(parse(text=ticker))))
 if(is.null(P)){ timeP = time(tmp) }
 if( any( time(tmp)!=timeP )) next
 else P<-cbind(P,as.numeric(tmp))
 seltickers = c( seltickers , ticker )
 }
 P = xts(P,order.by=timeP)
 colnames(P) <- seltickers
 R <- diff(log(P))
 R <- R[-1,]
 dim(R)
 mu <- colMeans(R)
 sigma <- cov(R)
```

### 4.设定目标函数及约束条件

这里的投资组合的优化问题由两个部分组成：一是，选择令投资组合具有最小CVaR的的组合权重；二是，令每支股票对整个投资组合的CVaR值的贡献不超过 5%。同时，组合必须是正数，且组合必须进行满仓操作。

借助于 PerformanceAnalytics 包中的 ES 函数，我们可以方便地计算投资组合的 CVaR 水平以及各支股票对整个投资组合的CVaR贡献值。简单起见，在计算CVaR值时，假定序列服从正态分布。不过，对于非正态分布的收益率序列而言，也能用 ES 函数计算其相应的组合CVaR水平以及各支股票对整个投资组合CVaR的贡献值。

为了使得得到的组合中，所有股票对整个组合的 CVaR 的贡献不超过 5% ，我们可以向目标函数增加一个罚函数。本来，我们允许搜索算法去考虑那些非可行解。必须对那些无法为投资者接受的投资组合施加足够的惩罚，以使得他们在目标函数的最小化过程中被过滤掉。并且，其对约束的偏离越大，目标函数的值应该增加的越多。


``` r
 library("PerformanceAnalytics")
 obj <- function(w) {
 if (sum(w) == 0) {
 w <- w + 1e-2
 }
 w <- w / sum(w)
 CVaR <- ES(weights = w,
 method = "gaussian",
 portfolio_method = "component",
 mu = mu,
 sigma = sigma)
 tmp1 <- CVaR$ES
 tmp2 <- max(CVaR$pct_contrib_ES - 0.05, 0)
 out <- tmp1 + 1e3 * tmp2
 return(out)
 }
```

组合权重需要满足两个条件，一是，多头；二是，必须满仓操作。现在的 DEoptim 允许对组合权重设定约束范围。我们称其为下边界 lower 和上边界 upper。


``` r
 N <- ncol(R)
 minw <- 0
 maxw <- 1
 lower <- rep(minw,N)
 upper <- rep(maxw,N)
```

完整的投资约束包括两个方面：一是，将目标函数的所有权重进行标准化，使得所有权重之和为 1 。二是，使用 Portfolioanalytics 包中的 random_portfolios 函数来生成满足上述所有约束条件的随机组合。DEoptim 将采用这些随机组合作为初始群落。


``` r
 source("random_portfolios.R")
 eps <- 0.025
 weight_seq<-generatesequence(min=minw,max=maxw,by=.001,rounding=3)
 rpconstraint<-constraint(
 assets=N, min_sum=(1-eps), max_sum=(1+eps),
 min=lower, max=upper, weight_seq=weight_seq)
 set.seed(1234)
 rp<- random_portfolios(rpconstraints=rpconstraint,permutations=N*10)
 rp <-rp/rowSums(rp)
```

### 5.尝试传统的梯度优化方法

前面介绍的目标函数中的罚函数是不可微，因此，标准的基于梯度的优化方法不再适用。比如，optim 包中的 L-BFGS-B 方法，还有 nlminb 包中的 Nelder-Mead 方法。


``` r
 out <- optim(par = rep(1/N, N), fn = obj,
 method = "L-BFGS-B", lower = lower, upper = upper)
 out$value
 out$message
 out <- nlminb(start =rep(1/N, N), objective = obj,
 lower = lower, upper = upper)
 out$objective
```

### 6.基于 DEoptim 的组合优化

与基于梯度的优化方法不同，DEoptim 函数会重复地查找优化问题的全局近似最小值。对于本文中这种复杂的组合，DEoptim 函数的表现极大地依赖于所选用的DE算法。

先看一下DEoptim的默认算法，即带固定参数的局部最优（local-to-best）策略。

如果目标函数在每150步迭代之后，两最优迭代之间的提升百分比低于 reltol=1e-6，我们就认为目标函数收敛。对于某些优化问题，DE算法要经过很多步迭代才收敛。这里，我们将最大迭代次数设定为5000。每完成250次迭代向屏幕输出一次结果。前面已经说过，用 rp 作为 DE 算法的初始群落。


``` r
 controlDE <- list(reltol=.000001,steptol=150, itermax = 5000,trace = 250,
 NP=as.numeric(nrow(rp)),initialpop=rp)
 set.seed(1234)
 start <- Sys.time()
 out <- DEoptim(fn = obj, lower = lower, upper = upper, control = controlDE)
```

```
Iteration: 250 bestvalit: 0.064652
Iteration: 500 bestvalit: 0.057199
Iteration: 750 bestvalit: 0.055774
Iteration: 1000 bestvalit: 0.055013
Iteration: 1250 bestvalit: 0.054581
Iteration: 1500 bestvalit: 0.054269
Iteration: 1750 bestvalit: 0.054146
Iteration: 2000 bestvalit: 0.054049
Iteration: 2250 bestvalit: 0.053706
Iteration: 2500 bestvalit: 0.053695
Iteration: 2750 bestvalit: 0.053351
Iteration: 3000 bestvalit: 0.053273
out$optim$iter
[1] 3055
 out$optim$bestval
[1] 0.05327273
end <- Sys.time()
end - start
Time difference of 16.03645 mins
```

在上面的5000次迭代中，带固定参数的局部最优策略得到的最优解优于前面提到的基于梯度的优化算法得到的结果。近来出现的JADE算法，对复杂优化问题具有更好地收敛特性。该算法糅合了局部最优策略和自适应参数控制策略。
