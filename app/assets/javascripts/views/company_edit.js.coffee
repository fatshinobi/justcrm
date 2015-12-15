define [
    'jquery', 'backbone', 'backbone.marionette',
    'templates/companies/companyEditTemplate',
    'lookUpView',
    'libs/backbone.syphon',
    'views/edit_view'    
  ], (
    $, Backbone, Marionette,
    companyEditTemplate, LookUpView,
    Syphon, EditView
  ) ->
  class CompanyEditView extends Backbone.Marionette.ItemView
    template: companyEditTemplate

    behaviors:
      EditView: 
        behaviorClass: EditView,
        elementType: 'company',
        detailsEvent: 'company_details:open'

    events:
      'click #details_btn': 'go_to_details'
      'click #to_list_btn' : 'to_companies'    

    initialize: (options) ->
      if (options.app)
        @app = options.app

    go_to_details: ->
      Backbone.trigger('company_details:open', @model.get('id'))

    to_companies: ->
      Backbone.trigger('companies:open')
    
    users_collection: ->  
      @app.users_collection.models

    get_collection: ->
      @app.companies_collection

    setup_childs: (data) ->
