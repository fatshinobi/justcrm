define [
    'jquery', 'backbone', 'backbone.marionette',
    'models/person',
    'templates/people/personDetailsTemplate'
  ], (
    $, Backbone, Marionette,
    Person,
    personDetailsTemplate
  ) ->

  class PersonDetailsView extends Backbone.Marionette.ItemView
    template: personDetailsTemplate

    events: 
      'click #companies_link': 'show_companies'
      'click #details_link': 'show_details'
      'click #tasks_link': 'show_tasks'
      'click #opportunities_link': 'show_opportunities'
    
      'click #edit_btn': 'edit_peson'
      'click #to_list_btn' : 'to_people'

    ui:
      companies_page: '#companies_div'
      details_page: '#details_div'
      tasks_page: '#tasks_div'
      opportunities_page: '#opportunities_div'

      companies_tab: '#companies_tab'
      details_tab: '#details_tab'
      tasks_tab: '#tasks_tab'
      opportunities_tab: '#opportunities_tab'

      edit_link: '#edit_btn'

    initialize: (options) ->
      @pages = [
        @ui.companies_page
        @ui.details_page
        @ui.tasks_page
        @ui.opportunities_page
      ]
      @tabs = [
        @ui.companies_tab
        @ui.details_tab
        @ui.tasks_tab
        @ui.opportunities_tab
      ]

      if (options.app)
        @app = options.app

      if (!@model)
        @model = new Person(id: options.id)
      @listenTo(@model, 'change', @render)
      @model.fetch(error: @error_handler, reset: true)

    error_handler: (model, response, options) ->
      console.log(response.responseText)

    show_companies: ->
      @activate_page(@ui.companies_page)
      @set_tab(@ui.companies_tab)

    show_details: ->
      @activate_page(@ui.details_page)
      @set_tab(@ui.details_tab)

    show_tasks: ->
      @activate_page(@ui.tasks_page)  	
      @set_tab(@ui.tasks_tab)

    show_opportunities: ->
      @activate_page(@ui.opportunities_page)
      @set_tab(@ui.opportunities_tab)

    set_tab: (current) ->
      for tab in @tabs
        if tab == current.selector
          @$(tab).addClass('active')
        else
          @$(tab).removeClass('active')

    activate_page: (current) ->
      for page in @pages
        if page == current.selector
          @$(page).removeClass('hiden_form_page')
        else
          @$(page).addClass('hiden_form_page')

    edit_peson: ->
      Backbone.trigger('person_edit:open', @model.get('id'))

    to_people: ->
      Backbone.trigger('people:open')
      