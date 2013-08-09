---
comments: true
layout: post
title: 13.2 Haar小波变换
categories:
- R语言
tags:
- Haar
- r
- 小波变换
- 计量经济学
---

下面的代码将对变量进行小波变换。小波变换的定义如下：
[latex]\phi^(H)(u)=\begin{cases}  
              -1/\sqrt(2)  & -1<u\leq 0\\
              1/\sqrt(2)   & 0<u\leq 1 \\
              0            & 其它
\end{cases}[/latex]
一种中规中矩的编程方式如下：
[code]
 haar <- function(x){
 y <- x*0
 for(i in 1:NROW(y)){
 if(x[i]<0 && x[i]>-1){
 y[i]=-1/sqrt(2)
 } else if (x[i]>0 && x[i]<1){
 y[i]=1/sqrt(2)
 }
 }
 y
 }
[/code]
注意if..else..语句中的和应为双&符，&&。或为双竖线，||。
上述方式调用了if..else..。但是，没有很好的利用R的向量化运算的优势。Haar的向量化编程代码如下：
[code]
haar2=function(x){
x[x>(-1)&x;<=0]=-1/sqrt(2);
x[x>0&x;<=1]=1/sqrt(2);
x[x<=(-1)|x>1]=0;
x
}
[/code] 
