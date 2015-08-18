class @Semaphore
  constructor: ->
    @view_list = []

  init: ->
    for view in @view_list
      @set_view_event(view)

  set_view_event: (view)->
    that = @
    view.text_field.on('keyup', ->
      that.clear_prevent_results(view))

  add: (view) ->
    @view_list.push view

  clear_prevent_results: (current)->
    for view in @view_list
      if view != current
        view.result_div.html('')