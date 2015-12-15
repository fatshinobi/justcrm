define ['jquery', 'backbone', 
      'backbone.marionette',
      'libs/backbone.syphon'
    ], ($, Backbone, 
      Marionette, Syphon
    ) ->
  class EditView extends Backbone.Marionette.Behavior
    ui:
      curator_list : '#curator_list'

    events:
      'click #submit': 'save_element'

    initialize: ->
      _.bindAll(@, 'refresh_collection', 'on_save')
      mode = $("meta[name='rails_mode']").attr('content')

      @file_path = if mode == 'production' then 'production' else 'test'

    onRender: ->
      for user in @view.users_collection()
        selected = if user.get('id') == @view.model.get('user_id') then 'selected' else ''
        @ui.curator_list.append("<option #{selected} value='#{user.get('id')}'>#{user.get('name')}</options>")

    save_element: (event) ->
      if (event)
        event.preventDefault()
      @data = Backbone.Syphon.serialize(@view)

      @view.setup_childs(@data)

      that = @
      @view.model.on('error', (model, response) ->
        attributes_with_errors = JSON.parse(response.responseText)
        for err_field in Object.keys(attributes_with_errors.errors)
          that.$("input##{err_field}").parent().addClass('has-error')
          for error_message in attributes_with_errors.errors[err_field]
            that.$("input##{err_field}").parent().append("<span class='help-block'>#{error_message}</span>")
      )

      f_data = new FormData()
      if @$('form #ava')[0].files[0]
        f_data.append("#{@options.elementType}[ava]", @$('form #ava')[0].files[0])
        @view.model.new_file = @$('form #ava')[0].files[0]

      for key in Object.keys(@data)
        if (@data[key] instanceof Array)
          for elem in @data[key]
            for child_key in Object.keys(elem)
              child_val = if elem[child_key] then elem[child_key] else ''
              f_data.append("#{@options.elementType}[#{key}][#{child_key}]", child_val)
        else
          f_data.append("#{@options.elementType}[#{key}]", @data[key])

      if (@view.model.id != 0)
        @view.model.save({"#{@options.elementType}": f_data}, {success: @on_save}, {patch: true})
      else
        @view.model.save({"#{@options.elementType}": f_data}, {success: @on_save})

    refresh_collection: (model, response) ->
      cur_model = @view.get_collection().get(model.id)
      if cur_model
        if model.new_file
          @data.ava = {ava: {thumb: url : "/uploads/#{@file_path}/#{@options.elementType}/ava/#{model.id}/thumb_#{model.new_file.name}"}}
        cur_model.set(@data)
      else
        if model.new_file
          model.set('ava', {ava: {thumb: url : "/uploads/#{@file_path}/#{@options.elementType}/ava/#{model.id}/thumb_#{model.new_file.name}"}})
        @view.get_collection().fullCollection.add(model)

      Backbone.trigger(@options.detailsEvent, model.get('id'))

    on_save: (model, response) ->
      if @view.get_collection()
        @refresh_collection(model)
