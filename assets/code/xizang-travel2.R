# 加载必要的包
library(geojsonio)
library(leaflet)
library(dplyr)
library(RColorBrewer)

# 读取西藏地图数据
tryCatch(
  {
    tibet_map <- geojson_read("assets/data/xizang.json", what = "sp")
  },
  error = function(e) {
    stop(paste("无法读取xizang.json文件:", e$message))
  }
)

# 创建著名景点数据集
scenic_spots <- data.frame(
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
    "位于拉萨市，是西藏最著名的地标，世界文化遗产",
    "拉萨最古老的寺庙，藏传佛教信徒的朝圣中心",
    "中国第二大咸水湖，海拔4718米，风景壮丽",
    "世界最高峰，海拔8848米，登山爱好者的梦想之地",
    "位于日喀则，是后藏地区最大的寺庙",
    "世界最深的峡谷，全长504.6公里，平均深度2268米",
    "西藏三大圣湖之一，湖水如蓝宝石般美丽",
    "位于阿里地区，是古格王朝的遗址，历史悠久",
    "藏传佛教四大神山之一，海拔6656米，是朝圣者的圣地",
    "位于昌都地区，是帕隆藏布江的源头，湖水清澈如镜"
  )
)

# 定义颜色方案
color_palette <- brewer.pal(5, "Set1")

# 创建路线数据（假设的最佳路线）
route_data <- data.frame(
  travel_order = 1:10,
  lat = c(
    29.6500, 29.6561, 29.0703, 30.7750, 29.2508,
    27.9881, 31.4187, 31.1565, 29.4988, 29.8311
  ),
  lng = c(
    91.1000, 91.1149, 90.6406, 90.9978, 88.8583,
    86.9250, 82.4144, 81.3275, 96.4846, 94.6972
  )
)

# 创建地图
tibet_travel_map <- leaflet() %>%
  # 添加底图
  addTiles() %>%
  # 添加西藏边界
  addPolygons(
    data = tibet_map,
    fillColor = "lightblue",
    color = "blue",
    weight = 2,
    fillOpacity = 0.3,
    label = ~name
  ) %>%
  # 添加景点标记
  addCircleMarkers(
    data = scenic_spots,
    lng = ~lng,
    lat = ~lat,
    popup = ~ paste("<b>", name, "</b><br>", description),
    label = ~name,
    color = ~ color_palette[as.numeric(cut(route_data$travel_order, breaks = 5))],
    radius = 6,
    fillOpacity = 0.8,
    stroke = TRUE,
    weight = 1
  ) %>%
  # 添加路线
  addPolylines(
    data = route_data,
    lng = ~lng,
    lat = ~lat,
    color = "red",
    weight = 3,
    opacity = 0.7,
    label = "推荐路线"
  ) %>%
  # 添加图层控制
  addLayersControl(
    overlayGroups = c("景点", "路线"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  # 设置地图初始视图
  setView(lng = 88.8583, lat = 30.7750, zoom = 5) %>%
  # 添加比例尺
  addScaleBar(position = "bottomleft") %>%
  # 添加图例
  addLegend(
    position = "bottomright",
    colors = color_palette[1:5],
    labels = c("拉萨地区", "日喀则地区", "阿里地区", "昌都地区", "林芝地区"),
    title = "景点分布区域"
  )

# 保存地图为HTML文件
htmlwidgets::saveWidget(tibet_travel_map, "tibet_travel_map.html")

# 打印地图
tibet_travel_map
