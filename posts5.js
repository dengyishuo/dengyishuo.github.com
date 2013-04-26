---
layout: nil
---
$(document).ready(function() {
	var post = {
	"list":[{% for post in site.posts limit:5 %}{
	    "title":"{{post.title}}",
        "url":"{{site.url}}{{post.url}}",
        "date":"{{post.date|date_to_string}}"
    }{% if forloop.last == false %},{% endif %}
{% endfor %}

	]};	
});			

