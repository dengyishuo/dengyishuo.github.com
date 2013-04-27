
window.addEvent('domready', function(){

	$$('#thumbs li').each(function(thumb){
		new Thumbnail(thumb);
	});

});

Native.implement([Element, Window, Document, Events], {
	oneEvent : function(type, fn) {
		return this.addEvent(type, function() {
			this.removeEvent(type, arguments.callee);
			return fn.apply(this, arguments);
		});
	}
});

var Thumbnail = new Class({
	Implements: Events,
	
	initialize: function(element){
		this.element = $(element);
		
		// create zoom icons for each thumbnail
		var zoom = $E('div.zoom').fade('hide');
		
		var thumb = this.element.getFirst('.thumb').grab(zoom).addEvents({
			mouseenter : zoom.fade.pass('in', zoom),
			mouseleave : zoom.fade.pass('out', zoom)
		});
		var first = thumb.get('href');
		
		// parse number of pages and image paths
		this.pages = (thumb.className.match(/pages-(\d+)/) || [0,1])[1];
		
		this.paths = [first];
		for (var i = 1; i < this.pages; i++)
			this.paths[i] = first.replace(/\d+(?=\.jpe?g|png$)/i, i + 1);
		
		// preload first image on rollover
		thumb.oneEvent('mouseenter', function(){
			new Asset.image(first);
		});
		
		// build overlay
		this.overlay = $E('div.overlay').adopt(
			this.element.getFirst('.link').clone(),
			this.element.getFirst('.details')
		).fade('hide');
		
		var bg = $E('div.zoom-mask').hide().fade('hide').inject(document.body);
		
		// setup having multiple pages
		if (this.pages > 1) this.buildPages();
		
		// ReMoooooz
		var self = this;
		new ReMooz(thumb, {
			link : first,
			resizeLimit : {x: 640, y: 1000},
			opacityResize : 0.2,
			centered : true,
			draggable : false,
			onBuild : function(){
				this.body.grab(self.overlay).addEvents({
					mouseenter : self.toggleOverlay.pass(true, self),
					mouseleave : self.toggleOverlay.pass(false, self)
				});
			},
			onOpen : function(){
				var close = this.close.bind(this);
				document.addKey('esc', close);
				this.box.oneEvent('clickout', close);
				self.fireEvent('open', this.content);
				zoom.fade('hide');
			},
			onOpenEnd : function(){
				self.open = true;
				this.body.fireEvent('mouseenter');
				bg.show().fade(0.3);
			},
			onClose : function(){
				document.removeKey('esc');
				this.box.removeEvents('clickout');
				this.body.fireEvent('mouseleave');
				self.open = false;
				self.fireEvent('close');
				bg.fade(0, bg.hide.bind(bg));
			}
		});
	},
	
	toggleOverlay: function(show){
		if (!this.open) return this;
		if (Browser.Engine.trident)
			this.overlay.fade(show ? 'show' : 'hide');
		else
			this.overlay.morph({
				bottom : show ? 0 : -50,
				opacity : show ? 1 : 0
			});
		
		return this;
	},
	
	buildPages: function(){
		var arrows = ['prev', 'next'].map(function(way, i){
			return $E('div', {
				'class': way,
				'opacity': 0.6,
				'events': {
					click: this.change.pass(2 * i - 1, this),
					mouseenter: function(){ this.fade(1);   },
					mouseleave: function(){ this.fade(0.6); }
				}
			});
		}, this);
		
		var pagination = $E('div.pagination');
		this.overlay.adopt(arrows).grab(pagination, 'top');
		
		this.addEvents({
			change: function(page){
				this.page = page || 0;
				pagination.set('text', ['page', this.page + 1, 'of', this.pages].join(' '));
			},
			open: function(){
				document.addKeys({
					left:  arrows[0].fireEvent.pass('click', arrows[0]),
					right: arrows[1].fireEvent.pass('click', arrows[1])
				});
			},
			close: function(){
				document.removeKey('left', 'right');
			}
		}).fireEvent('change');
		
		// preload other images
		return this.oneEvent('open', function(first){
			this.images = [first].concat( new Asset.images(this.paths.slice(1)) );
		});
	},
	
	change: function(page){
		if (this.lock) return this;
		this.lock = true;
		
		page += this.page;
		if (page < 0) page = this.pages - 1;
		else if (page >= this.pages) page = 0;
		
		var self = this;
		this.images[this.page].grab(this.images[page], 'before').fade('out', function(){
			this.dispose().fade('show');
			self.lock = false;
		});
		
		return this.fireEvent('change', page);
	}
});


// Events

Native.implement([Element, Window, Document], {
	addKey : function(combo, fn) {
		var keys = this.retrieve('events:keys', {});
		if (keys[combo]) this.removeKey(combo);		// one shortcut at a time
		
		var mods = combo.split('+');
		var key = mods.pop();
		
		keys[combo] = function(event) {
			for (var i = mods.length; i--; ) if (!event[mods[i]]) return;
			if (event.key == key || event.code == key)
				return fn.apply(this, arguments);
		};
		
		return this.addEvent('keyup', keys[combo]);
	},
	
	addKeys : function(keys) {
		for (var combo in keys) this.addKey(combo, keys[combo]);
		return this;
	},
	
	removeKey : function() {
		var keys = this.retrieve('events:keys', {});
		
		Array.flatten(arguments).each(function(combo) {
			if (!keys[combo]) return;
			this.removeEvent('keyup', keys[combo]);
			delete keys[combo];
		}, this);
		
		return this;
	},
	
	oneKey : function(combo, fn) {
		return this.addKey(combo, function() {
			return fn.apply(this.removeKey(combo), arguments);
		});
	}
});

// http://devthought.com/tumble/2009/04/determine-if-caps-lock-is-on-with-mootools/
Event.implement({
   hasCapsLock: function(){
	  return ((this.code > 64 && this.code < 91 && !this.shift) 
		   || (this.code > 96 && this.code < 123 && this.shift));
   }
});

Event.Keys.extend({
	'pageup' : 33,
	'pagedown' : 34,
	'end' : 35,
	'home' : 36,
	'capslock' : 20,
	'numlock' : 144,
	'scrolllock' : 145
});

Element.Events.clickout = {
	base: 'click',
	condition: function(event){
		event.stopPropagation();
		return false;
	},
	onAdd: function(fn){
		this.getDocument().addEvent('click', fn);
	},
	onRemove: function(fn){
		this.getDocument().removeEvent('click', fn);
	}
};
