$ ->
	$(document).on 'ajaxSend', ->
		$("body").removeClass("ajax-completed")
		
	$(document).on 'ajaxComplete', ->
		$("body").addClass("ajax-completed")
