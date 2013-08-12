$ ->
	$("#add-task").click (event) ->
		$(this).hide();
		$("#add-task-form").show();
		$("#task_title").focus();
		event.preventDefault()
		
	$("#cancel-task-form").click (event) ->
		$("#add-task-form").hide()
		$("#add-task").show()
		event.preventDefault()
		
	$("#add-task-form form").submit ->
		$("#add-task-form form input[type=submit]").attr("disabled", "disabled")

	$("#add-task-form form").on "ajax:before", ->
		$(".spinner").addClass("spinning")

	$("#add-task-form form").on "ajax:complete", ->
		$(".spinner").removeClass("spinning")

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

	$("#incomplete-tasks").bind 'sortupdate', (e, ui) ->
		mover = ui.item.children().first('.handle')
		data = { task: { position: ui.item.index() } }
		ajaxUpdater.update(mover.get(0), 'PUT', data)

	# We wait to capture a mousedown on a move-handle before initializing the
	# sortable feature set.
	document.addEventListener "mousedown", (event) ->
			if ($(event.target).closest(".handle").length)
				$("#incomplete-tasks").sortable("destroy").sortable({ handle: '.handle' })
		, true
		
	# Here are methods exposed to the JS templates
	window.list =
		addTask: (task) ->
			this.appendAndHighlight("#incomplete-tasks", task)
			
		completeTask: (task) ->
			this.prependAndHighlight("#complete-tasks", task)
		
		removeTask: (taskId) ->
			$("#t" + taskId).closest("li").remove()
			
		prepareFormForNextEntry: ->
			$("#task_title").val('').focus()
			$("#add-task-form form input[type=submit]").removeAttr("disabled")
			
		highlightUpdatedPosition: (position) ->
			$("#incomplete-tasks").children('li').eq(position).highlight()
			
		appendAndHighlight: (id, task) ->
			$(id).append(task)
			$(id).children('li').last().highlight()
		
		prependAndHighlight: (id, task) ->
			$(id).prepend(task)
			$(id).children('li').first().highlight()

		