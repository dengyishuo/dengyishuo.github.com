---
layout: post
title: R软件中的集合计算操作
comments: true
categories:
- R
tags:
- 集合运算
- R语言
- R软件
---

<b>发布日期:2013-09-27 作者:邓一硕</b>

在处理数据，更多的是在编写函数和R包的时候会涉及到集合的运算操作。比如，判断某个元素是否属于某个集合，并用这个判断结果作为 if 结构中的条件语句。因此，有必要了解一下 R 中的集合计算操作。

根据小学时候的知识，我们知道集合计算无非包括这么几类：

* 两个集合的交集，即两个集合中共有的那些元素
* 两个集合的并集，即两个集合粗暴合并，并剔除重复值后剩余的那些元素
* 两个集合的差集，集合1减去集合1跟集合2的交集，即得到集合1、集合2的差集，换句话说，集合1中包含，而集合2未包含的那些元素
* 元素判断，即开篇说的那个问题，某个元素是否属于某个集合
* 集合等价判断，即两个集合是否是同一个集合

那么，它们对应的 R 函数就是下面这些：

* union(x, y)
* intersect(x, y)
* setdiff(x, y)
* setequal(x, y)
* is.element(el, set)

本着解释知识不举例子就是耍流氓的精神，我们看看下面的例子:

{% highlight r %}
# 随意生成两个向量x和y
x <- c(sort(sample(1:20, 9)), NA)
y <- c(sort(sample(3:23, 7)), NA)
# 查看 x，y 都长什么样子
x
y
# 计算并集
union(x, y)
# 计算交集
intersect(x, y)
# 计算差集，注意：计算差集时，集合的先后顺序是影响结果滴！
setdiff(x, y)
setdiff(y, x)
# x，y是否相等，当然不相等啦....
setequal(x, y)
# 看看并集、交集、差集的关系
## True for all possible x & y :
setequal( union(x, y),
          c(setdiff(x, y), intersect(x, y), setdiff(y, x)))
# 元素判断
is.element(5, x)
is.element(100, x)
is.element(x, y) # length 10
is.element(y, x) # length  8

{% endhighlight %}





















