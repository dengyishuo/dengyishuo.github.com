---
layout: post
title: Jekyll On OpenShift
comments: true
categories:
- Method
tags:
- jekyll
---

1. 创建Openshift应用
======
---
[OpenShift](https://openshift.redhat.com)是redhat公司推出的一个PaaS云计算应用平台台。申请账号之后，创建使用DIY框架的Application，同时在网站添加相应的SSH 公钥保证git可以正常提交。
{% highlight c %}
ssh-keygen
{% endhighlight %}
将~/.ssh/id_rsa.pub中内容拷给网站的SSH Key里。



OpenShift提供私有的git仓库，创建的应用可以直接通过git提交和SSH登录访问，这一步需要事先设置SSH Key。

git仓库地址示例:
{% highlight c %}
ssh://f44e1c405e8642eeba13fa0536b15fe8@blog-huxiao.rhcloud.com/~/git/blog.git/
{% endhighlight %}

ssh登录方式：
{% highlight c %}
ssh://f44e1c405e8642eeba13fa0536b15fe8@blog-huxiao.rhcloud.com
{% endhighlight %}

2. 准备空间环境
======
---
####ssh登录服务器，各目录文件说明如下：

+ ~/app-root/data/目录，存放静态数据，包含一个.bash_profile
+ ~/app-root/repo/目录，存放git的repo数据，git push时会修改。
+ ~/app-root/runtime/目录，各种系统脚本
+ ~/.env/目录，系统提供的各种环境变量，只能读不能写
+ ~/blog是~/diy-0.1的软链接
+ ~/diy-0.1/，包含blog_ctl.sh,ci,data,logs,repo ,run ,runtime,tmp，很多软链接
+ ~/app-root/repo/.openshift/action_hooks/目录 ，包含一些脚本，start，stop，build，deploy等。

<!-- more start -->

#### 修改系统环境变量
由于默认home目录是root用户创建的，我们没有读写权限。
修改~/app-root/data/.bash_profile，添加 
{% highlight c %}
export HOME=/var/lib/stickshift/f44e1c405e8642eeba13fa0536b15fe8/app-root/runtime

source ~/app-root/data/.bash_profile
{% endhighlight %}
此时Home目录变成用户有读写权限的runtime目录了。

修改自定义环境变量，由于系统从~/.env导入环境变量,cd 到runtime目录，执行

{% highlight c %}
cp /var/lib/stickshift/f44e1c405e8642eeba13fa0536b15fe8/.env . -fr
{% endhighlight %}

,修改.env/PATH添加ruby1.9的目录，添加.env/LD_LIBRARY_PATH导入ruby1.9的运行库。

PATH内容：
{% highlight c %}
export PATH=/opt/rh/ruby193/root/usr/bin:/usr/libexec/stickshift/cartridges/diy-0.1/info/bin/:/usr/libexec/stickshi
ft/cartridges/abstract/info/bin/:/sbin:/usr/sbin:/bin:/usr/bin
{% endhighlight %}


LD_LIBRARY_PATH内容： 
{% highlight c %}
export LD_LIBRARY_PATH=/opt/rh/ruby193/root/usr/lib64:
{% endhighlight %}

导入生效。
{% highlight c %}
source ~/.env/PATH 
source ~/.env/LD_LIBRARY_PATH
{% endhighlight %}

#### 安装Jekyll

{% highlight c %}
gem install jekyll

gem install rdiscount

gem install RedCloth

{% endhighlight %}
修改PATH变量
{% highlight c %}
vi ~/.env/PATH
export PATH=$HOME/bin:/opt/rh/ruby193/root/usr/bin:/usr/libexec/stickshift/cartridges/diy-0.1/info/bin/:/usr/libexec/stickshi
ft/cartridges/abstract/info/bin/:/sbin:/usr/sbin:/bin:/usr/bin


{% endhighlight %}

jekyll  --serverk 可以启动一个ruby的Web服务器。当然需要一些修改，在Jekyll的ruby脚本启动服务器时，添加IP和Port的config。然而这个服务器性能较差，下面安装Nginx服务器代替。

#### 安装Pygments
为了代码高亮，需要使用pygements。可怜的普通用户没有万恶的权限，无奈只好自己安装python2.7.3先.
{% highlight c %}
wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2

wget http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c11.tar.gz

wget http://pypi.python.org/packages/source/p/pip/pip-1.1.tar.gz

war zxf pip-1.1.tar.gz

cd Python-2.7.3

./configure --prefix=$OPENSHIFT_RUNTIME_DIR

make install

cd setuptools-0.6c11

$OPENSHIFT_RUNTIME_DIR/bin/python setup.py install

cd pip-1.1

$OPENSHIFT_RUNTIME_DIR/bin/python setup.py install

pip install pygments
{% endhighlight %}

修改环境变量
{% highlight c %}
export PATH=$OPENSHIFT_RUNTIME_DIR/bin:$PATH
{% endhighlight %}

这一步在~/.env/PATH文件中修改。

#### 安装Nginx

{% highlight c %}
cd $OPENSHIFT_TMP_DIR

wget http://nginx.org/download/nginx-1.2.4.tar.gz

tar zxf nginx-1.2.4.tar.gz

wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.31.tar.bz2

tar jxf pcre-8.31.tar.bz2

cd nginx-1.2.4

./configure --prefix=$OPENSHIFT_RUNTIME_DIR/ --with-pcre=$OPENSHIFT_TMP_DIR/pcre-8.31

make && make install 
{% endhighlight %}

修改nginx.conf文件，主要是IP和Port,以及一些优化。以下是我的部分配置文件：
{% highlight c %}
worker_processes  4;
worker_cpu_affinity 0001 0010 0100 1000;

worker_rlimit_nofile 10240;

events {
    use epoll;
    worker_connections  10240;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    server {
        listen       ip:port;  #####################Mofity On Demand
        server_name  shawhu.org;

        charset utf-8;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }
}
{% endhighlight %}

#### 配置 start 和stop脚本
将start修改成启动nginx，将stop修改成关闭nginx

start配置文件如下：
{% highlight c %}
#!/bin/bash
nohup $OPENSHIFT_RUNTIME_DIR/sbin/nginx   > $OPENSHIFT_LOG_DIR/server.log 2>&1 &
{% endhighlight %}

stop配置文件如下：
{% highlight c %}
#!/bin/bash
ps -ef | grep nginx | while read line
do
  kill -9 `echo $line | awk '{ print $2 }'`
done
exit 0
{% endhighlight %}

#### 配置Jekyll
编辑jekyll的配置文件_config.yml,主要是源路径和目的路径
{% highlight c %}
source: /var/lib/stickshift/f44e1c405e8642eeba13fa0536b15fe8/app-root/runtime/repo/
destination: /var/lib/stickshift/f44e1c405e8642eeba13fa0536b15fe8/app-root/runtime/html
markdown: rdiscount
permalink: /:year/:month/:title/
url: http://shawhu.org
author: signifox
pygments: true
paginate: 16
{% endhighlight %}

#### 配置buid文件
注意_config.yml文件存放在~/bin/目录下。
编辑build文件,似乎git push调用hook时，我自定义的环境变量没有生效，造成Jekyll失效。同时Openshift贴心的为我准备了zh_CN.utf-8编码方式，造成ruby解码失败。

{% highlight c %}
#!/bin/bash
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export HOME='/var/lib/stickshift/f44e1c405e8642eeba13fa0536b15fe8/app-root/runtime/'
export LD_LIBRARY_PATH=/opt/rh/ruby193/root/usr/lib64:
export PATH=/opt/rh/ruby193/root/usr/bin:$HOME/bin:/usr/libexec/stickshift/cartridges/diy-0.1/info/bin/:/usr/libexec/stickshift/cartridges/abstract/info/bin/:/sbin:/usr/sbin:/bin:/usr/bin

cd $OPENSHIFT_RUNTIME_DIR/bin/

$OPENSHIFT_RUNTIME_DIR/bin/jekyll

export LANG="zh_CN.UTF-8"
export LC_ALL="zh_CN.UTF-8"

export HOME='/var/lib/stickshift/f44e1c405e8642eeba13fa0536b15fe8/'
export PATH=/usr/libexec/stickshift/cartridges/diy-0.1/info/bin/:/usr/libexec/stickshift/cartridges/abstract/info/bin/:/sbin:/usr/sbin:/bin:/usr/bin
{% endhighlight %}

3. 大功告成
======
---
现在在本地编写MakrDown文件，git push时自动停止服务器，编译源文件，部署静态网页到nginx的工作目录，然后重启服务。

现在一切都自动化了，类似Github的发布方式，系统自动完成了所有的事情。此外系统还有执行动态网页的潜力，相比Github更加灵活方便。

4. 参考
======
---

1. [像黑客一样写博客——Jekyll入门](http://www.soimort.org/tech-blog/2011/11/19/introduction-to-jekyll_zh.html)

2. [Lightweight HTTP serving using nginx on OpenShift | OpenShift by Red Hat](https://openshift.redhat.com/community/blogs/lightweight-http-serving-using-nginx-on-openshift)

3. [OpenShift DIY自己的服务器环境python2.7+django](http://blog.gideal.org/articles/2012/09/05/1346782192657.html)

<!-- more end -->