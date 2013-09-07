$ ->
	$(document).on "page:fetch", ->
		$('#updating-page').show()
		
	$(document).on "page:receive", ->
		$('#updating-page').hide()