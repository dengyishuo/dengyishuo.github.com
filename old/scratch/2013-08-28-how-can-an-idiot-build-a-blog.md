---
layout: post
title: 白痴如何用github建博客
comments: true
categories:
- life
tags:
- github
- jelyll
- 博客
---

<span>发布日期：2013-08-30 作者：邓一硕</span>
1.下载并安装RailsInstaller
2.输入用户名：比如，dengyishuo@163.com
3.把生成的公钥(在 .ssh文件夹里，id_rsa.pub文件)导入到github的ssh
*  gem sources --remove http://rubygems.org/
   gem sources -a http://ruby.taobao.org/
* gem install jekyll -v 0.11.0
* gem install rdiscount kramdow  #安装rdiscount
* 修改_config.yml
* jekyll --auto --server 浏览器中输入： localhost:4000 可以预览博文