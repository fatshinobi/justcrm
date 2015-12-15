define ['jquery', 'backbone', 'backbone.marionette',
    'views/person', 
    'collections/people',
    'templates/people/peopleListTemplate',
    'libs/jquery.tagcloud',
    'views/elem_list_view'
    ], ($, Backbone, Marionette, 
      PersonView,
      People, peopleListTemplate, tagcloud,
      ElemListView
    ) ->
  
  class PeopleView extends Backbone.Marionette.CompositeView
    template: peopleListTemplate
    childView: PersonView,
    childViewContainer: '#child_container'

    behaviors:
      ElemListView: 
        behaviorClass: ElemListView,
        collectionClass: People

    initialize: (options) ->
      @listenTo(@collection, 'reset', this.render)
      @app = options.app

      if (!@app.fullCollection)
        @app.fullCollection = @collection.fullCollection.models.slice()

    set_filter_message: (value)->
      @app.search_filter_message = value

    filter_message: ->
      @app.search_filter_message

    current_tag: ->
      @app.people_tag

    set_current_tag: (tag) ->
      @app.people_tag = tag
  
    full_collection: ->
      @app.fullCollection

    set_current_collection: (collection) ->
      @app.people_collection = collection

    open_list: ->
      Backbone.trigger('people:open')