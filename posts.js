---
layout: nil
---

$(document).ready(function() {
	
	
	var post = {
	list:[{% for post in site.posts limit:5 %}{
	    "title":"{{post.title}}",
        "url":"{{site.url}}{{post.url}}",
        "date":"{{post.date|date_to_string}}"
    }{% if forloop.last == false %},{% endif %}
{% endfor %}

	]};	
			
	var content ="<ul class=\"compact recent\">";
	$.each(post.list,function(i,item){
	
	content += "<li><span class=\"date\">"+ item.date + "</span><a href=\""+item.url+"\">"+ item.title +"</a></li>";
	
	});
	
	content +="</ul>";
	$("#blog2-posts-list .loading").remove();
	$("#blog2-posts-list").append(content);
			
});	
