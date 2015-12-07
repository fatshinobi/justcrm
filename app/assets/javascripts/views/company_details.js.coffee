define [
    'jquery', 'backbone', 'backbone.marionette',
    'models/company',
    'templates/companies/companyDetailsTemplate'
  ], (
    $, Backbone, Marionette,
    Company,
    companyDetailsTemplate
  ) ->

  class CompanyDetailsView extends Backbone.Marionette.ItemView
    template: companyDetailsTemplate 

    events: 
      'click #people_link': 'show_people'
      'click #details_link': 'show_details'
      'click #tasks_link': 'show_tasks'
      'click #opportunities_link': 'show_opportunities'
      'click #edit_btn': 'edit_company'
      'click #to_list_btn' : 'to_companies'
      'click .person_link' : 'open_person'

    ui:
      people_page: '#people_div'
      details_page: '#details_div'
      tasks_page: '#tasks_div'
      opportunities_page: '#opportunities_div'

      people_tab: '#people_tab'
      details_tab: '#details_tab'
      tasks_tab: '#tasks_tab'
      opportunities_tab: '#opportunities_tab'

    initialize: (options) ->
      @pages = [
        @ui.people_page
        @ui.details_page
        @ui.tasks_page
        @ui.opportunities_page
      ]
      @tabs = [
        @ui.people_tab
        @ui.details_tab
        @ui.tasks_tab
        @ui.opportunities_tab
      ]

      if (!@model)
        @model = new Company(id: options.id)
      @listenTo(@model, 'change', @render)
      @model.fetch(error: @error_handler, reset: true)

    error_handler: (model, response, options) ->
      console.log(response.responseText)

    show_people: ->
      @activate_page(@ui.people_page)
      @set_tab(@ui.people_tab)

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

    edit_company: ->
      Backbone.trigger('company_edit:open', @model.get('id'))

    to_companies: ->
      Backbone.trigger('companies:open')

    open_person: (event) ->
      btn = $(event.currentTarget)
      person_id = btn.get(0).dataset.button
      Backbone.trigger('person_details:open', person_id)
