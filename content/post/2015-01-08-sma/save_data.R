# 保存数据
# 遍历所有符号
for (symbol in stock.str) {
  # 检查对象是否存在
  if (exists(symbol)) {
    # 生成文件名
    file_name <- paste0(symbol, ".rds")
    # 保存为RDS文件
    saveRDS(get(symbol), file = file_name)
    # 打印保存信息
    message("已保存: ", symbol, " -> ", file_name)
  } else {
    warning("对象 ", symbol, " 不存在")
  }
}
