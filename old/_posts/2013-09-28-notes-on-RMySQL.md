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

处理金融市场数据的时候会用到MySQL数据库，R提供了一个RMySQL`包作为自身跟 MySQL的接口。这个包本身很容易用，唯一不足的一点是在 Windows下面安装 RMySQL有点麻烦。安装RMySQL时,除了按部就班的安装MySQL、R、
RTools、RMySQL等之外还要设置各种path变量以及把某些文件夹在各个路径里来回移动。这篇文章就说一下自己在安装RMySQL过程中总结出来的较优的安装步骤.

#### 1.下载并安装 MySQL

下载并安装 [MySQL](http:http://dev.mysql.com/downloads/mysql/) ，这一点大多数人都知道如何操作，只提醒一点看清楚自己的电脑是 32位还是64位.

#### 2. 把MySQL添加到Path变量.

具体做法是找到我的电脑(指图标)，右键，系统属性，打开"高级"选项卡，下面可以瞅见"环境变量"，点进去，上面部分为"用户变量"，下面部分是"系统变量"，在变量列，找到一个叫Path的东西，选中，点编辑，把MySQL的安装路径复制进去即可。

#### 3. 关联MySQL和R软件

具体是，打开 C:\Program Files\MySQL\MySQL Server 5.5\lib ，新建 OPT 文件夹，并复制 MYSQLLIB.LIB 到该文件夹内。同时，复制 libmysql.dll 到到\\R\R-2.14.0\bin\ (64 bit) 或 \\R\R-2.14.0\bin\i386\ (32 bit) 和 C:\Windows\System32 中;接下来,找到 R\3.0.2\etc 文件夹，并新建 Renviron.site 文件,用记事本打开,向其中添加一行:MYSQL_HOME =”C:/Program Files/MySQL/MySQL Server 5.5/” .

#### 4. 下载并安装 [RTools](http://cran.r-project.org/bin/windows/Rtools/)

安装过程很简单。要提醒的是要把\Rtools\2.14\bin,\Rtools\3.0.x\MinGW\bin,\Rtools\3.0.x\MinGW64\bin 添加到 path 变量。

#### 5,下载 [RMySQL](http://biostat.mc.vanderbilt.edu/wiki/main/RMySQL/RMySQL_0.8-0.tar.gz )源代码

略过。

#### 6. 运行代码安装 RMySQL

假设源码存放地址为 d://RMySQL_0.8-0.tar.gz ,运行如下命令:

{% highlight r %}
install.packages("RMySQL_0.8-0.tar.gz",repo=NULL,type="source")
{% endhighlight %}

测试安装是否成功:

{% highlight r %}
library(RMySQL) 
drv = dbDriver("MySQL") 
con = dbConnect(drv,host="localhost",dbname="test",user="root",pass="root") 
album = dbGetQuery(con,statement="select * from t_master") 
album
{% endhighlight %}


















