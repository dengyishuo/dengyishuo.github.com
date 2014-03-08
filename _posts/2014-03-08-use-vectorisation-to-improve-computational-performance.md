---
layout: post
title: 善用向量化提升R语言的计算性能
comments: true
categories:
- life
tags:
- 风险均摊
- 投资组合
- R
---


用R 语言用的久了，渐渐发现 R 语言的世界里有很多黑魔法。其中一个黑魔法是向量化运算。向量化运算可以说是R语言区别于其它语言的特质之一，善用向量化运算不仅能有效降低代码的冗余度，还能显著提升代码的运算效率。遗憾的是，很多接触过其它编程语言的人未能掌握这一特性使得他们经常诟病R语言运算效率低下。这里给看官们举个例子来体会下。
想必大家都遇到过替换向量元素的情况。比如，我们有下面这样一个数据框，维度是1200000×2：

{% highlight r %}
n = 1200000
df = data.frame(values = rnorm(n), 
                ID = rep(LETTERS[1:3], each = n/3),
                stringsAsFactors = FALSE)
head(df)
{% endhighlight %}

假设要把df$ID中的A替换为“A公司”，B和C类似。怎么做呢？一个常用的解决方案是利用for写循环。代码是这样的：

{% highlight r %}
translator_if_for = function(input_vector) {
    output_vector = input_vector
    for(index in seq_along(input_vector)) {
        if(input_vector[index] == 'A') {
            output_vector[index] = 'A公司'
        } else if(input_vector[index] == 'B') {
            output_vector[index] = 'B公司'
        } else if(input_vector[index] == 'C') {
            output_vector[index] = 'C公司'
        }   
    }   
    return(output_vector)
}
dum_if_for = translator_if_for(df$ID)
{% endhighlight %}

用 rbenchmark 包测试下上述操作需要的时间：

{% highlight r %}
res = benchmark(if_for_solution   = translator_if_for(df$ID),        replications = 10)
res
{% endhighlight %}

上面这段代码的缺点是时间久，而且看起来一点都不简洁。那么，是否有更好点的解决方案呢？Absolutely！而且不止一种。比较常用的替代方案是借助 apply族函数（apply族函数是R语言中避免编写显式循环的一个trick）。在用apply族函数之前，得先构造一个辅助函数。构造函数之前不妨先想想我们的操作逻辑，我们想做的事情是这样的，对于df$ID中的某个元素，如果元素是A其就变成A公司，B变成B公司，C变成C公司。这其实可以用switch来实现。对所有元素进行依次进行判断就可以了，针对所有元素进行判断这个过程可以交给sapply函数来完成，于是有下面的代码：

{% highlight r %}
translator_function = function(element) {
    switch(element,
           A = 'A公司',
           B = 'B公司',
           C = 'C公司')
}

dum_switch_sapply = sapply(df$ID, translator_function)
{% endhighlight %}

代码看起来更简洁，看看操作结果是否一致：

{% highlight r %}
all.equal(dum_if_for, dum_switch_sapply, check.attributes = FALSE)
{% endhighlight %}

看看这段代码需要的时间：

{% highlight r %}
res = benchmark(function_solution = sapply(df$ID, translator_function),

                             replications = 10)
{% endhighlight %}

可以看到时间也有所减少。But..这就是结束吗？操作效率是有提升，但提升的一点都不明显啊！？别急，我们还有杀手锏——向量化运算！先上代码，再慢慢解释逻辑。

{% highlight r %} 
translator_vector = c(A = 'A公司',
                      B = 'B公司',
                      C = 'C公司')
dum_vectorized = translator_vector[df$ID]
{% endhighlight %}

看看结果是否一样：

{% highlight r %} 
all.equal(dum_vectorized, dum_switch_sapply, check.attributes = FALSE)
{% endhighlight %}

完全一样。但是看起来无疑简洁了很多。那么，从耗时角度讲呢？我们看一看：

{% highlight r %} 
res = benchmark(vector_solution   = translator_vector[df$ID],
                replications = 10)
{% endhighlight %}
时间大大减少了。把三种方案的耗时放到一起看一看：
{% highlight r %} 
res = benchmark(if_for_solution   = translator_if_for(df$ID),
                function_solution = sapply(df$ID, translator_function),
                vector_solution  = translator_vector[df$ID],
	column	= c("test","replications","elapsed","relative","user.self","sys.self"),
                replications = 10)
{% endhighlight %}
向量化运算无论在代码简洁度还是在效率上完爆前两种方案。缺点是操作逻辑十分巧妙，可能不是那么容易理解。这里简单解释一下：
上面的translator_vector 是个有名字的向量：

{% highlight r %} 
 translator_vector = c(A = 'A公司',
                       B = 'B公司',
                       C = 'C公司')
translator_vector
names(translator_vector)
{% endhighlight %}
 
 因此，可以通过元素的名字对元素进行索引。例如：
 
 {% highlight r %}
 translator_vector["A"]
      A 
"A公司" 
 translator_vector["B"]
      B 
"B公司" 
 translator_vector[c("A","B")]
      A       B 
"A公司" "B公司" 
{% endhighlight %}


而df$ID刚好是一个由translator_vector向量的元素名字组成的向量。因此,代码：translator_vector[df$ID]
就相当于一个索引操作，其结果得到的恰好是translator_vector中对应的元素，这也就相当于对向量元素进行了替换。