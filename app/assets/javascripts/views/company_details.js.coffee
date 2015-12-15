define [
    'jquery', 'backbone', 'backbone.marionette',
    'models/company',
    'templates/companies/companyDetailsTemplate',
    'views/details_view'
  ], (
    $, Backbone, Marionette,
    Company,
    companyDetailsTemplate,
    DetailsView
  ) ->

  class CompanyDetailsView extends Backbone.Marionette.ItemView
    template: companyDetailsTemplate 

    behaviors:
      DetailsView: 
        behaviorClass: DetailsView,
        pagesList: ['people', 'details', 'tasks', 'opportunities'],
        openEvent: 'person_details:open',
        childLink: '.person_link'        

    events: 
      'click #edit_btn': 'edit_company'
      'click #to_list_btn' : 'to_companies'

    initialize: (options) ->
      if (!@model)
        @model = new Company(id: options.id)
      @listenTo(@model, 'change', @render)
      @model.fetch(error: @error_handler, reset: true)

    error_handler: (model, response, options) ->
      console.log(response.responseText)

    edit_company: ->
      Backbone.trigger('company_edit:open', @model.get('id'))

    to_companies: ->
      Backbone.trigger('companies:open')
