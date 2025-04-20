---
layout: post
title: 说说风险均摊投资组合的构建方法
comments: true
categories:
- life
tags:
- 风险均摊
- 投资组合
- R
---


### 引子

构建股票投资组合时，在筛选出备选股票之后，要解决的另外一个问题是确定备选股票在投资组合中的权重。我们可以用一个向量来表示：

$$ w=\( w_1,w_2,...,w_n \) $$

其中，$ \sum\_{i=1}^nw\_{i}=1,i=1,2,...,n $。

显然，权重的可选集是个无限集合。如果想选取其中一个作为最优权重，那得先确定一个判断最优与否的方法。耳熟能详的方法自然是收益-风险法，即如果一个权重能够使投资组合的收益最大、风险最小，那么，它就是好的。如果用标准差来刻画风险的话，就有下面的评价函数:

$$ U(R,\sigma) $$

其中，$ \frac{\partial U(\cdot )}{\partial R} > 0 $，$ \frac{\partial U(\cdot )}{\partial \sigma} < 0 $。

$ U(\cdot) $最简单的形式如下：

$$
U_p = aR_{p} + b \sigma \_{p}
$$

其中，$ a > 0 $，$ b < 0 $；$ R_{p} $是组合的收益率，$ \sigma \_{p} $是组合的标准差。显然：

$$ 
R_{p} = w'R 
$$

$$
\sigma \_p = w'Cw
$$

其中，$ R=(R_1,R_2,...,R_n) $是组合中各证券的收益率，$ C $是组合中各证券的收益率的协方差矩阵。

把$ R_{p} $和$ \sigma \_p $带入$ U_p $，解出令$ U_p $最小的$ w $即可。

当然，也有其它理念。比如下面要说的风险均摊。风险均摊是指选出来这样一个权重，使得其确定的投资组合中各个证券的风险占证券投资总的风险的比例是相同的。有些拗口，直接看下面的公式。

### 风险均摊的理论基础及公式

由前面的公式可知：

$$
\sigma_p = wCw’=wC \times (w_1,w_2,...,w_n)'=\sum\_{i=1}^n wC\_{\cdot i}w_i
$$

上面可以看到证券组合的风险相当于是$ wC\_{\cdot i} $的加权组合，权重是$ w=(w_1,w_2,...,w_n) $。所谓风险均摊，就是令$ wC\_{\cdot i}w_i=wC\_{\cdot j}w_j $。显然，确定一个权重$ w $使得证券组合的风险得以均摊等同于找到一个权重$ w $使得下式最小：

$$
\sum\_{j=1}^n \sum\_{i=1}^n \left[ wC\_{\cdot i}w_i-wC\_{\cdot j}w_j \right]\^2
$$

这是一个比较简单的优化问题，在 R 软件里面很容易得到结果。

### 用 R 实现风险均摊优化器

{% highlight r %}

# 模拟获取数据
require(quantmod);
x=getSymbols("000635.sz",from="2013-01-01",auto.assign=FALSE)
y=getSymbols("000547.sz",from="2013-01-01",auto.assign=FALSE)
z=getSymbols("600241.ss",from="2013-01-01",auto.assign=FALSE)
ret_mat <- cbind(dailyReturn(x),dailyReturn(y),dailyReturn(z))
ret_mat <- na.omit(ret_mat)

# 定义目标函数

ff <- function(w,ret_mat){
   cov_mat <- cov(ret_mat);
   w=c(w,1-sum(w));
   len <- length(w);
   w_mat <- matrix(rep(w,time=len),nr=len,byrow=TRUE);
   diag_mat <- diag(w);
   res <- 2*len*as.vector(t(diag(w_mat%*%cov_mat%*%diag_mat))%*%diag(w_mat%*%cov_mat%*%diag_mat))-2*(sum  (diag(w_mat%*%cov_mat%*%diag_mat)))^2;
   return(res);
 } 
 
# 优化目标函数

w <- optim(c(0.3,0.3),ff,ret_mat=ret_mat)$par;

# 查看权重

w=c(w,1-sum(w));
w = c(w,1-w[1]-w[2])

{% endhighlight %}


