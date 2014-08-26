### 安装 datatools

```
 library(devtools)
 install_github("COSinvestment","Casunlight",subdir="quantutils",auth_user="*****",password="*****")
 install_github("COSinvestment","Casunlight",subdir="datatools",auth_user="*****",password="*****")
```

### mktData2 示例

mktData2 可以指定获取数据的时间范围 startDate 和 endDate ，指定市场所在区域 region ，指定变量 vars，比如，最高价 hi，最低价 lo 等，还可以指定证券代码 jtids 比如，000018等。

```
## 数据库初始化
utils.init()
## 只指定日期
test1 <- mktData2(20130801,20130804,region="CN");
head(test1)
## 指定日期和变量
test2 <- mktData2(20130801,20130804,region="CN",vars=c("hi"));
head(test2)
## 指定日期和多个变量
test3 <- mktData2(20130801,20130804,region="CN",vars=c("hi","lo"));
head(test3)
## 指定日期和证券代码
test4 <- mktData2(20130801,20130804,region="CN",jtids=c("000018"));
head(test4)
## 指定日期、变量和证券代码
test5 <- mktData2(20130801,20130804,region="CN",vars=c("hi","lo"),jtids=c("000018","000019"));
head(test5)
```
