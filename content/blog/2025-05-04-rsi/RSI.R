# ======================================================
# 量化交易策略框架搭建（基于quantstrat包）
# 策略逻辑：基于RSI指标的双向交易系统
# 核心流程：环境初始化 -> 策略定义 -> 数据准备 -> 回测执行
# ======================================================

# ---------------------------
# 1. 包加载与环境清理
# ---------------------------
# 安装必要包（已注释，按需启用）
# install.packages("devtools") 
# install.packages("FinancialInstrument") 
# install.packages("PerformanceAnalytics") 
# devtools::install_github("braverock/blotter")
# devtools::install_github("braverock/quantstrat")

# 加载量化策略包
require(quantstrat)

# 清理历史策略数据（避免残留数据干扰）
suppressWarnings(rm("order_book.RSI",pos=.strategy))
suppressWarnings(rm("account.RSI","portfolio.RSI",pos=.blotter))
suppressWarnings(rm("account.st",
                    "portfolio.st",
                    "stock.str",
                    "stratRSI",
                    "initDate",
                    "initEq",
                    'start_t',
                    'end_t'
)
)

# ---------------------------
# 2. 策略主体构建
# ---------------------------
# 创建策略容器
stratRSI <- strategy("RSI")
n=2  # 参数示例

# 2.1 添加技术指标
# 使用经典RSI指标（默认周期14）
stratRSI <- add.indicator(
  strategy = stratRSI, 
  name = "RSI",    # 内置RSI函数
  arguments = list(price = quote(getPrice(mktdata))), # 获取价格数据
  label = "RSI"
)


# 2.2 定义交易信号
# 信号1：RSI上穿70（超买信号）
stratRSI <- add.signal(
  strategy = stratRSI, 
  name = "sigThreshold",
  arguments = list(
    threshold = 70,
    column = "RSI",
    relationship = "gt",  # greater than
    cross = TRUE          # 要求穿越阈值
  ),
  label = "RSI.gt.70"
)

# 信号2：RSI下穿30（超卖信号）
stratRSI <- add.signal(
  strategy = stratRSI, 
  name = "sigThreshold",
  arguments = list(
    threshold = 30,
    column = "RSI",
    relationship = "lt",  # less than
    cross = TRUE
  ),
  label = "RSI.lt.30"
)

# 两个规则
## 我们使用osMaxPos函数来分层建仓，或达到最大持仓限制

# 第一条规则：当RSI上穿阈值时卖出
stratRSI <- add.rule(strategy = stratRSI, 
                     name='ruleSignal', 
                     arguments = list(sigcol="RSI.gt.70", 
                                      sigval=TRUE, 
                                      orderqty=-1000, 
                                      ordertype='market', 
                                      orderside='short', 
                                      pricemethod='market', 
                                      replace=FALSE, 
                                      osFUN=osMaxPos), 
                     type='enter', 
                     path.dep=TRUE)

stratRSI <- add.rule(strategy = stratRSI, 
                     name='ruleSignal', 
                     arguments = list(sigcol="RSI.lt.30", 
                                      sigval=TRUE, 
                                      orderqty='all', 
                                      ordertype='market', 
                                      orderside='short', 
                                      pricemethod='market', 
                                      replace=FALSE), 
                     type='exit', 
                     path.dep=TRUE)

# 第二条规则：当RSI下穿阈值时买入
stratRSI <- add.rule(strategy = stratRSI, 
                     name='ruleSignal', 
                     arguments = list(sigcol="RSI.lt.30", 
                                      sigval=TRUE, 
                                      orderqty= 1000, 
                                      ordertype='market', 
                                      orderside='long', 
                                      pricemethod='market', 
                                      replace=FALSE, 
                                      osFUN=osMaxPos), 
                     type='enter', 
                     path.dep=TRUE)

stratRSI <- add.rule(strategy = stratRSI, 
                     name='ruleSignal', 
                     arguments = list(sigcol="RSI.gt.70", 
                                      sigval=TRUE, 
                                      orderqty='all', 
                                      ordertype='market', 
                                      orderside='long', 
                                      pricemethod='market', 
                                      replace=FALSE), 
                     type='exit', # 2.3 设置交易规则
                     # 规则组1：做空规则
                     # 入场规则：RSI>70时建立空头仓位
                     stratRSI <- add.rule(
                       strategy = stratRSI, 
                       name = 'ruleSignal',
                       arguments = list(
                         sigcol = "RSI.gt.70",   # 触发信号列
                         sigval = TRUE,          # 信号有效值
                         orderqty = -1000,       # 卖出数量
                         ordertype = 'market',   # 市价单
                         orderside = 'short',    # 空头方向
                         pricemethod = 'market',
                         replace = FALSE,        # 不替换现有订单
                         osFUN = osMaxPos        # 使用最大仓位函数
                       ), 
                       type = 'enter',           # 入场规则
                       path.dep = TRUE           # 路径依赖
                     )
                     
                     # 离场规则：RSI<30时平空仓
                     stratRSI <- add.rule(
                       strategy = stratRSI,
                       name = 'ruleSignal',
                       arguments = list(
                         sigcol = "RSI.lt.30",
                         sigval = TRUE,
                         orderqty = 'all',       # 平掉全部仓位
                         ordertype = 'market',
                         orderside = 'short',
                         pricemethod = 'market',
                         replace = FALSE
                       ),
                       type = 'exit',
                       path.dep = TRUE
                     )
                     
                     # 规则组2：做多规则
                     # 入场规则：RSI<30时建立多头仓位
                     stratRSI <- add.rule(
                       strategy = stratRSI,
                       name = 'ruleSignal',
                       arguments = list(
                         sigcol = "RSI.lt.30",
                         sigval = TRUE,
                         orderqty = 1000,        # 买入数量
                         ordertype = 'market',
                         orderside = 'long',     # 多头方向
                         pricemethod = 'market',
                         replace = FALSE,
                         osFUN = osMaxPos
                       ),
                       type = 'enter',
                       path.dep = TRUE
                     )
                     
                     # 离场规则：RSI>70时平多仓
                     stratRSI <- add.rule(
                       strategy = stratRSI,
                       name = 'ruleSignal',
                       arguments = list(
                         sigcol = "RSI.gt.70",
                         sigval = TRUE,
                         orderqty = 'all',
                         ordertype = 'market',
                         orderside = 'long',
                         pricemethod = 'market',
                         replace = FALSE
                       ),
                       type = 'exit',
                       path.dep = TRUE
                     )
                     
                     # ---------------------------
                     # 3. 市场数据准备
                     # ---------------------------
                     # 设置基础货币
                     
                     currency("USD")
                     currency("EUR")
                     # 定义交易标的（美国行业ETF）
                     symbols = c("XLF", "XLP", "XLE", "XLY", "XLV", "XLI", "XLB", "XLK", "XLU")
                     # 初始化交易品种数据
                     for(symbol in symbols){ 
                       # 注册金融工具
                       stock(symbol, currency="USD",multiplier=1)
                       # 下载历史数据（默认从Yahoo Finance）
                       getSymbols(symbol)
                     }
                     
                     # 保存数据
                     # 遍历所有符号
                     #for (symbol in symbols) {
                     #  # 检查对象是否存在
                     #  if (exists(symbol)) {
                     #    # 生成文件名
                     #    file_name <- paste0(symbol, ".rds")
                     #    # 保存为RDS文件
                     #    saveRDS(get(symbol), file = file_name)
                     #    # 打印保存信息
                     #    message("已保存: ", symbol, " -> ", file_name)
                     #  } else {
                     #    warning("对象 ", symbol, " 不存在")
                     #  }
                     #}
                     
                     # 可以用类似以下方式测试：
                     # applySignals(strategy=stratRSI, mktdata=applyIndicators(strategy=stratRSI, mktdata=symbols[1]))
                     
                     ##### 在此放置演示和测试日期 #################
                     #
                     #if(isTRUE(options('in_test')$in_test))
                     #  # 使用测试日期
                     #  {initDate="2000-01-01" 
                     #  endDate="2024-12-31"   
                     #  } else
                     #  # 使用演示默认值
                     #  {initDate="2000-01-01"
                     #  endDate=Sys.Date()}
                     
                     # ---------------------------
                     # 4. 回测系统初始化
                     # ---------------------------
                     # 设置回测参数
                     initDate = '2000-01-01'  # 初始化日期
                     initEq = 100000          # 初始资金（美元）
                     port.st = 'RSI'          # 组合名称
                     
                     # 初始化投资组合
                     initPortf(port.st, 
                               symbols=symbols, 
                               initDate=initDate)
                     # 初始化账户
                     initAcct(port.st, 
                              portfolios=port.st, 
                              initDate=initDate,
                              initEq=initEq)
                     # 初始化订单簿
                     initOrders(portfolio=port.st, 
                                initDate=initDate)
                     
                     # 设置仓位限制（每个品种最大300股，最多3个品种）
                     for(symbol in symbols){ 
                       addPosLimit(port.st, 
                                   symbol, 
                                   initDate, 
                                   300, 
                                   3 ) 
                     } 
                     
                     print("初始化完成")
                     
                     # ---------------------------
                     # 5. 策略回测执行
                     # ---------------------------
                     # 执行策略应用
                     start_t<-Sys.time()
                     out<-try(
                       applyStrategy(strategy=stratRSI , 
                                     portfolios=port.st,
                                     parameters=list(n=2) # 可传入策略参数
                       ) 
                     )
                     end_t<-Sys.time()
                     print("策略循环耗时:")
                     print(end_t-start_t)
                     
                     # 查看订单簿
                     #print(getOrderBook(port.st))
                     
                     start_t<-Sys.time()
                     # 更新组合净值
                     updatePortf(Portfolio=port.st,Dates=paste('::',as.Date(Sys.time()),sep=''))
                     end_t<-Sys.time()
                     print("更新交易账簿耗时:")
                     print(end_t-start_t)
                     
                     # 临时修改quantmod图形参数（后期需移除）
                     themelist<-chart_theme()
                     themelist$col$up.col<-'lightgreen'
                     themelist$col$dn.col<-'pink'
                     
                     for(symbol in symbols){
                       # dev.new()
                       chart.Posn(Portfolio=port.st,Symbol=symbol,theme=themelist)  # 绘制持仓图
                       plot(add_RSI(n=2))
                       print(paste0(symbol,"仓位图"))
                     }
                     
                     # 统计组合表现
                     ret1 <- PortfReturns(port.st)
                     ret1$total <- rowSums(ret1)
                     
                     
                     if("package:PerformanceAnalytics" %in% search() || require("PerformanceAnalytics",quietly=TRUE)) {
                       dev.new()
                       # 绘制收益率图
                       charts.PerformanceSummary(ret1$total,geometric=FALSE,wealth.index=TRUE)
                       print("策略总体表现")
                     }
                     
                     
                     
                     ##### 查看交易统计信息 #########################################
                     # 查看交易单据
                     book  = getOrderBook(port.st)
                     # 查看交易统计
                     stats = tradeStats(port.st)
                     # 查看组合收益率
                     rets  = PortfReturns(port.st)
                     ################################################################