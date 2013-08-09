---
comments: true
layout: post
title: weibo数据开发思路
categories:
- R语言
tags：
- 微博
---

weibo开放了API提供了众多的接口。不过，这些接口对于非开发人员而言过于复杂，不利于weibo数据的开发和挖掘。李舰结合weibo的API以及TwitteR包编写了Rweibo包，然而Rweibo包的使用方法也相当繁琐。根据自己的需要，我整理了一下weibo数据的开发思路，需要建立的是这样一套东西：

应当具有的功能：

1.获取用户A在时间t至时间t+k之间发布的所有微博正文文本内容。

对应的函数为：weibotext(A,from=t,to=t+k)。

该函数有三个参数：分别表示用户ID、起始时间t和截止时间t+k。

2.获取用户A发布的某条微博W的被转发次数和被评论次数。

3.获取用户A当前的粉丝数量。

4.获取用户A当前关注的用户数量。
