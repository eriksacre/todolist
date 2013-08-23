$ ->

  KLASS = "ajax-completed"

  $(document.body)
    .on "ajax:before", ->
      $(this).removeClass(KLASS)
    .on "ajax:complete", ->
      $(this).addClass(KLASS)

