class Justcrm.Views.PeopleView extends Backbone.Marionette.CompositeView
  template: HandlebarsTemplates["people/peopleListTemplate"]
  childView: Justcrm.Views.PersonView,
  childViewContainer: '#child_container'

  ui:
    search_text: '#search_text'
    filter_message: '#filter_message'
    clear_filters_btn: '#clear_filters' 

  events:
    'click #next_page': 'to_next_page'
    'click #prev_page': 'to_prev_page'
    'click #start_searching': 'searching'
    'click #clear_filters': 'clear_filters'

  initialize: (options) ->
    @listenTo(@collection, 'reset', this.render)
    @app = options.app

    if (!@app.fullCollection)
      @app.fullCollection = @collection.fullCollection.models.slice()

  onRender: ->
    $('#main').addClass('list_content')
    
    if @app.search_filter_message
      @ui.filter_message.text("Name contents '#{@app.search_filter_message}'")
      @ui.clear_filters_btn.removeClass('hiden_elem')

  to_next_page: ->
    @collection.getNextPage()

  to_prev_page: ->
    @collection.getPreviousPage()    

  searching: ->
    if (val = @ui.search_text.val())
      filtered = @app.fullCollection.filter( (item) ->
        item.get('name').toLowerCase().indexOf(val.toLowerCase()) >= 0
      )
      @app.search_filter_message = val
      @app.people_collection = new Justcrm.Collections.People(filtered)
      Backbone.trigger('people:open')


  clear_filters: ->
    if (@app.fullCollection)
      @app.search_filter_message = null
      old = new Justcrm.Collections.People(@app.fullCollection)
      @app.people_collection = old
      Backbone.trigger('people:open')
