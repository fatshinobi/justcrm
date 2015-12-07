define [
    'jquery', 'backbone', 'backbone.marionette',
    'templates/companies/companyEditTemplate',
    'lookUpView',
    'libs/backbone.syphon'
  ], (
    $, Backbone, Marionette,
    companyEditTemplate, LookUpView,
    Syphon
  ) ->
  class CompanyEditView extends Backbone.Marionette.ItemView
    template: companyEditTemplate

    ui:
      curator_list : '#curator_list'

    events:
      'click #submit': 'save_company'
      'click #details_btn': 'go_to_details'
      'click #to_list_btn' : 'to_companies'    

    initialize: (options) ->
      _.bindAll(@, 'on_save', 'refresh_collection')
      
      if (options.app)
        @app = options.app

    onRender: ->
      for user in @app.users_collection.models
        selected = if user.get('id') == @model.get('user_id') then 'selected' else ''
        @ui.curator_list.append("<option #{selected} value='#{user.get('id')}'>#{user.get('name')}</options>")

    go_to_details: ->
      Backbone.trigger('company_details:open', @model.get('id'))

    to_companies: ->
      Backbone.trigger('companies:open')

    save_company: (event) ->
      if (event)
        event.preventDefault()
      @data = Backbone.Syphon.serialize(@)

      that = @
      @model.on('error', (model, response) ->
        attributes_with_errors = JSON.parse(response.responseText)
        for err_field in Object.keys(attributes_with_errors.errors)
          that.$("input##{err_field}").parent().addClass('has-error')
          for error_message in attributes_with_errors.errors[err_field]
            that.$("input##{err_field}").parent().append("<span class='help-block'>#{error_message}</span>")
      )

      f_data = new FormData()
      if @$('form #ava')[0].files[0]
        f_data.append('company[ava]', @$('form #ava')[0].files[0])
        @model.new_file = @$('form #ava')[0].files[0]

      for key in Object.keys(@data)
        f_data.append("company[#{key}]", @data[key])

      if (@model.id != 0)
        @model.save({company: f_data}, {success: @on_save}, {patch: true})
      else
        @model.save({company: f_data}, {success: @on_save})

    refresh_collection: (model) ->
      cur_model = @app.companies_collection.get(model.id)
      if cur_model
        if model.new_file
          @data.ava = {ava: {thumb: url : "/uploads/test/company/ava/#{model.id}/thumb_#{model.new_file.name}"}}
        cur_model.set(@data)
      else
        if model.new_file
          model.set('ava', {ava: {thumb: url : "/uploads/test/company/ava/#{model.id}/thumb_#{model.new_file.name}"}})
        @app.companies_collection.fullCollection.add(model)

    on_save: (model, response) ->
      if @app.companies_collection
        @refresh_collection(model)

      Backbone.trigger('company_details:open', model.get('id'))
    
