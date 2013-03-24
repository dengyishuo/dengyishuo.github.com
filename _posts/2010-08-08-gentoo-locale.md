---
layout: post
title: gentoo 中文化指南
comments: true
categories:
- Linux
tags:
- gentoo 
---


####设置locale
编辑/etc/locale.gen中添加
{% highlight c %}
zh_CN.UTF-8
zh_CN.GBK
zh_CN.GB2312
zh_CN.GB18030
{% endhighlight %}

然后运行locale-gen命令

####设置默认locale环境
编辑/etc/env.d/02locale
{% highlight c %}
LANG="zh_CN.UTF-8"
LC_CTYPE="zh_CN.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
{% endhighlight %}

<!-- more start -->

####加入新的字体文件
在／usr/share/fonts现新建一个文件夹，如msfonts。到window的fonts目录下拷贝一些ttf和ttc结尾的字体(正版爱好者可下载免费的自由的开源的中文字体代替，下步配置文件需要相应修改)。字体文件我已经打包，一共48M，存放在百度网盘。包括Microsoft YaHei，Microsoft JhengHei，Segoe UI，Courier New，下载地址：[猛击此处](http://pan.baidu.com/share/link?shareid=94048&uk=2986497451)，正版爱好者可以无视。


{% highlight c %}
emerge mkfontdir mkfontscale
mkfontdir
mkfontscale
fc-cache -fv
{% endhighlight %}

更新字体

####更新配置文件
编辑／etc/fonts/local.conf(全局配置)或者~/.font.conf(当前配置)
{% highlight xml %}

<?xml version="2.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">

<fontconfig>

<match target="pattern" >
	<edit name="dpi" mode="assign" >
		<double>90</double>
	</edit>
</match>

<match target="font" >
	<edit name="rgba" mode="assign" >
		<const>rgb</const>
	</edit>
</match>
<match target="font" >
	<edit name="antialias" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="autohint" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="hinting" mode="assign" >
		<bool>false</bool>
	</edit>
	<edit name="hintstyle" mode="assign" >
		<const>hintslight</const>
	</edit>
</match>

<!-- Sans-serif faces -->
<alias>
	<family>Segoe UI</family>
	<family>SimSunNew</family>
	<family>Microsoft YaHei</family>
	<family>Microsoft JhengHei</family>
</alias>

<!-- Serif faces -->
<alias>
	<family>SimSunNew</family>
	<family>serif</family>
</alias>

<!-- Monospace faces -->
<alias>
	<family>SimSunNew</family>
</alias>

<alias>
	<family>sans-serif</family>
	<prefer>
		<family>Segoe UI</family>
		<family>Microsoft YaHei</family>
		<family>Microsoft JhengHei</family>
		<family>SimSunNew</family>
	</prefer>
</alias>

<alias>
	<family>serif</family>
	<prefer>
		<family>Microsoft YaHei</family>
		<family>Microsoft JhengHei</family>
		<family>SimSunNew</family>
	</prefer>
</alias>

<alias>
	<family>SimSunNew</family>
	<prefer>
		<family>SimSunNew</family>
		<family>Microsoft JhengHei</family>
		<family>Microsoft YaHei</family>
		<family>Courier New</family>
	</prefer>
</alias>

<alias>
	<family>Arial</family>
	<prefer>
		<family>Segoe UI</family>
	</prefer>
	<default>
		<family>sans-serif</family>
	</default>
</alias>
<alias>
	<family>SimSunNew</family>
</alias>

<!-- Sans-Serif -->
<match target="font" >
	<test name="family" compare="eq" >
		<string>Segoe UI</string>
	</test>
	<edit name="rgba" mode="assign">
		<const>rgb</const>
	</edit>
	<edit name="antialias" mode="assign">
		<bool>true</bool>
	</edit>
	<edit name="autohint" mode="assign">
		<bool>false</bool>
	</edit>
	<edit name="hinting" mode="assign">
		<bool>true</bool>
	</edit>
	<edit name="hintstyle" mode="assign">
		<const>hintslight</const>
	</edit>
</match>

<match target="font" >
	<test qual="any" name="family" compare="eq" >
		<string>SimSunNew</string>
	</test>
	<edit name="rgba" mode="assign">
		<const>rgb</const>
	</edit>
	<edit name="antialias" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="autohint" mode="assign" >
		<bool>false</bool>
	</edit>
	<edit name="hinting" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="hintstyle" mode="assign" >
		<const>hintslight</const>
	</edit>
</match>

<match target="font" >
	<test target="pattern" name="lang" compare="contains" >
		<string>zh</string>
	</test>
	<test name="spacing" compare="eq" >
		<const>dual</const>
	</test>
	<edit name="spacing" mode="assign" >
		<const>proportional</const>
	</edit>
	<edit name="globaladvance" mode="assign" >
		<bool>false</bool>
	</edit>
</match>

<match target="font">
	<test name="lang" compare="contains" >
		<string>zh</string>
	</test>
	<test name="outline" compare="eq" >
		<bool>false</bool>
	</test>
	<test name="spacing" compare="eq" >
		<const>mono</const>
		<const>charcell</const>
	</test>
	<edit name="spacing">
		<const>proportional</const>
	</edit>
	<edit name="globaladvance" binding="strong" >
		<bool>false</bool>
	</edit>
</match>

<!-- Chinese Simple Font -->
<match target="font" >
	<test qual="any" name="family" compare="eq" >
		<string>Microsoft YaHei</string>
	</test>
	<edit name="rgba" mode="assign">
		<const>rgb</const>
	</edit>
	<edit name="antialias" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="autohint" mode="assign" >
		<bool>false</bool>
	</edit>
	<edit name="hinting" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="hintstyle" mode="assign" >
		<const>hintslight</const>
	</edit>
</match>

<!-- Chinese Tradition Font -->
<match target="font" >
	<test qual="any" name="family" compare="eq" >
		<string>Microsoft JhengHei</string>
	</test>
	<edit name="rgba" mode="assign">
		<const>rgb</const>
	</edit>
	<edit name="antialias" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="autohint" mode="assign" >
		<bool>false</bool>
	</edit>
	<edit name="hinting" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="hintstyle" mode="assign" >
		<const>hintslight</const>
	</edit>
</match>

<!-- SimSunNew global setting. -->
<match target="font" >
	<test qual="any" name="family" compare="eq" >
		<string>SimSunNew</string>
	</test>
	<edit name="rgba" mode="assign" >
		<const>rgb</const>
	</edit>
	<edit name="antialias" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="autohint" mode="assign" >
		<bool>false</bool>
	</edit>
	<edit name="hinting" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="hintstyle" mode="assign" >
		<const>hintslight</const>
	</edit>
</match>

<!--
SimSunNew embedded bitmap fonts, ppem = 12px, 13px, 14px, 15px, 16px, 18px.
choose as your need
-->
<match target="font" >
	<test qual="any" name="family" compare="eq" >
		<string>SimSunNew</string>
	</test>
	<test name="pixelsize" compare="more" >
		<double>11.5</double>
	</test>
	<test name="pixelsize" compare="less" >
		<double>18.5</double>
	</test>
	<edit name="antialias" mode="assign" >
		<bool>false</bool>
	</edit>
</match>

<match target="font" >
	<test qual="any" name="family" compare="eq" >
		<string>SimSunNew</string>
	</test>
	<test name="pixelsize" compare="more" >
		<double>16.5</double>
	</test>
	<test name="pixelsize" compare="less" >
		<double>17.5</double>
	</test>
	<edit name="antialias" mode="assign" >
		<bool>true</bool>
	</edit>
</match>

<!-- Synthetic emboldening for fonts that do not have bold face available -->
<match target="font" >
	<test name="weight" compare="less_eq">
		<const>medium</const>
	</test>
	<test target="pattern" name="weight" compare="more">
		<const>medium</const>
	</test>
	<edit name="embolden" mode="assign" >
		<bool>true</bool>
	</edit>
	<edit name="weight" mode="assign">
		<const>bold</const>
	</edit>
</match>

</fontconfig>

{% endhighlight %}

####中文输入法
emerge scim scim-pinyin (本文例子是scim)

或者 emerge ibus

或者 emerge fcitx (推荐)

####中文编码配置
推荐:
+ 终端

---

编辑~/.bashrc

LC_CTYPE="zh_CN.UTF-8"

+ X窗口

---

编辑~/.xinitrc
{% highlight c %}
export LC_CTYPE="zh_CN.GBK"
export XMODIFIERS='@im=SCIM'
export XIM="scim"
export XINPUT="scim"
export XIM_PROGRAM="scim -d"
export GTK_IM_MODULE="scim"
export QT_IM_MODULE="xim"
export OOO_FORCE_DESKTOP=gnome   (Openoffice usescim)
export XDG_MENU_PREFIX=gnome-    (QT Program like opera use scim)

scim -d &

exec gnome-session
{% endhighlight %}


####乱码问题
+ EMACS乱码：

---

emacs默认使用X核心字体，显示比较难看，有些中文显示为方框。加上xft后，emacs可以使用系统字体，非常美观，中文也显示正常了。使用USE＝“Xft”emerge emacs

+ VIM中文乱码：

---

编辑~/.vimrc,添加 set fileencoding=gbk 和 set fileencodings=utf-8,gbk

+ 挂载windows盘乱码问题

---

在内核中FileSystem设置Native file system选项加上utf8，或者挂载磁盘时设置编码 mount ／dev/sda5 /mnt/udisk -o iocharset=utf-8

<!-- more end -->