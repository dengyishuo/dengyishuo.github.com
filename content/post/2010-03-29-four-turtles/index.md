---
title: 四龟追逐问题
author: MatrixSpk
date: '2010-03-29'
slug: four-turtles
categories:
- R
tags:
- 四龟行走
- 模拟
- 追逐问题
---

四龟行走是一个很著名的论题，题目的大意是这样的：

> 在一个房间的四个角上，分别有一只乌龟。在某一个时刻t同时出发以匀速V走向顺时针方向的下一只乌龟，如果他们的方向始终对准目标，那么它们的运动轨迹是怎样的？

这道题目的解答方法至少有三个：

* 借助微分方程来解答，这是最正经的解法，但是也最没有意思，是"书虫"才干的出来的事情。
* 常理判断。由于四龟地位完全对称，而相邻两龟运动方向始终垂直，因此四龟轨迹对称且都是螺旋线。这是极其聪明的人才能干出的事情。
* 统计模拟方法。这个方法兼具艺术性和趣味性，而且不会远离群众，是有趣的人会干出的事情。

关于前两个这里一笔带过，第三个方法在薛毅很久之前的一本书《统计建模与R软件》是有提及过。怡轩说，这个统计模拟的例子于他有着特殊的意义。巧合的是，四龟行走也恰恰是我学习统计学的启蒙案例。也就是在见到这个例子的刹那，我才初次领悟了编程的景致之所在，也开始了对编程的敬仰之旅。

前段时间，在看自然图形时，突然发现自然界很多植物如“紫荆花”等等都有着类似四龟行走轨迹的花型。因此萌发妄想将它写成一个动画。我尽量避免使用复杂的数学语言来描述以上过程，因为我觉得数学语言尽管清晰有时候只会耽误大众对事情本质的理解。

下面是一段模拟四龟行走问题的R代码：


``` r
# 加载必要的包
library(ggplot2)
library(gganimate)

# 模拟参数设置
V <- 0.02       # 移动速度
dt <- 0.01      # 时间步长
total_time <- 5 # 总模拟时间
threshold <- 0.01 # 停止阈值

# 初始化四只乌龟的起始位置（正方形顶点）
turtles <- matrix(c(
  0.0, 1.0,   # 左上角乌龟1
  1.0, 1.0,   # 右上角乌龟2
  1.0, 0.0,   # 右下角乌龟3
  0.0, 0.0    # 左下角乌龟4
), ncol = 2, byrow = TRUE)

# 轨迹记录矩阵
history <- data.frame(
  turtle = integer(),
  time = numeric(),
  x = numeric(),
  y = numeric()
)

# 主循环模拟
current_time <- 0
while(current_time < total_time) {
  # 计算各乌龟的目标方向
  new_positions <- matrix(nrow = 4, ncol = 2)
  
  for(i in 1:4) {
    current_pos <- turtles[i, ]
    target_pos <- turtles[(i %% 4) + 1, ]
    
    # 计算方向向量并标准化
    direction <- target_pos - current_pos
    distance <- sqrt(sum(direction^2))
    
    if(distance < threshold) break  # 提前终止条件
    
    unit_direction <- direction / distance
    displacement <- V * dt * unit_direction
    
    new_positions[i, ] <- current_pos + displacement
  }
  
  # 记录当前时刻所有位置
  for(i in 1:4) {
    history <- rbind(history, data.frame(
      turtle = i,
      time = current_time,
      x = turtles[i, 1],
      y = turtles[i, 2]
    ))
  }
  
  # 同步更新所有乌龟位置
  turtles <- new_positions
  current_time <- current_time + dt
}

# 可视化静态轨迹
ggplot(history, aes(x, y, color = factor(turtle))) +
  geom_path(aes(group = turtle), linewidth = 0.8) +
  geom_point(data = subset(history, time == min(time)), 
             size = 4, shape = 19) +  # 起始点
  geom_point(data = subset(history, time == max(time)), 
             size = 4, shape = 4) +    # 终止点
  scale_color_manual(values = c("#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4")) +
  coord_fixed() +
  theme_minimal() +
  labs(title = "四龟追逐运动轨迹", color = "乌龟编号")

# 生成动态可视化（需要安装gganimate）
anim <- ggplot(history, aes(x, y, color = factor(turtle))) +
  geom_path(aes(group = turtle), alpha = 0.5) +
  geom_point(size = 3) +
  transition_reveal(time) +
  scale_color_manual(values = c("#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4")) +
  coord_fixed() +
  labs(title = '时间: {frame_along}', x = 'X坐标', y = 'Y坐标', color = '乌龟编号')

animate(anim, fps = 20, duration = total_time, width = 600, height = 600)
```
