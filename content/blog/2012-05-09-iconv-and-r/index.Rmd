---
title: 棘手的R乱码和给力的iconv函数
author: MatrixSpk
date: '2012-05-09'
slug: iconv-and-r
categories:
- R
tags:
- R
- 乱码
- icnov
---

从网上抓数据（网页是`utf-8`编码）时，发现读入R的数据出现了乱码。代码和返回结果分别如下：

```
library(XML)
id="000002"
year="2011"
web=paste("http://money.finance.sina.com.cn/corp/go.php/vFD_FinancialGuideLine/stockid/",id,"/ctrl/",year,"/displaytype/4.phtml",sep="")
web
[1] "http://money.finance.sina.com.cn/corp/go.php/vFD_FinancialGuideLine/stockid/000002/ctrl/2011/displaytype/4.phtml"
tables head(tables)
```

```
涓囩A(000002) 璐一姟镌囨爣 NA
1 鎶ュ憡镞ユ湡 2011-12-31
2 姣忚偂镌囨爣
3 鎽婅杽姣忚偂鏀剁泭(鍏\x83) 1.055
4 锷犳潈姣忚偂鏀剁泭(鍏\x83) 0.88
5 姣忚偂鏀剁泭_璋冩暣鍚\x8e(鍏\x83) 0.88
6 镓ｉ櫎闱炵粡甯告ф崯鐩婂悗镄勬疮镶℃敹鐩\x8a(鍏\x83) 0.87
NA NA NA
1 2011-09-30 2011-06-30 2011-03-31
2
3 0.3735 0.2958 0.1082
4 0.326 0.27 0.11
5 0.326 0.27 0.11
6 0.321 0.27
```

去COS咨询了一番，都说运行完我提供的代码之后没有出现乱码。当时的我有些凌乱。心中苦闷得很，难道R代码的运行结果还跟运行者相关么？如果R语言真能发展到如此智能的地步，我定然乐不可支。当然，这是题外话了，按住不说。

于是，我泡在论坛上翻了无数旧帖，最终发现了李舰和陈丽云讨论的结果。他们说R中出现乱码后可以用`Encoding`来解决。在这个原则指导下我各种`Encoding`，却回回都是无功而返。思考再三，我觉得可能是电脑的问题。

只是电脑的问题那么多，根源在哪儿呢？我贴出了自己的`sessionInfo`，想找出问题的根源。幸好有人跟帖也贴出了sessionInfo。对比之下才发现问题出在电脑系统的内部编码上。他们几人所用的都是Linux平台，内部编码设定都是utf。而我苦苦耗在的Windows平台上，系统的内部编码是gbk。

好了，找到了病根。下一步只要修改一下Windows系统的内部编码就行了。我正欢欣鼓舞呢，颜林林却说，Windows系统没法修改系统编码。好吧!我就像一个病人在熟读各种医书终于发现病根所在之时，却被告知没有药材。绝望之情状如井喷。

至此，我几近投奔Linux了。结果，无意中见到一个人用iconv函数解决类似的问题。看起来效果不错，我就尝试了一下：


```
rownames(tables)<-iconv(tables[,1],"UTF-8","gbk")
head(tables[,-1])
```

虽然不知道什么原理，但问题毕竟是解决了。
