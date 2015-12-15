define ['jquery', 'backbone', 'backbone.marionette',
    'views/company', 
    'collections/companies',
    'templates/companies/companiesListTemplate',
    'libs/jquery.tagcloud',
    'views/elem_list_view'    
    ], ($, Backbone, Marionette, 
      CompanyView,
      Companies, companiesListTemplate, tagcloud,
      ElemListView
    ) ->

  class CompaniesView extends Backbone.Marionette.CompositeView
    template: companiesListTemplate
    childView: CompanyView,
    childViewContainer: '#child_container'

    behaviors:
      ElemListView: 
        behaviorClass: ElemListView,
        collectionClass: Companies

    initialize: (options) ->
      @listenTo(@collection, 'reset', @render)
      @app = options.app

      if (!@app.fullCompaniesCollection)
        @app.fullCompaniesCollection = @collection.fullCollection.models.slice()

    set_filter_message: (value)->
      @app.search_companies_filter_message = value

    filter_message: ->
      @app.search_companies_filter_message

    current_tag: ->
      @app.companies_tag

    set_current_tag: (tag) ->
      @app.companies_tag = tag
  
    full_collection: ->
      @app.fullCompaniesCollection

    set_current_collection: (collection) ->
      @app.companies_collection = collection

    open_list: ->
      Backbone.trigger('companies:open')