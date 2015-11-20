class Justcrm.Views.PeopleView extends Backbone.Marionette.CompositeView
  template: HandlebarsTemplates["people/peopleListTemplate"]
  childView: Justcrm.Views.PersonView,
  childViewContainer: '#child_container'

  ui:
    search_text: '#search_text'
    filter_message: '#filter_message'
    clear_filters_btn: '#clear_filters' 
    tags_holder: '#tags_holder'
    tag_links: '#tags_holder a'

  events:
    'click #next_page': 'to_next_page'
    'click #prev_page': 'to_prev_page'
    'click #start_searching': 'searching'
    'click #clear_filters': 'clear_filters'
    'click #close_tags_btn': 'close_tags'
    'click #tags_holder a.tag': 'apply_tag'

  initialize: (options) ->
    @listenTo(@collection, 'reset', this.render)
    @app = options.app

    if (!@app.fullCollection)
      @app.fullCollection = @collection.fullCollection.models.slice()

    _.bindAll(@, 'apply_tag')

  onRender: ->
    filter_message = ''
    if @app.search_filter_message
      filter_message = "Name contents '#{@app.search_filter_message}'"

    if @app.people_tag
      filter_message += ' and ' if filter_message.length > 0
      filter_message += "Tag: '#{@app.people_tag}'"

    if filter_message.length > 0
      @ui.filter_message.text(filter_message)
      @ui.clear_filters_btn.removeClass('hiden_elem')

    $.fn.tagcloud.defaults = 
      size: {start: 18, end: 20, unit: 'pt'},
      color: {start: '#cde', end: '#f52'}

    that = @

    $.getJSON( "#{@collection.url}/tags", (data) ->
      for key, val in data
        that.ui.tags_holder.append("<a rel='#{key.taggings_count}' title='#{key.taggings_count}' class='tag' data-button='#{key.name}'>#{key.name}</a> ")

      that.$('#tags_holder a.tag').tagcloud()
    )

  to_next_page: ->
    @collection.getNextPage()

  to_prev_page: ->
    @collection.getPreviousPage()    

  searching: ->

    @app.search_filter_message = @ui.search_text.val() if @ui.search_text.val()
    
    val = @app.search_filter_message

    if (!val) && (!@app.people_tag)
      return
    
    #val = @ui.search_text.val()
    tag = @app.people_tag

    filtered = @app.fullCollection.slice()

    if @app.people_tag
      filtered = filtered.filter( (item) ->
        tag in item.get('group_list')
      )
    
    if val
      filtered = filtered.filter( (item) ->
        item.get('name').toLowerCase().indexOf(val.toLowerCase()) >= 0
      )

    #@app.search_filter_message = val if val

    @app.people_collection = new Justcrm.Collections.People(filtered)
    Backbone.trigger('people:open')

  clear_filters: ->
    if (@app.fullCollection)
      @app.search_filter_message = null
      @app.people_tag = null
      old = new Justcrm.Collections.People(@app.fullCollection)
      @app.people_collection = old
      Backbone.trigger('people:open')
      
  close_tags: ->
    @ui.tags_holder.slideUp("slow")

  apply_tag: (event) ->
    btn = $(event.target)
    tag_name = btn.data('button')
    @app.people_tag = tag_name
    that = @
    @ui.tags_holder.slideUp("slow", ->
      that.searching()
    )
