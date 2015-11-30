define [
    'jquery', 'backbone', 'backbone.marionette',
    'templates/people/personEditTemplate',
    'lookUpView',
    'libs/backbone.syphon'
  ], (
    $, Backbone, Marionette,
    personEditTemplate, LookUpView,
    Syphon
  ) ->
  class PersonEditView extends Backbone.Marionette.ItemView
    template: personEditTemplate

    ui:
      curator_list : '#curator_list'
      new_company_name : '#new_company_name'
      new_company_id : '#new_company_id'
      new_company_role : '#add_role'

      list_of_companies : '#list_of_companies'

    events:
      'click #submit': 'save_person'
      'click #details_btn': 'go_to_details'
      'click #to_list_btn' : 'to_people'    
      'click #add_company_btn': 'add_new_company'
      'click .delete_company_entry': 'delete_company'

    initialize: (options) ->
      _.bindAll(@, 'on_save')
      if (options.app)
        @app = options.app

    onRender: ->
      for user in @app.users_collection.models
        selected = if user.get('id') == @model.get('user_id') then 'selected' else ''
        @ui.curator_list.append("<option #{selected} value='#{user.get('id')}'>#{user.get('name')}</options>")

    onShow: ->
      company_view = new LookUpView('#companies_look_up', 'companies')
      company_view.init()

    error_handler: (model, response, options) ->
      console.log(response.responseText)

    data_load: (model, response, options) ->
      #t = Backbone.Syphon.deserialize(@, model)

    parse_companies: ->
      @companies = @get('companies')

    save_person: (event) ->
      if (event)
        event.preventDefault()
      @data = Backbone.Syphon.serialize(@)
      companies = if @model.get('companies') then @model.get('companies') else []

      @data.company_people_attributes = companies.map( (link) ->
        {id: link.id, role: link.role, company_id: link.company.id, new_company_name: link.new_company_name, _destroy: if link.is_delete then '1' else 'false'}
      )

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
        f_data.append('person[ava]', @$('form #ava')[0].files[0])
        @model.new_file = @$('form #ava')[0].files[0]

      for key in Object.keys(@data)
        if (@data[key] instanceof Array)
          for elem in @data[key]
            for child_key in Object.keys(elem)
              child_val = if elem[child_key] then elem[child_key] else ''
              f_data.append("person[#{key}][#{child_key}]", child_val)
        else
          f_data.append("person[#{key}]", @data[key])

      if (@model.id != 0)
        @model.save({person: f_data}, {success: @on_save}, {patch: true})
      else
        @model.save({person: f_data}, {success: @on_save})
   
    go_to_details: ->
      Backbone.trigger('person_details:open', @model.get('id'))

    on_save: (model, response) ->
      cur_model = @app.people_collection.get(model.id)
      if cur_model
        if model.new_file
          @data.ava = {ava: {thumb: url : "/uploads/test/person/ava/#{model.id}/thumb_#{model.new_file.name}"}}
        cur_model.set(@data)
      else
        if model.new_file
          model.set('ava', {ava: {thumb: url : "/uploads/test/person/ava/#{model.id}/thumb_#{model.new_file.name}"}})
        @app.people_collection.fullCollection.add(model)

      Backbone.trigger('person_details:open', model.get('id'))

    add_new_company: ->
      new_company_name = if @ui.new_company_id.val() == '' then @ui.new_company_name.val() else ''
      new_company = {
        company: {id: @ui.new_company_id.val(), name: @ui.new_company_name.val()},
        new_company_name: new_company_name,
        role: @ui.new_company_role.val()
      }
    
      if !@model.get('companies')
        @model.set('companies', [])

      @model.get('companies').push(new_company)
 
      @ui.list_of_companies.append("<li><div class='edit_company_entry new_edit_entry'>#{new_company.company.name} #{new_company.role}</div></li>")
 
      @ui.new_company_id.val('')
      @ui.new_company_name.val('')
      @ui.new_company_role.val('')

    delete_company: (event) ->
      btn = $(event.target)
      cur_id = btn.data('button')
      btn.parent().addClass('deleted_edit_entry')
      current_company = (c for c in @model.get('companies') when c.id is cur_id)[0]
      current_company.is_delete = true

    to_people: ->
      Backbone.trigger('people:open')
      