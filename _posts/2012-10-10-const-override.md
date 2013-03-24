---
layout: post
title: const的毛病
comments: true
categories:
- Programming
tags:
- c/cpp
---

### C++在参数及函数名相同的情况下，const可以构成函数重载。
{% highlight c %}
- void function(){};
- void function() const{};

-class Object{
public:
	inline void function(){}
	inline coid function()const{}	
};

{% endhighlight %}

两者调用优先级如下：

+ 类中两种函数都存在时：
	1. const对象默认调用const成员函数，非const对象默认调用非const成员函数;
	2. 若非const对象想调用const成员函数，则需显式转化，如(const Object&)obj.function();
	3. 若const对象想调用非const成员函数，同理const_cast<Object&>(constObj).function()(注意：constObj要加括号);
	4. 普通函数（相对于类的成员函数），优先调用非const的函数。

<!-- more start -->

+ 类中只存在一种函数时：
	1. 非const对象可以调用const成员函数或非const成员函数;
	2. const对象只能调用const成员函数,直接调用非const函数时编译器会报错;
	3. 普通函数可以调用const或者非const函数;
	4. const 函数只能调用 const函数，即使某个函数本质上没有修改任何数据，但没有声明为const，也是不能被const函数调用的。

说明：
const成员函数不能更改任何非静态成员变量;

---

### const和typedef的 化学反应

typedef string* pstring;

const pstring cstr;

问题：cstr 是什么类型？

正确的答案应该是：const 指针指向一个 string 类型的对象。

《C++ Primer》：
> 
const pstring cstr1;
string* const cstr2;


> 
const string str1;
string const str2;

两者类型也相同。

<!-- more end -->