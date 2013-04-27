
var Site = new Events;

Site.live = !(/localhost|github|dev/i).test(location.host);

window.addEvents({

	domready: function(){
	},
	
	load: function(){
		new Analytics;
	}
	
});


// Main Nav

var Nav = new Class({
	
	initialize: function(element){
		element = this.element = $(element);
		var active = this.active = { length: 0 };
		
		element.getChildren('li').each(this.primary, this);
		
		if (active.link){
			var list = active.link.addClass('active').getParent('ul');
			if (list != element){
				active.section = list.getParent('li');
				this.rest();
			}
		}
	},
	
	primary: function(section){
		this.check(section);
		var list = section.getElement('ul');
		if (!list) return;
		
		list.fade('hide');
		var left, links = list.getElements('li');
		links.each(this.check, this);
		
		section.addEvents({
			
			mouseenter: function(){
				$clear(this.timer);
				if (list == this.open) return;
				
				this.close();
				this.open = list.show();
				if (left == null) left = list.getStyle('left').toInt();
				
				list.morph({
					opacity: 1,
					left: [left - 5, left]
				});
				links.fade('hide');
				
				var i = 0, wave = (function(){
					if (links[i]) links[i++].fade('in');
					else $clear(wave);
				}).periodical(100);
			}.bind(this),
			
			mouseleave: function(){
				if (section != this.active.section)
					this.timer = this.rest.delay(500, this);
			}.bind(this)
			
		});
	},
	
	close: function(){
		if (this.open) this.open.fade('out', function(){
			this.hide();
		});
	},
	
	rest: function(){
		if (this.active.section){
			this.active.section.fireEvent('mouseenter');
		} else {
			this.close();
			this.open = null;
		}
	},
	
	check: function(li){
		var link = li.getFirst('a');
		var path = link.get('relative');
		if (path && location.pathname.indexOf(path) == 0 && path.length > this.active.length){
			this.active.link = link;
			this.active.length = path.length;
		}
	}
	
});


// Footnote Links

var Footnotes = new Class({
	
	initialize: function(links){
		links = $$(links);
		
		links.each(function(link){
			if (link.href.test(/#fn\d+$/))
				link.href = link.href.replace(/[^#]+/, '');
		});
		
		new Fx.SmoothScroll({
		    links: links,
		    wheelStops: false,
		    offset: { y: -10 }
		});
	}
	
});


// Google Analytics

var Analytics = new Class({
	
	path: 'http://www.google-analytics.com/ga.js',
	
	initialize: function(){
		if (Site.live) new Asset.javascript(this.path, { onload: this.onload });
	},
	
	onload: function(){
		try {
			_gat._getTracker('UA-4604812-1')._trackPageview();
		} catch(e) {}
	}
	
});

// Twitter

Request.Twitter = new Class({

	Extends: Request.JSONP,

	options: {
		linkify: true,
		url: 'http://twitter.com/statuses/user_timeline/{term}.json',
		data: {
			count: 5
		}
	},
	
	initialize: function(term, options){
		this.parent(options);
		this.options.url = this.options.url.substitute({term: term});
	},
	
	success: function(data, script){
		if (this.options.linkify) data.each(function(tweet){
			tweet.text = this.linkify(tweet.text);
		}, this);
		
		if (data[0]) this.options.data.since_id = data[0].id; // keep subsequent calls newer
		
		this.parent(data, script);
	},
	
	linkify: function(text){
		// modified from TwitterGitter by David Walsh (davidwalsh.name)
		// courtesy of Jeremy Parrish (rrish.org)
		return text.replace(/(https?:\/\/[\w\-:;?&=+.%#\/]+)/gi, '<a href="$1">$1</a>')
				   .replace(/(^|\W)@(\w+)/g, '$1<a href="http://twitter.com/$2">@$2</a>')
				   .replace(/(^|\W)#(\w+)/g, '$1#<a href="http://search.twitter.com/search?q=%23$2">$2</a>');
	}
	
});


// Utility Functions

var $extend = function(target){
	target = target || {};
	for (var i = 1, l = arguments.length; i < l; i++){
		for (var key in (arguments[i] || {})) target[key] = arguments[i][key];
	}
	return target;
};

var $E = function(tag, props){
	if (typeof props == 'string')
		props = { style : props };
	if (typeof tag == 'string'){
		var id = tag.match(/#([\w-]+)/);
		var classes = tag.match(/(?:\.[\w-]+)+/);
		tag = tag.replace(/[#.].*/, '');
		props = props || {};
		if (id) props.id = id[1];
		if (classes) props['class'] = classes[0].replace(/\./g, ' ');
	}
	return new Element(tag || 'div', props);
};


// Native Extensions

Element.Properties.relative = {
	get: (function(){
		var regex = new RegExp('^' + document.location.protocol + '\/\/' + document.location.host);
		return function(){
			return (!this.href) ? null : this.href.replace(regex, '');
		};
	})()
};

Element.implement({
	
	unmaskEmail: function(){
		var match = this.get('href').match(/^mailto:(.+)-at-dot(\w+)-after-(\S+)/i);
		if (match) this.set('href', 'mailto:' + match[1] + '@' + match[3] + '.' + match[2]);
		return this;
	},
	
	// I like my morph and fade more...
	morph: function(props, duration, callback){
		var fx = this.retrieve('morph');
		
		if (!fx) fx = this.get('morph', {
			link : 'cancel'
		});
		
		if (!callback && typeof duration == 'function'){
			callback = duration;
			duration = null;
		}
		
		fx.options.duration = duration ? Fx.Durations[duration] || duration.toInt() : 500;
		
		if (callback) fx.chain(callback.bind(this));
		fx.start(props);
		return this;
	},
	
	fade: function(how, speed, callback){
		how = $pick(how, 'toggle');
		switch(how){
			case 'show': return this.set('opacity', 1);
			case 'hide': return this.set('opacity', 0);
			case 'in': how = 1; break;
			case 'out': how = 0; break;
			case 'toggle': how = (this.get('opacity') == 1) ? 0 : 1;
		}
		
		return this.morph({ opacity: how }, speed, callback);
	}
});

