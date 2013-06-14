% supstat系列资料（2）：
% \href{mailto:yishuo.deng@gmail.com}{邓一硕}
% April 14, 2013

```{r setup, include = FALSE, tidy = TRUE}
opts_chunk$set(dev='pdf', fig.width=3, fig.height=3, fig.align = 'center', cache = F, warning = T, error = T) 
```

#### TTR简介？
 * 功能众多
   * 超过50个技术分析指标
   * 多个支撑函数
 * 灵活
   * 修改传统的指标计算方式
   * 自动适应多种时序格式
 * 高性能
   * 许多编译类函数
   * 可处理高频数据
   
#### 功能众多

移动平均|震荡指标|波动率指标|趋势检测/强度|交易量指标|其它指标
--------|--------|----------|-------------|----------|--------
简单移动平均|MACD指标|Garman-klass波动率[1]|阿隆指标|平均交易量指数|布林带指标
指数移动平均|随机指数|Parkinson波动率[2]|顺势指标|资金流量指数|抛物转向指标
加权移动平均/VWAP|相对强弱指标|Rogers-Satchell波动率|十字过滤线指标|Chaikin货币流量指数|zig-zag指标
零延迟移动平均|TRIX指标|平均真实波动范围|趋势检测指标|Chaikin累积派发指标|关闭位置指标
交易量加权移动平均|随机动量指标|收盘价格波动率|平均趋向指数|William累积派发指标|拆股分红调整

#### 灵活-变更计算方法

```{r}
###默认RSI指标
rsi <- RSI(price, n=14)
###经加权成交量调整后的RSI指标
rsi <- RSI(price, n=14, maType="WMA", wts=volume)
###经不同的向上/向下移动平均调整后的RSI指标
rsi <- RSI( price, maType=list(
maUp=list(EMA,n=14,ratio=1/5),
maDown=list(WMA,n=16,wts=1:16)) )
```

#### 灵活-多种时序格式

TTR可以处理：

* zoo / xts
* timeSeries
* ts
* its
* irts
* fts
* data.frame
* matrix

```{r}
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

#### 高性能

```{r}
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

看看处理大数据时候的性能

```{r}
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

#### 改进方向

* 纳入更多指标
* 处理不规则时序数据
* 其它...

#### TTR下载地址

http://ttr.r-forge.r-project.org/

#### 参考资料

Joshua M. Ulrich.[2010].Fast and Flexible Technical Analysis with TTR

--------
[1]基于Garman-klass方程计算的波动率。

[2]Parkinson (1980)认为金融资产价格在一个时间段内的最高价格和最低价格之差，是衡量价格在这个时间段内波动幅度的良好指标。
