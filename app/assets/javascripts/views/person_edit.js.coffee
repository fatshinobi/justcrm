define [
    'jquery', 'backbone', 'backbone.marionette',
    'templates/people/personEditTemplate',
    'lookUpView',
    'libs/backbone.syphon',
    'views/edit_view'
  ], (
    $, Backbone, Marionette,
    personEditTemplate, LookUpView,
    Syphon, EditView
  ) ->
  class PersonEditView extends Backbone.Marionette.ItemView
    template: personEditTemplate

    behaviors:
      EditView: 
        behaviorClass: EditView,
        elementType: 'person',
        detailsEvent: 'person_details:open'

    ui:
      new_company_name : '#new_company_name'
      new_company_id : '#new_company_id'
      new_company_role : '#add_role'

      list_of_companies : '#list_of_companies'

    events:
      'click #details_btn': 'go_to_details'
      'click #to_list_btn' : 'to_people'    
      'click #add_company_btn': 'add_new_company'
      'click .delete_company_entry': 'delete_company'

    initialize: (options) ->
      if (options.app)
        @app = options.app

    onShow: ->
      company_view = new LookUpView('#companies_look_up', 'companies')
      company_view.init()

    error_handler: (model, response, options) ->
      console.log(response.responseText)

    data_load: (model, response, options) ->
      #t = Backbone.Syphon.deserialize(@, model)

    parse_companies: ->
      @companies = @get('companies')

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

    users_collection: ->  
      @app.users_collection.models

    get_collection: ->
      @app.people_collection

    setup_childs: (data) ->
      companies = if @model.get('companies') then @model.get('companies') else []

      data.company_people_attributes = companies.map( (link) ->
        {id: link.id, role: link.role, company_id: link.company.id, new_company_name: link.new_company_name, _destroy: if link.is_delete then '1' else 'false'}
      )
      
    to_people: ->
      Backbone.trigger('people:open')

    go_to_details: ->
      Backbone.trigger('person_details:open', @model.get('id'))
    
