define [
    'jquery', 'backbone', 'backbone.marionette',
    'models/person',
    'templates/people/personDetailsTemplate',
    'views/details_view'    
  ], (
    $, Backbone, Marionette,
    Person,
    personDetailsTemplate,
    DetailsView
  ) ->

  class PersonDetailsView extends Backbone.Marionette.ItemView
    template: personDetailsTemplate

    behaviors:
      DetailsView: 
        behaviorClass: DetailsView,
        pagesList: ['companies', 'details', 'tasks', 'opportunities'],
        openEvent: 'company_details:open',
        childLink: '.company_link'

    events: 
      'click #edit_btn': 'edit_person'
      'click #to_list_btn' : 'to_people'

    initialize: (options) ->
      if (options.app)
        @app = options.app

      if (!@model)
        @model = new Person(id: options.id)
      @listenTo(@model, 'change', @render)
      @model.fetch(error: @error_handler, reset: true)

    error_handler: (model, response, options) ->
      console.log(response.responseText)

    edit_person: ->
      Backbone.trigger('person_edit:open', @model.get('id'))

    to_people: ->
      Backbone.trigger('people:open')
      