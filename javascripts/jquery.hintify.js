jQuery.fn.hintify = function()
{
	function clearForm(){
		//clear out any hint text before submitting form:
		jQuery('.hinter').filter(function(){
			return jQuery(this).attr("data-hint-text") == jQuery(this).val();
		}).val("");
		return true;
	}

	jQuery(this).parents('form').submit(clearForm);

	jQuery(this).each(function(){
		t = jQuery(this);
		if(!t.attr("data-hint-text")){
			t.attr("data-hint-text",jQuery(this).val());
		}
	}).focus(function(){
		t = jQuery(this);
		if(t.val()==t.attr("data-hint-text")){
			t.val('');
			t.addClass('filled');
		}
	}).blur(function(){
		t = jQuery(this);
		if(t.val()==="")
		{
			t.val(t.attr("data-hint-text"));
			t.removeClass('filled');
	  	}
		else
	  	{
			t.addClass('filled');
	   }
	}).blur();
};