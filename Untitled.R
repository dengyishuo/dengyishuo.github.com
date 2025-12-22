# 加载必要的包
library(quantmod)
library(PerformanceAnalytics)
library(tidyverse)
library(lubridate)

# 获取沪深300指数数据（从2005年开始）
getSymbols("000300.SS", from = "2005-01-01", src = "yahoo")

# 提取收盘价数据
hs300_prices <- Cl(`000300.SS`)

# 计算日收益率
hs300_returns <- dailyReturn(hs300_prices)

# 转换为数据框格式
returns_df <- data.frame(
  date = index(hs300_returns),
  return = as.numeric(hs300_returns)
)

# 定义计算滚动收益的函数
calculate_rolling_returns <- function(returns, years) {
  # 转换为年化交易日数（约252天）
  periods <- years * 252
  
  # 计算滚动累计收益
  rolling_cumreturns <- rollapply(returns, 
                                  width = periods, 
                                  FUN = function(x) prod(1 + x) - 1,
                                  fill = NA,
                                  align = "left")
  
  # 计算年化收益率
  rolling_annualized <- rollapply(returns,
                                  width = periods,
                                  FUN = function(x) {
                                    total_return <- prod(1 + x) - 1
                                    annualized_return <- (1 + total_return)^(1/years) - 1
                                    return(annualized_return)
                                  },
                                  fill = NA,
                                  align = "left")
  
  return(list(cumulative = rolling_cumreturns, 
              annualized = rolling_annualized))
}

# 计算不同持有周期的滚动收益
holding_periods <- c(1, 2, 3, 5, 10)
results <- list()

for (period in holding_periods) {
  cat(sprintf("计算 %d 年持有期滚动收益...\n", period))
  results[[as.character(period)]] <- calculate_rolling_returns(returns_df$return, period)
}

# 创建结果数据框
create_results_df <- function(results, returns_df) {
  result_list <- list()
  
  for (period in names(results)) {
    temp_df <- data.frame(
      date = returns_df$date[1:length(results[[period]]$cumulative)],
      holding_period = as.numeric(period),
      cumulative_return = as.numeric(results[[period]]$cumulative),
      annualized_return = as.numeric(results[[period]]$annualized)
    )
    result_list[[period]] <- na.omit(temp_df)
  }
  
  bind_rows(result_list)
}

# 生成最终结果
final_results <- create_results_df(results, returns_df)

# 查看结果摘要
cat("\n各持有期收益统计摘要:\n")
final_results %>%
  group_by(holding_period) %>%
  summarise(
    observations = n(),
    mean_cumulative = mean(cumulative_return, na.rm = TRUE),
    median_cumulative = median(cumulative_return, na.rm = TRUE),
    mean_annualized = mean(annualized_return, na.rm = TRUE),
    median_annualized = median(annualized_return, na.rm = TRUE),
    min_annualized = min(annualized_return, na.rm = TRUE),
    max_annualized = max(annualized_return, na.rm = TRUE)
  ) %>%
  print(n = Inf)

# 可视化结果
ggplot(final_results, aes(x = date, y = annualized_return, color = as.factor(holding_period))) +
  geom_line(alpha = 0.7) +
  labs(title = "沪深300指数不同持有期滚动年化收益率",
       x = "日期", 
       y = "年化收益率",
       color = "持有期(年)") +
  theme_minimal() +
  scale_y_continuous(labels = scales::percent)

# 绘制分布图
ggplot(final_results, aes(x = annualized_return, fill = as.factor(holding_period))) +
  geom_density(alpha = 0.5) +
  labs(title = "不同持有期年化收益率分布",
       x = "年化收益率",
       y = "密度",
       fill = "持有期(年)") +
  theme_minimal() +
  scale_x_continuous(labels = scales::percent) +
  facet_wrap(~holding_period, scales = "free_y")

# 查看最近一个滚动期的收益
cat("\n最近一个滚动期收益:\n")
final_results %>%
  group_by(holding_period) %>%
  filter(date == max(date)) %>%
  select(holding_period, date, cumulative_return, annualized_return) %>%
  print(n = Inf)