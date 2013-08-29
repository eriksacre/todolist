$ ->
	$(document).on 'click', '#add-task', (event) ->
		$(this).hide()
		$("#add-task-form").show()
		$("#task_title").focus()
		event.preventDefault()
		
	$(document).on 'click', "#cancel-task-form", (event) ->
		$("#add-task-form").hide()
		$("#add-task").show()
		event.preventDefault()
		
	$(document).ajaxError (event, jqxhr, settings, exception) ->
		$("#ajax-error").html(exception)

	ajaxUpdater = 
		update: (element, method = 'POST', dataSet = {}) ->
			$("#ajax-error").html("")
			$(element).nextAll('label').addClass('loading')
			$.ajax
				type: method
				url: $(element).data('url')
				data: JSON.stringify(dataSet)
				contentType: 'application/json'
				dataType: 'script'

	# We wait to capture a mousedown on a move-handle before initializing the
	# sortable feature set.
	document.addEventListener "mousedown", (event) ->
			if ($(event.target).closest(".handle").length)
				$(event.target).closest(".sortable").sortable("destroy").sortable({ handle: '.handle' })
		, true
		
	# Here are methods exposed to the JS templates
	window.list =
		changePosition: (item, new_position) ->
			mover = item.children().first('.handle')
			data = { task: { position: new_position } }
			ajaxUpdater.update(mover.get(0), 'POST', data)
		
		addTask: (task) ->
			@appendAndHighlight("#incomplete-tasks", task)
			
		completeTask: (task) ->
			@prependAndHighlight("#complete-tasks", task)
		
		removeTask: (taskId) ->
			$("#L#{taskId}").remove()
			
		replaceHtml: (taskId, html) ->
			$("#L#{taskId}").html(html)

		replaceRow: (taskId, html) ->
			$("#L#{taskId}").replaceWith(html)
			
		focusOnText: (taskId) ->
			$("#edit_task_#{taskId} input[name='task[title]']").focus()
			
		prepareFormForNextEntry: ->
			$("#task_title").val('').focus()
			
		highlightTask: (taskId) ->
			$("#L#{taskId}").highlight()
			
		appendAndHighlight: (id, task) ->
			$(id).append(task)
			$(id).children('li').last().highlight()
		
		prependAndHighlight: (id, task) ->
			$(id).prepend(task)
			$(id).children('li').first().highlight()

	$(document).on 'sortupdate', "#incomplete-tasks", (e, ui) ->
		list.changePosition(ui.item, ui.item.index())

	# All of the following event code exists solely to show a progress spinner
	$(document).on "ajax:before", "form", ->
		$(this).children('.spinner').addClass("spinning")
		
	$(document).on "ajax:complete", "form", ->
		$(this).children('.spinner').removeClass("spinning")

	$(document).on "ajax:before", "input[type='checkbox']", ->
		$(this).nextAll('label').addClass('loading')

	$(document).on 'click', "#show-more a", (event) ->
		$(this).addClass('loading')

