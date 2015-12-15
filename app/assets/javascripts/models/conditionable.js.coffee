define ['jquery'], ($) ->
  Conditionable =
    initialize: ->
      @CONDITIONS_LIST = ["active", "stoped", "removed"]

    is_active: ->
      @get_condition() == "active"
    
    is_stoped: ->
      @get_condition() == "stoped"

    is_removed: ->
      @get_condition() == "removed"

    get_condition: ->
      @CONDITIONS_LIST[@get('condition')]  

    post_status: (action) ->
      $.ajax
        url: "#{@url()}/#{action}"
        type: 'POST'
        dataType: 'json'
        success: ->
          console.log('sync success')

    activate: ->
      @post_status('activate')

    stop: ->
      @post_status('stop')
