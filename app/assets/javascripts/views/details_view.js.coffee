define ['jquery', 'backbone', 
      'backbone.marionette'
    ], ($, Backbone, 
      Marionette
    ) ->
  class DetailsView extends Backbone.Marionette.Behavior
    initialize: ->
      @.events = {}
      @events["click #{@options.childLink}"] = 'open_child'
      that = @
      for page in @options.pagesList
      	do (page) ->
          that.events["click ##{page}_link"] = "show_#{page}"
          that.events["show_#{page}"] = "show_#{page}"
          that["show_#{page}"] = ->
            that.activate_page(page)
            that.set_tab(page)


    set_tab: (current) ->
      for tab in @options.pagesList
        if tab == current
          @view.$("##{tab}_tab").addClass('active')
        else
          @view.$("##{tab}_tab").removeClass('active')

    activate_page: (current) ->
      for page in @options.pagesList
        if page == current
          @view.$("##{page}_div").removeClass('hiden_form_page')
        else
          @view.$("##{page}_div").addClass('hiden_form_page')

    open_child: (event) ->
      btn = $(event.currentTarget)
      child_id = btn.get(0).dataset.button
      Backbone.trigger(@options.openEvent, child_id)
