% SupStat系列资料（2）：基于TTR包的技术分析
% \href{http://weibo.com/dengyishuo}{@邓一硕}
% April 14, 2013


## TTR简介？
 * 功能众多
   * 超过50个技术分析指标
   * 多个支撑函数
 * 灵活
   * 修改传统的指标计算方式
   * 自动适应多种时序格式
 * 高性能
   * 许多编译类函数
   * 可处理高频数据
   
## 功能众多

\includegraphics[width=\textwidth]{table.png}


[1]基于Garman-klass方程计算的波动率。

[2] Parkinson (1980)认为金融资产价格在一个时间段内的最高价格和最低价格之差，是衡量价格在这个时间段内波动幅度的良好指标。


## 灵活-变更计算方法

```r
###默认RSI指标
rsi <- RSI(price, n=14)
###经加权成交量调整后的RSI指标
rsi <- RSI(price, n=14, maType="WMA", wts=volume)
###经不同的向上/向下移动平均调整后的RSI指标
rsi <- RSI( price, maType=list(
maUp=list(EMA,n=14,ratio=1/5),
maDown=list(WMA,n=16,wts=1:16)) )
```

## 灵活-多种时序格式

TTR可以处理：

* zoo / xts
* timeSeries
* ts
* its
* irts
* fts
* data.frame
* matrix

##

```r
> data(ttrc)
> x <- xts(ttrc[,-1],ttrc[,1])
> class(RSI(Cl(x),2))
[1] "xts" "zoo"
> class(RSI(as.timeSeries(Cl(x)),2))
[1] "timeSeries"
attr(,"package")
[1] "timeSeries"
> class(RSI(as.zoo(Cl(x)),2))
[1] "zoo"
```

## 高性能

```r
# 看看TTR包中最慢的编译函数
> # 抛物线止损翻转指标
> data(ttrc) # 5550个观测值
> # 普通R代码
> system.time({s <- sar(ttrc[,c('High','Low')])})
user system elapsed
1.060 0.088 1.980
> # C
> system.time({S <- SAR(ttrc[,c('High','Low')])})
user system elapsed
0.004 0.000 0.006
```

## 

看看处理大数据时候的性能


```r
> # P抛物线止损翻转指标，600万个观测值
> x <- .xts(cumprod(1+rnorm(6e6)/1e5),1:6e6)
> x <- merge(Low=x,High=x*(1+runif(6e6)/100))
>
> # 普通R代码
> system.time({s <- sar(x[,c('High','Low')])})
# still waiting for this to finish...
> # C
> system.time({S <- SAR(x[,c('High','Low')])})
user system elapsed
1.584 1.332 2.919
```

## 改进方向

* 纳入更多指标
* 处理不规则时序数据
* 其它...

## TTR下载地址

http://ttr.r-forge.r-project.org/

## 参考资料

Joshua M. Ulrich.[2010].Fast and Flexible Technical Analysis with TTR


