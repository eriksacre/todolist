$ ->
	$(document).on 'ajaxSend', ->
		$("body").removeClass("ajax-completed")
		
	$(document).on 'ajaxComplete', ->
		$("body").addClass("ajax-completed")

	$("#add-task").click (event) ->
		$(this).hide()
		$("#add-task-form").show()
		$("#task_title").focus()
		event.preventDefault()
		
	$("#cancel-task-form").click (event) ->
		$("#add-task-form").hide()
		$("#add-task").show()
		event.preventDefault()
		
	$("#show-more a").click (event) ->
		$(this).addClass('loading')

	$(document).on 'click', 'input[type=checkbox].todo', ->
		ajaxUpdater.update(this)

	$(document).ajaxError (event, jqxhr, settings, exception) ->
		ajaxUpdater.setError(exception)

	ajaxUpdater = 
		element: null

		update: (element, method = 'POST', dataSet = {}) ->
			@element = element
			this.clearError()
			this.setLoader()
			$.ajax
				type: method
				url: $(element).data('url')
				data: JSON.stringify(dataSet)
				contentType: 'application/json'
				dataType: 'script'
				complete: ->
					$(@element).next('label').removeClass('loading')

		clearError: ->
			$("#ajax-error").html("")

		setError: (exception) ->
			$("#ajax-error").html(exception)

		setLoader: ->
			$(@element).next('label').addClass('loading')

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
			this.appendAndHighlight("#incomplete-tasks", task)
			
		completeTask: (task) ->
			this.prependAndHighlight("#complete-tasks", task)
		
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
			$("#add-task-form form input[type=submit]").removeAttr("disabled")
			
		highlightTask: (taskId) ->
			$("#L#{taskId}").highlight()
			
		appendAndHighlight: (id, task) ->
			$(id).append(task)
			$(id).children('li').last().highlight()
		
		prependAndHighlight: (id, task) ->
			$(id).prepend(task)
			$(id).children('li').first().highlight()

		attachFormEvents: (taskId) ->
			id = "#edit_task_#{taskId}"
			this.attachFormEventsForId(id)
			
		attachFormEventsForId: (id) ->
			$(id).on "submit", ->
				$("#{id} input[type=submit]").attr("disabled", "disabled")
			$(id).on "ajax:before", ->
				$("#{id} .spinner").addClass("spinning")
			$(id).on "ajax:complete", ->
				$("#{id} .spinner").removeClass("spinning")

	list.attachFormEventsForId("#new_task")		

	$("#incomplete-tasks").bind 'sortupdate', (e, ui) ->
		list.changePosition(ui.item, ui.item.index())

