# 安装所需的包（如果尚未安装）
if (!require("sf")) install.packages("sf")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("dplyr")) install.packages("dplyr")

# 加载所需的库
library(sf)
library(ggplot2)
library(dplyr)

# 读取北京地图数据（请确保beijing.json文件在正确路径下）
beijing_map <- st_read("assets/data/beijing.json", quiet = TRUE)

# 创建寺庙数据框（包含名称和经纬度坐标）
temples <- data.frame(
  name = c(
    "雍和宫", "五塔寺", "西黄寺", "天宁寺", "智化寺",
    "广化寺", "广济寺", "通教寺", "法源寺", "卧佛寺"
  ),
  longitude = c(
    116.4070, 116.3197, 116.3936, 116.3213, 116.4350,
    116.3647, 116.3710, 116.4243, 116.3913, 116.2731
  ),
  latitude = c(
    39.9486, 39.9592, 39.9685, 39.8987, 39.9197,
    39.9463, 39.9213, 39.9417, 39.8947, 39.9992
  )
)

# 将寺庙数据转换为sf对象
temples_sf <- st_as_sf(temples,
  coords = c("longitude", "latitude"),
  crs = st_crs(beijing_map)
)

# 绘制北京地图并标记寺庙
ggplot() +
  geom_sf(data = beijing_map, fill = "lightgray", color = "gray50") +
  geom_sf(data = temples_sf, color = "red", size = 3) +
  geom_sf_text(
    data = temples_sf, aes(label = name),
    color = "darkred", size = 3, nudge_y = 0.02
  ) +
  ggtitle("北京五环内寺庙分布图") +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text = element_text(size = 8)
  ) +
  coord_sf()

# 如果需要保存地图
# ggsave("beijing_temples_map.png", width = 10, height = 8, dpi = 300)
