这是本人的非学术博客，地址是 http://art.yanping.me
也欢迎大家投稿，邮箱是 chen@yanping.me

我想看看本地库有修改时用git pull会怎么样

版本发生冲突了会怎么样？

要感谢两个人

* [Leslie Michael](http://github.com/lmorchard/) ：我在他的博客<http://decafbad.com/blog>的基础上改的模板，他用了nokogiri和hpricot这两个gem，而且会用到python，我把它们改没了
* [Linghua Zhang](http://github.com/waynezhang) ：分类标签页和文件列表页的代码我用的他博客上的。

几点重要的修改：

* 在文章列表页使用了[waypoints插件](http://imakewebthings.com/jquery-waypoints/)，实现异步加载文章列表 (2012-10-08)
* 用了[展新](http://pizn.github.com)博客里[一篇文章](http://pizn.github.com/2012/03/01/some-tips-for-jekyll-blog.html)的技巧，在显示文章的时候，侧边栏的最近文章列表里不显示当前文章。（2012-09-25）
* 原来的分类标签页上显示了所有的分类，自从学会了用getJson来读取json数据，我就想到用这种方法来动态生成分类页，现在已经在这个网站实现了。这样就不需要用ruby的插件了，在纯静态的同时又保持了一定的动态效果。（2012-09-23）
* 增加了一个合集页（但是我没让它展现在公众面前），用了mootools和remooz的js代码，这个功能我是在<http://appden.github.com/portfolio/>学到的，当时一直没试验成功，后来仔细看代码才知道mootools和jquery不兼容，还好jquery可以用jQuery.noConflict()函数解决冲突。（2012-09-22）
* 采用了[多说](http://duoshuo.com)作为评论系统，提高了加载速度
* 采用了<http://beiyuu.com>博客里的一个段javascript代码，用jquery动态地给指向博客外的链接添加target="_blank"属性
* 采用了[阳志平](http://yangzhipingshi.com/)文章里的两点技巧，一个是post页面下面的[分享按钮](http://jiathis.com)，一个是文章首字放大（用了emphnext类）
* 参加了[豆瓣收藏秀](http://www.douban.com/service/badgemaker)的页面，读书和影视
* 采用了Linghua Zhang[博客](http://lhzhang.com/)里的的标签页代码
* 在右边栏增加了近期文章列表
* 增加了404页面，在404页面里放了采用了google自定义搜索引擎
* 重新组织了页面元素代码，加快加载速度
* DIV边框棱角圆滑处理，图片增加边框阴影
* 增加了返回顶部按钮
