---
layout: post
title: 安装 RMySQL
comments: true
categories:
- R
tags:
- RMySQL
- MySQL
- R语言
- R软件
---

<b>发布日期:2013-09-28 作者:邓一硕</b>

在 Windows 下面安装 RMySQL 就跟驯服一头猛兽差不多，有点费事儿，不过，搞定了也让令人兴奋。

1. 下载 R2.13.2: http://cran.stat.sfu.ca/index.html。
2. 安装 RTools 214: http://cran.cict.fr 
3. 下载 RMySQL 0.8-0.tar.gz: http://biostat.mc.vanderbilt.edu/wiki/main/RMySQL/RMySQL_0.8-0.tar.gz 
4. MySQL Server 5.0: http://dev.mysql.com 

### SET THE FOLLOWING ENVIRONMENT VARIABLES

* a. MYSQL_HOME :  MYSQL_HOME= C:\Program Files\MySQL\MySQL Server 5.5\ 
* b. R_HOME: R_HOME=C:\Program Files\R\R-2.13.2\ 
* c. PATH: Modify path to accommodate the above variables. *

Be sure that the following paths are included in your Windows PATH variable: \Rtools\2.14\bin \Rtools\2.14\MinGW\bin \Rtools\2.14\MinGW64\bin

### CREATE FOLDER AND COPY FILES

* a. OPT: 在C:\Program Files\MySQL\MySQL Server 5.5\lib 下创建OPT文件夹，复制 MYSQLLIB.LIB 到该文件夹。

* b. Renviron.site: 打开\\R\R-2.14.0\etc\Renviron.site ，向文件添加一行: MYSQL_HOME =”C:/Program Files/MySQL/MySQL Server 5.5/” 

* c. 复制libmysql.dll 到 \\R\R-2.14.0\bin\ (64 bit) 和 \\R\R-2.14.0\bin\i386\ (32 bit) 和 C:\Windows\System32。

### RUN COMMANDS

* a. Install.Packages: Run R GUI by clicking on the R icon on desktop or from Start menu. Type

INSTALL.PACKAGES(“RMySQL”,type=”Sources”). 

This will download the required software from repositories.

* b. Command Prompt: Copy the downloaded zip file (in step 4.a.) and paste it under R installation folder. Go to start menu and open Command Prompt. Go to the R installation folder and type R CMD 

INSTALLR MySQL_0.8-0.tar.gz


{% highlight r %}
library(RMySQL) 
drv = dbDriver("MySQL") 
con = dbConnect(drv,host="localhost",dbname="test",user="root",pass="root") 
album = dbGetQuery(con,statement="select * from t_master") 
album
{% endhighlight %}





















