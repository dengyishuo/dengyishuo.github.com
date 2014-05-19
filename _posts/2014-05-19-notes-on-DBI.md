---
layout: post
title: R数据库交互系列笔记：DBI包
comments: true
categories:
- R
tags:
- R
- DBI
- RODBC
- 数据库
---

### 1 简介

DBI是DataBase Interface的简称，即数据库界面。这篇笔记的主要内容是讲一讲如何用R中的DBI包来与常见数据库进行交互。

DBI定义了一个与任意RDBMS数据库进行通信的通用接口。对于任意一个RDBMS，会有一个兼容的数据库驱动来实现通用接口。目前可用的驱动包括Oracle，MySQL和SQLite。

理论上说，DBI的通用接口允许用同样的代码来跟不同的RDBMS进行交互。但实际应用的时候，还取决于RDBMS与SQL标准的相似度以及数据库开发者是否在开发过程中避免了RDBMS特有的一些功能。

下面以SQLite数据库为例，用的是Affymetrix hgu95av2的微阵列芯片数据。用之前先加载相关的包。

<pre>
> library(tools)
> library("RBioinf")
> library("DBI")
> library("RSQLite")
> dbPath <- "hgu95av2-sqlite.db"
</pre>

### 2 DBI连接SQLite数据库

DBI连接RDBMS需要两步。第一步，用dbDriver函数创建一个适合的数据库驱动；第二步，用dbConnect函数创建数据库连接。

具体到SQLite，只需要指定包含数据库的文件夹路径即可。对于RDBMS的PC端或者服务器来，比如像MySQL或者Oracle，则需要指定主机地址、用户名和密码等信息。

<pre>
> drv <- dbDriver("SQLite")
> db <- dbConnect(drv, dbPath)
> db
<SQLiteConnection:(2175,0)>
</pre>

dbDisconnect函数可以断开连接。

<pre>
> dbDisconnect(db)
[1] TRUE
</pre>

### 3 查询数据库结构

可以用dbListTables和dbListFields函数来列出数据库中的表名以及各表对应的字段（列名）。

<pre>
> db <- dbConnect(drv, dbPath)
> dbListTables(db)
[1] "acc" "go_evi" "go_ont" "go_ont_name" "go_probe"
[6] "pubmed"
> dbListFields(db, "go_probe")
[1] "affy_id" "go_id" "evi"
</pre>

### 4 查询语句

dbSendQuery函数可以执行任意SQL语句。返回的结果是DBI结果的子类，这个子类的结果可以用fetch函数来查询。为了节约内存，用不到的数据库查询对象可以用dbClearResult函数进行清除。

fetch函数可以将查询结果转为数据框。dbColumnInfo、dbGetRowsAffected和dbGetRowCount函数可以返回更多关于查询的信息。下面分别演示。

<pre>
> sql <- "select affy_id, evi from go_probe"
> rs <- dbSendQuery(db, sql)
> rs
<SQLiteResult:(2175,1,3)>
</pre>

DBIResult实例包含了查询的相关信息。

<pre>
> dbColumnInfo(rs)
name Sclass type len precision scale nullOK
1 affy_id character SQL92_TYPE_CHAR_VAR -1 -1 -1 TRUE
2 evi character SQL92_TYPE_CHAR_VAR -1 -1 -1 TRUE
2
> dbGetStatement(rs)
[1] "select affy_id, evi from go_probe"
> dbGetRowsAffected(rs)
[1] 71896
</pre>

具体的结果可用fetch函数查看。

<pre>
> chunk <- fetch(rs, n = 5)
> chunk
affy_id evi
1 986_at IEA
2 986_at TAS
3 986_at IEA
4 986_at TAS
5 986_at NR
</pre>

dbGetRowCount函数范围所有查询结果的行数。

<pre>
> dbGetRowCount(rs)
[1] 5
</pre>

当不再用某个DBIResult实例时，记得清除。

<pre>
> dbClearResult(rs)
[1] TRUE
> rs
<Expired SQLiteResult:(2175,1,3)>
</pre>

### 5 基于查询结果构建R中的数据对象

<pre>
> sql <- "select * from go_probe"
> rs <- dbSendQuery(db, sql)
> dat <- fetch(rs, n = 500)
> goList <- split(dat$go_id, dat$affy_id)
</pre>

### 6 ODBC

RODBC包可以连接ODBC数据源，当然前提是安装相应的数据库驱动。R导入与导出中给出了一些使用RODBC的实例，可以供参考。

用ODBC连接RDBMS时，需要指定一个ODBC数据服务，具体如何做要看所用的操作系统。总之，你需要一个与要连接的数据库相对应的ODBC驱动。

RBioinf包中提供Gavin和Ho提供关于AP-MS蛋白质实验结果数据，分别给出了pcomplex.txt和pcomplex.xls两种格式，下面用它来演示下RODBC的用法。

数据包括三列：bait-protein，experiment和prey-protein。下面的结果仅在Windows系统下才能重现。

<pre>
> library("RODBC")
> if (.Platform$OS.type == "Windows") {
+ pcomplexXls <- system.file("extdata/pcomplex.xls", package = "RBioinf")
+ db <- odbcConnectExcel(pcomplexXls)
+ }
> if (!is.null(db)) {
+ sqlTables(db)
+ sqlQuery(db, "select * from [Sheet1$] limit 5")
+ }
</pre>

### 7 参考文献

Seth Falcon，How to Use DBI: Connecting to Databases with R，January 17, 2006。

