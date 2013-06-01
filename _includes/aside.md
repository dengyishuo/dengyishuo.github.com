<aside>
      <ul id="side" class="clear">
        <li class="widget">
          <h3 class="widgettitle title">分类目录</h3>
          <ul class="categories">
              {% for cat in site.categories %}
                <li><a href="/categories.html#{{ cat[0] }}-ref" title="{{ cat[0] }}" rel="{{ cat[1].size }}">{{ cat[0] }} <sup>({{ cat[1].size }})</sup></a></li>
              {% endfor %}
          </ul>
        </li>
        <li class="widget">
          
          <h3 class="widgettitle  title">近期文章</h3>
          <ul class="posts">
            {% for post in site.posts limit: 5 %}
              <li><a href="{{ post.url }}" title="{{ post.title }}">{{ post.title }}</a></li>
            {% endfor %}
          </ul>
        </li>
        <li class="widget">
          <h3 class="widgettitle  title">近期评论</h3>
          <ul class="comments">
            <script type="text/javascript" src="http://yishuo.disqus.com/recent_comments_widget.js?num_items=5&hide_avatars=0&avatar_size=32&excerpt_length=50">
            </script>
          </ul>
        </li>
        <li class="widget">
          <h3 class="widgettitle  title">友情链接</h3>
          <ul class='blogroll'>
		    <li><a href="http://quantmod.com">Quantmod</a></li>
            <li><a href="http://cos.name">统计之都</a></li>
            <li><a href="http://yihui.name">谢益辉</a></li>
			<li><a href="http://linhui.org">林荟</a></li>
			<li><a href="http://yanping.me">陈堰平</a></li>
			<li><a href="http://yixuan.cos.name/">邱怡轩</a></li>
			<li><a href="http://www.bjt.com">刘思喆</a></li>
			<li><a href="http://taiyun.cos.name">魏太云</a></li>
			<li><a href="http://www.road2stat.com/">肖楠</a></li>
          </ul>
        </li>
      </ul>
</aside>