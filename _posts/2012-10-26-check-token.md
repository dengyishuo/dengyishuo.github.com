---
layout: post
title: CheckToken
comments: true
categories:
- Programming
tags:
- c/cpp
---


#### 一.题目
检查token字符串是否合法，token可以有多个user:passwd 对，每个user:passwd 对之间至少有一个空格, user和passwd之间不能有任何空格，且都只能为字母或者数字。

#### 二.我的代码
{% highlight c %}

enum STATUS{
    ST_INIT,
    ST_USER,
    ST_SPLIT,
    ST_TOKEN
};

bool check(const char * token){
    const char * p = token;

    bool hasToken = false; 
    bool hasError = false;
    STATUS status = ST_INIT;

    while((p != NULL) && (*p != '\0')){
        switch( status){
            case ST_INIT:
            if( isalnum(*p) ){
                status = ST_USER;
            }else if(*p != ' '){
                hasError = true;
            }
            break;
            case ST_USER:
            if(*p == ':'){
                status = ST_SPLIT;
            }else if( !isalnum(*p) ){
                hasError = true;
            }
            break;
            case ST_SPLIT:
            if( isalnum(*p)){
                hasToken = true;
                status = ST_TOKEN;
            }else{
                hasError = true;
            }
            break;
            case ST_TOKEN:
            if(*p == ' '){
                status = ST_INIT;
            }else if( !isalnum(*p) ){
                hasError = true;
            }
            break;
        }
        if( !hasError ){
            p++;
        }else{
            break;
        }
    } 
    return ( !hasError && hasToken );
}
{% endhighlight %}
<!-- more start -->
#### 三.同事的代码
{% highlight c %}
bool IsToken(const char* token){
    const int N = strlen(token);
    int i,nLeft=0,nRight=0,nPair=0,nColon=0;
    for(i=0;i<N;i++){
        if(!(isalnum(token[i]) || token[i] == ':' || token[i] == ' ')){
            return false;
        }
        if(token[i] == ':'){
            if(nColon == 1 || nLeft == 0){ //avoid "a::b",":b" "a: b"
                return false;
            }
            nColon = 1;
        }else if(token[i] == ' '){
            if(nLeft > 0 && nColon == 1 && nRight > 0){ //true
                nPair++;
                nColon = nRight = nLeft = 0;
            }else if(nLeft == 0 && nColon == 0 && nRight == 0){ //true
            }else{
                return false;
            }
        }else{ //alpha or number
            if(nColon == 0){
                nLeft++;
            }else{
                nRight++;
            }
        }
    }
    if(nLeft > 0 && nColon == 1 && nRight > 0){ //the last pair
        nPair++;
    }
    return nPair > 0;
}
{% endhighlight %}
<!-- more end -->
