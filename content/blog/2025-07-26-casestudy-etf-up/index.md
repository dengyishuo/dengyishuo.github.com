---
title: 如何根据事件研究来推测市场上涨幅度
author: MatrixSpk
date: '2025-07-26'
slug: casestudy-etf-up
categories:
- 经济学
tags:
  - 策略回测
  - ETF
---



<p>先获取稀土ETF（代码为516780）的历史行情数据：</p>

``` r
library(quantmod)
XT <- getSymbols("516780.ss", src = "yahoo", auto.assign = FALSE)
# 获取子集数据
XT <- round(XT["2025::"],2)
```

<p>绘制蜡烛图：</p>

``` r
chartSeries(XT, theme = "white")
```

<p><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" /></p>
<p>下面标记重大事件。包括：</p>
<ul>
<li>2025年3月，份政府工作报告中提及要“整治行业内卷式竞争”。</li>
<li>2025年6月17日，全国人大公布修订后的《反不正当竞争法》。</li>
<li>2025年7月1日，中央财经委员会第七次会议公布要治理企业低价无序竞争。</li>
<li>2025年7月9日，工信部召开企业公平竞争座谈会。</li>
</ul>
<p>在图上标记重大事件：</p>

``` r
# 定义事件日期
event_dates <- as.Date(c("2025-03-07", 
                         "2025-06-27",
                         "2025-07-01",
                         "2025-07-09")
                       )

# 计算事件日期在子集中的相对索引
event_index <- numeric(length(event_dates))
for (i in seq_along(event_dates)) {
  event_index[i] <- which(index(XT) == event_dates[i])
}

# 添加标记点
addPoints(
  x = event_index,
  y = Ad(XT[event_dates]),
  col = "blue",
  pch = 24
)
```

<p><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" /></p>

``` r
library(qmao)
addVLine(index(XT[c("2025-03-05::2025-03-12",
                    "2025-06-17::2025-06-30",
                    "2025-07-01::2025-07-25")
                  ]),
         col = "lightblue",
         border = "lightblue")
```

<p><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-2.png" width="672" /></p>
