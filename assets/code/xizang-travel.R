# 加载必要的包
library(sf) # 处理地理空间数据
library(ggplot2) # 绘图
library(ggrepel) # 避免标签重叠
library(dplyr) # 数据处理
library(here) # 自动引用数据
library(patchwork) # 组合图形
library(showtext) # 中文字体支持

# 设置中文字体（根据系统调整字体名称）
font_add("simhei", "SimHei.ttf") # Windows系统
# font_add("simhei", "/System/Library/Fonts/PingFang.ttc")  # Mac系统备选
showtext_auto()

# 读取西藏地图数据
tryCatch(
  {
    tibet_map <- st_read(here("assets/data/xizang.json"), quiet = TRUE)
    if (nrow(tibet_map) == 0) stop("JSON文件不包含地理数据")
  },
  error = function(e) {
    stop(paste("无法读取或解析xizang.json:", e$message))
  }
)

# 创建著名景点数据集（先保留lat和lng列，后续再转换为sf对象）
scenic_spots_df <- data.frame(
  name = c(
    "布达拉宫", "大昭寺", "纳木错", "珠穆朗玛峰", "扎什伦布寺",
    "雅鲁藏布大峡谷", "羊卓雍错", "古格王朝遗址", "冈仁波齐", "然乌湖"
  ),
  lat = c(
    29.6500, 29.6561, 30.7750, 27.9881, 29.2508,
    29.8311, 29.0703, 31.4187, 31.1565, 29.4988
  ),
  lng = c(
    91.1000, 91.1149, 90.9978, 86.9250, 88.8583,
    94.6972, 90.6406, 82.4144, 81.3275, 96.4846
  ),
  description = c(
    "拉萨地标，世界文化遗产",
    "藏传佛教朝圣中心",
    "海拔4718米的高原圣湖",
    "世界最高峰",
    "后藏最大寺庙",
    "世界最深峡谷",
    "蓝宝石般的圣湖",
    "神秘古王朝遗址",
    "藏传佛教神山",
    "帕隆藏布江源头"
  ),
  region = c(
    rep("拉萨", 2), "那曲", "日喀则", "日喀则",
    "林芝", "山南", "阿里", "阿里", "昌都"
  )
)

# 转换为sf对象（用于地图标记）
scenic_spots_sf <- scenic_spots_df %>%
  st_as_sf(coords = c("lng", "lat"), crs = st_crs(tibet_map))

# 创建路线数据（最佳路线规划）
route_coords <- data.frame(
  order = 1:10,
  lat = c(
    29.6500, 29.6561, 29.0703, 30.7750, 29.2508,
    27.9881, 31.4187, 31.1565, 29.4988, 29.8311
  ),
  lng = c(
    91.1000, 91.1149, 90.6406, 90.9978, 88.8583,
    86.9250, 82.4144, 81.3275, 96.4846, 94.6972
  )
) %>%
  st_as_sf(coords = c("lng", "lat"), crs = st_crs(tibet_map))

# 创建路线线对象
route_line <- st_linestring(as.matrix(route_coords %>% st_coordinates())) %>%
  st_sfc(crs = st_crs(tibet_map)) %>%
  st_sf()

# 创建基础地图
base_map <- ggplot() +
  geom_sf(data = tibet_map, fill = "#f0f8ff", color = "#4682b4", size = 0.5) +
  geom_sf(data = scenic_spots_sf, aes(color = region), size = 4, alpha = 0.8) +
  geom_sf(data = route_line, aes(color = "推荐路线"), size = 1.5, alpha = 0.7) +
  geom_label_repel(
    data = scenic_spots_sf,
    aes(label = name, geometry = geometry),
    stat = "sf_coordinates",
    size = 4,
    family = "simhei",
    box.padding = 0.5,
    point.padding = 0.5,
    segment.color = "grey50"
  ) +
  scale_color_manual(
    values = c(
      "拉萨" = "#e41a1c", "那曲" = "#377eb8", "日喀则" = "#4daf4a",
      "林芝" = "#984ea3", "山南" = "#ff7f00", "阿里" = "#ffff33",
      "昌都" = "#a65628", "推荐路线" = "#990000"
    ),
    breaks = c("拉萨", "那曲", "日喀则", "林芝", "山南", "阿里", "昌都", "推荐路线"),
    guide = guide_legend(title = "景点区域/路线")
  ) +
  labs(
    title = "西藏自治区旅游地图与推荐路线",
    subtitle = "包含主要景点与最佳旅行路线规划",
    caption = "数据来源: xizang.json"
  ) +
  theme_minimal(base_family = "simhei") +
  theme(
    plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5, color = "grey40"),
    legend.title = element_text(size = 12, face = "bold"),
    legend.text = element_text(size = 10),
    legend.position = "bottom",
    legend.box = "horizontal",
    axis.title = element_blank(),
    axis.text = element_blank(),
    panel.grid = element_blank()
  )

# 创建景点详情图表（使用原始数据框，保留lat列）
spot_details <- ggplot(scenic_spots_df, aes(x = reorder(name, lat), y = lat)) +
  geom_point(aes(color = region), size = 4) +
  coord_flip() +
  labs(
    x = "",
    y = "纬度",
    title = "西藏主要景点分布"
  ) +
  theme_minimal(base_family = "simhei") +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    legend.position = "none",
    axis.text.y = element_text(size = 10)
  )

# 组合地图和图表
final_map <- base_map + inset_element(spot_details, 0.05, 0.05, 0.4, 0.4)

# 保存地图
ggsave("tibet_travel_map.png", final_map, width = 12, height = 10, dpi = 300)

# 显示地图
print(final_map)
