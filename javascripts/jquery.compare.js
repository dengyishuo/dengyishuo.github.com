(function($){ 
	$.fn.compare = function(options)
	{
		$(this).each(function(index, one){
			var first = $(one).find('img:first');
			var other = $(one).find('img:last');

			//Hide all but the first:
			$(one).find('img').hide();
			first.show();

			$(one).mouseover(function(){
				first.hide();
				other.show();
			}).mouseout(function(){
				other.hide();
				first.show();
			});
		});
		
	}
})(jQuery);