<nav class="navigation">
  {% if paginator.previous_page %}
    {% if paginator.previous_page == 1 %}
      <span class="previous"><a href="/"><前页</a></span>
    {% else %}
      <span class="previous"><a href="/page{{paginator.previous_page}}"><前页</a></span>
    {% endif %}
  {% else %}
    <span class="previous disabled"><前页</span>
  {% endif %}
  {% if paginator.page == 1 %}
      <span class="current-page">1</span>
  {% else %}
      <a href="/">1</a>
  {% endif %}
  {% for count in (2..paginator.total_pages) %}
      {% if count == paginator.page %}
      <span class="current-page">{{count}}</span>
  {% else %}
      <a href="/page{{count}}">{{count}}</a>
      {% endif %}
  {% endfor %}
  {% if paginator.next_page %}
  <span class="next"><a class="next" href="/page{{paginator.next_page}}">后页></a></span>
  {% else %}
    <span class="next disabled" >后页></span>
  {% endif %}
  (共{{ paginator.total_posts }}篇)
  <div class="clear"></div>
</nav>
