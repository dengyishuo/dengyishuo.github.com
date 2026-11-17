---
title: 全天候动量ETF策略
author: MatrixSpk
date: '2025-12-23'
slug: all-weather-momentum
categories:
- 量化投资
tags:
  - 策略回测
  - ETF
---



```
## 正在从Yahoo Finance获取数据...
```

```
## [1] "513100.SS" "510300.SS" "518880.SS"
```

``` r
# 2. 计算指标：动量、波动率、调整动量
calculate_metrics <- function(price_series, window = 20) {
  # 计算日收益率
  returns <- dailyReturn(price_series, type = "arithmetic")
  colnames(returns) <- "Return"
  
  # 计算20日平均收益率（动量）
  momentum <- rollapply(returns, width = window, FUN = mean, align = "right", fill = NA)
  colnames(momentum) <- "Momentum"
  
  # 计算20日收益率方差（波动率）
  volatility <- rollapply(returns, width = window, FUN = var, align = "right", fill = NA)
  colnames(volatility) <- "Volatility"
  
  # 计算调整动量（动量/波动率）
  # 注意：使用标准差进行标准化（方差的平方根）
  adj_momentum <- momentum / sqrt(volatility)
  colnames(adj_momentum) <- "Adj_Momentum"
  
  return(list(returns = returns, 
              momentum = momentum, 
              volatility = volatility, 
              adj_momentum = adj_momentum))
}

# 为每个ETF计算指标
# cat("正在计算动量指标...\n")
metrics_list <- list()
for (etf in etf_names) {
  metrics_list[[etf]] <- calculate_metrics(price_df[, etf])
}
```

```
## Warning in to_period(xx, period = on.opts[[period]], ...): missing values
## removed from data
## Warning in to_period(xx, period = on.opts[[period]], ...): missing values
## removed from data
## Warning in to_period(xx, period = on.opts[[period]], ...): missing values
## removed from data
```

``` r
# 3. 生成交易信号和权重
generate_weights <- function(adj_momentum_df) {
  # 初始化权重数据框
  weights_df <- as.data.frame(adj_momentum_df)
  weights_df[] <- 0  # 所有值初始化为0
  
  # 对每一行（每个交易日）计算权重
  for (i in 1:nrow(adj_momentum_df)) {
    # 获取当日的调整动量值
    current_momentum <- as.numeric(adj_momentum_df[i, ])
    
    # 筛选调整动量大于0的标的
    positive_idx <- which(current_momentum > 0 & !is.na(current_momentum))
    
    if (length(positive_idx) > 0) {
      # 获取正的调整动量值
      positive_momentum <- current_momentum[positive_idx]
      
      # 按调整动量大小归一化计算权重
      normalized_weights <- positive_momentum / sum(positive_momentum)
      
      # 分配权重
      weights_df[i, positive_idx] <- normalized_weights
    }
  }
  
  # 转换为时间序列
  weights_xts <- xts(weights_df, order.by = index(adj_momentum_df))
  colnames(weights_xts) <- colnames(adj_momentum_df)
  
  return(weights_xts)
}

# 提取所有ETF的调整动量
adj_momentum_all <- do.call(merge, lapply(metrics_list, function(x) x$adj_momentum))
colnames(adj_momentum_all) <- etf_names

# 生成权重序列
# cat("正在计算每日权重...\n")
weights <- generate_weights(adj_momentum_all)

# 4. 将权重数据整理到数据框中
# 创建每日权重数据框（包含日期）
daily_weights_df <- data.frame(Date = index(weights))
for (etf in etf_names) {
  daily_weights_df[[etf]] <- as.numeric(weights[, etf])
}

# 计算每个交易日的权重合计（应为1或0）
daily_weights_df$权重合计 <- rowSums(daily_weights_df[, etf_names], na.rm = TRUE)

# 创建每个ETF的单独权重数据框
etf_weight_dfs <- list()
for (etf in etf_names) {
  etf_weight_dfs[[etf]] <- data.frame(
    Date = index(weights),
    ETF = etf,
    Weight = as.numeric(weights[, etf])
  )
}

# 合并所有ETF权重数据框
all_etf_weights_df <- do.call(rbind, etf_weight_dfs)

# 5. 回测计算
# 计算每个ETF的日收益率
returns_all <- do.call(merge, lapply(metrics_list, function(x) x$returns))
colnames(returns_all) <- etf_names

# 调整权重的时间索引，确保与收益率对齐
# 使用T日的权重在T+1日交易
lagged_weights <- lag(weights, 1)  # 权重滞后一天
lagged_weights <- lagged_weights[index(returns_all)]  # 对齐索引

# 处理缺失值
lagged_weights[is.na(lagged_weights)] <- 0

# 计算策略日收益率（按T+1日开盘价计算，这里用平均价近似）
strategy_returns <- rowSums(returns_all * lagged_weights, na.rm = TRUE)
strategy_returns <- xts(strategy_returns, order.by = index(returns_all))
colnames(strategy_returns) <- "动量策略"

# 6. 绩效指标计算
# cat("正在计算绩效指标...\n")
# 策略绩效
strategy_perf <- table.AnnualizedReturns(strategy_returns)
strategy_dd <- table.DownsideRisk(strategy_returns)
max_dd <- maxDrawdown(strategy_returns)
strategy_calmar <- CalmarRatio(strategy_returns)
strategy_sortino <- SortinoRatio(strategy_returns)
strategy_positive_returns <- sum(strategy_returns > 0, na.rm = TRUE)
strategy_total_returns <- sum(!is.na(strategy_returns))
strategy_win_rate <- strategy_positive_returns / strategy_total_returns

# 基准绩效（沪深300ETF）
benchmark_returns <- returns_all[, "沪深300ETF"]
colnames(benchmark_returns) <- "沪深300ETF"
benchmark_perf <- table.AnnualizedReturns(benchmark_returns)
benchmark_dd <- table.DownsideRisk(benchmark_returns)
benchmark_max_dd <- maxDrawdown(benchmark_returns)
benchmark_calmar <- CalmarRatio(benchmark_returns)
benchmark_sortino <- SortinoRatio(benchmark_returns)
benchmark_positive_returns <- sum(benchmark_returns > 0, na.rm = TRUE)
benchmark_total_returns <- sum(!is.na(benchmark_returns))
benchmark_win_rate <- benchmark_positive_returns / benchmark_total_returns

# 等权重组合绩效
equal_weights <- matrix(1/3, nrow = nrow(returns_all), ncol = ncol(returns_all))
equal_weights <- xts(equal_weights, order.by = index(returns_all))
colnames(equal_weights) <- etf_names
equal_returns <- rowSums(returns_all * equal_weights, na.rm = TRUE)
equal_returns <- xts(equal_returns, order.by = index(returns_all))
colnames(equal_returns) <- "等权重组合"
equal_perf <- table.AnnualizedReturns(equal_returns)
equal_max_dd <- maxDrawdown(equal_returns)
equal_calmar <- CalmarRatio(equal_returns)
equal_sortino <- SortinoRatio(equal_returns)
equal_positive_returns <- sum(equal_returns > 0, na.rm = TRUE)
equal_total_returns <- sum(!is.na(equal_returns))
equal_win_rate <- equal_positive_returns / equal_total_returns

# 7. 创建绩效指标汇总数据框
# 格式化日期字符串
start_date_str <- format(start_date, "%Y-%m-%d")
end_date_str <- format(end_date, "%Y-%m-%d")
period_str <- paste(start_date_str, "至", end_date_str)

performance_metrics_df <- data.frame(
  策略 = c("动量策略", "沪深300ETF", "等权重组合"),
  年化收益率 = c(
    round(strategy_perf[1, 1] * 100, 2),
    round(benchmark_perf[1, 1] * 100, 2),
    round(equal_perf[1, 1] * 100, 2)
  ),
  年化波动率 = c(
    round(strategy_perf[2, 1] * 100, 2),
    round(benchmark_perf[2, 1] * 100, 2),
    round(equal_perf[2, 1] * 100, 2)
  ),
  夏普比率 = c(
    round(strategy_perf[3, 1], 3),
    round(benchmark_perf[3, 1], 3),
    round(equal_perf[3, 1], 3)
  ),
  最大回撤 = c(
    round(max_dd * 100, 2),
    round(benchmark_max_dd * 100, 2),
    round(equal_max_dd * 100, 2)
  ),
  卡尔马比率 = c(
    round(strategy_calmar, 3),
    round(benchmark_calmar, 3),
    round(equal_calmar, 3)
  ),
  索提诺比率 = c(
    round(strategy_sortino, 3),
    round(benchmark_sortino, 3),
    round(equal_sortino, 3)
  ),
  胜率 = c(
    round(strategy_win_rate * 100, 2),
    round(benchmark_win_rate * 100, 2),
    round(equal_win_rate * 100, 2)
  ),
  正收益天数 = c(
    strategy_positive_returns,
    benchmark_positive_returns,
    equal_positive_returns
  ),
  总交易天数 = c(
    strategy_total_returns,
    benchmark_total_returns,
    equal_total_returns
  ),
  回测期间 = c(period_str, period_str, period_str)
)

# 8. 绩效指标输出
# cat("==================== 绩效指标汇总数据框 ====================\n\n")
print(performance_metrics_df)
```

```
##         策略 年化收益率 年化波动率 夏普比率 最大回撤 卡尔马比率 索提诺比率
## 1   动量策略      45.13      17.08    2.643     8.72      5.178      0.227
## 2 沪深300ETF      20.31      19.27    1.054    16.25      1.250      0.103
## 3 等权重组合      31.84      12.89    2.470     9.29      3.429      0.201
##    胜率 正收益天数 总交易天数                 回测期间
## 1 53.04        253        477 2024-01-01 至 2025-12-23
## 2 51.26        244        476 2024-01-01 至 2025-12-23
## 3 59.33        283        477 2024-01-01 至 2025-12-23
```

``` r
# cat("\n")

# 9. 输出权重数据

# cat("每日组合权重数据框（后10行）:\n")
print(tail(daily_weights_df, 10))
```

```
##           Date    纳指ETF 沪深300ETF   黄金ETF 权重合计
## 468 2025-12-08 0.09379501 0.00000000 0.9062050        1
## 469 2025-12-09 0.00000000 0.00000000 0.0000000        0
## 470 2025-12-10 0.00000000 0.00000000 1.0000000        1
## 471 2025-12-11 0.00000000 0.00000000 0.0000000        0
## 472 2025-12-12 0.05889600 0.00000000 0.9411040        1
## 473 2025-12-15 0.00000000 0.00000000 1.0000000        1
## 474 2025-12-16 0.16844695 0.00000000 0.8315530        1
## 475 2025-12-17 0.31823928 0.01791372 0.6638470        1
## 476 2025-12-18 0.00000000 0.00000000 1.0000000        1
## 477 2025-12-19 0.22970999 0.26353990 0.5067501        1
```

``` r
# cat("\n")


# 10. 绘制图表
# cat("正在生成图表...\n")
# 准备累计收益率数据
cumulative_returns <- merge(
  cumprod(1 + na.fill(strategy_returns, 0)) - 1,
  cumprod(1 + na.fill(benchmark_returns, 0)) - 1,
  cumprod(1 + na.fill(equal_returns, 0)) - 1
)
colnames(cumulative_returns) <- c("动量策略", "沪深300ETF", "等权重组合")

# 转换为数据框用于ggplot
cumulative_df <- data.frame(
  Date = index(cumulative_returns),
  as.data.frame(cumulative_returns)
)
cumulative_long <- pivot_longer(cumulative_df, 
                                cols = -Date, 
                                names_to = "Portfolio", 
                                values_to = "CumulativeReturn")

# 图表1：策略 vs 基准累计收益率和最大回撤对比
p1 <- ggplot(cumulative_long %>% filter(Portfolio %in% c("动量策略", "沪深300ETF")), 
             aes(x = Date, y = CumulativeReturn, color = Portfolio)) +
  geom_line(size = 1.2) +
  labs(title = "动量策略 vs 沪深300ETF: 累计收益率对比",
       x = "日期", y = "累计收益率") +
  scale_y_continuous(labels = percent_format()) +
  scale_color_manual(values = c("动量策略" = "blue", "沪深300ETF" = "red")) +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
```

```
## Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
## ℹ Please use `linewidth` instead.
## This warning is displayed once every 8 hours.
## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
## generated.
```

``` r
# 图表2：策略 vs 各ETF Buy & Hold对比
# 计算各ETF的累计收益率
etf_cumulative <- do.call(merge, 
                          lapply(1:length(etf_names), 
                                 function(i) cumprod(1 + na.fill(returns_all[, i], 0)) - 1))
colnames(etf_cumulative) <- paste0(etf_names, " (Buy&Hold)")

all_cumulative <- merge(cumulative_returns[, "动量策略"], etf_cumulative)
all_cumulative_df <- data.frame(Date = index(all_cumulative), 
                                as.data.frame(all_cumulative))
all_cumulative_long <- pivot_longer(all_cumulative_df, 
                                    cols = -Date, 
                                    names_to = "Strategy", 
                                    values_to = "CumulativeReturn")

p2 <- ggplot(all_cumulative_long, aes(x = Date, y = CumulativeReturn, color = Strategy)) +
  geom_line(size = 1) +
  labs(title = "动量策略 vs 各ETF买入持有策略: 累计收益率对比",
       x = "日期", y = "累计收益率") +
  scale_y_continuous(labels = percent_format()) +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

# 图表3：策略 vs 等权重组合对比
p3 <- ggplot(cumulative_long %>% filter(Portfolio %in% c("动量策略", "等权重组合")), 
             aes(x = Date, y = CumulativeReturn, color = Portfolio)) +
  geom_line(size = 1.2) +
  labs(title = "动量策略 vs 等权重组合: 累计收益率对比",
       x = "日期", y = "累计收益率") +
  scale_y_continuous(labels = percent_format()) +
  scale_color_manual(values = c("动量策略" = "blue", "等权重组合" = "green")) +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

# 图表4：权重随时间变化图
# 准备权重数据
weights_long <- pivot_longer(daily_weights_df, 
                             cols = all_of(etf_names),
                             names_to = "ETF", 
                             values_to = "Weight")

p4 <- ggplot(weights_long, aes(x = Date, y = Weight, fill = ETF)) +
  geom_area(position = "stack", alpha = 0.7) +
  labs(title = "动量策略: 每日权重分配",
       x = "日期", y = "权重") +
  scale_y_continuous(labels = percent_format()) +
  scale_fill_manual(values = c("纳指ETF" = "blue", 
                               "沪深300ETF" = "red", 
                               "黄金ETF" = "gold")) +
  theme_minimal() +
  theme(legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))
```

``` r
# 12. 显示图表
# cat("\n正在显示图表...\n")
print(p1)
```

<p><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" /></p>

``` r
# cat("\n\n")
```

``` r
print(p2)
```

<p><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" /></p>

``` r
# cat("\n\n")
```

``` r
print(p3)
```

<p><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672" /></p>

``` r
# cat("\n\n")
```

``` r
print(p4)
```

<p><img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" /></p>
