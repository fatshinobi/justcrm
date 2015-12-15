define ['jquery', 'backbone', 
      'backbone.marionette'
    ], ($, Backbone, 
      Marionette
    ) ->
  class ElemListView extends Backbone.Marionette.Behavior
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

      'searching': 'searching'
      'clear_filters': 'clear_filters'

    onRender: ->
      filter_message = ''
      if @view.filter_message()
        filter_message = "Name contents '#{@view.filter_message()}'"

      if @view.current_tag()
        filter_message += ' and ' if filter_message.length > 0
        filter_message += "Tag: '#{@view.current_tag()}'"

      if filter_message.length > 0
        @ui.filter_message.text(filter_message)
        @ui.clear_filters_btn.removeClass('hiden_elem')

      $.fn.tagcloud.defaults = 
        size: {start: 18, end: 20, unit: 'pt'},
        color: {start: '#cde', end: '#f52'}

      that = @

      $.getJSON( "#{@view.collection.url}/tags", (data) ->
        for key, val in data
          that.ui.tags_holder.append("<a rel='#{key.taggings_count}' title='#{key.taggings_count}' class='tag' data-button='#{key.name}'>#{key.name}</a> ")

        that.$('#tags_holder a.tag').tagcloud()
      )

    to_next_page: ->
      @view.collection.getNextPage()

    to_prev_page: ->
      @view.collection.getPreviousPage()    

    searching: ->
      @view.set_filter_message(@ui.search_text.val()) if @ui.search_text.val()
      val = @view.filter_message()
     
      if (!val) && (!@view.current_tag())
        return
    
      tag = @view.current_tag()
      filtered = @view.full_collection().slice()

      if @view.current_tag()
        filtered = filtered.filter( (item) ->
          tag in item.get('group_list')
        )
    
      if val
        filtered = filtered.filter( (item) ->
          item.get('name').toLowerCase().indexOf(val.toLowerCase()) >= 0
        )

      @view.set_current_collection(new @options.collectionClass(filtered))
      @view.open_list()

    clear_filters: ->
      if (@view.full_collection())
        @view.set_filter_message(null)
        @view.set_current_tag(null)
        old = new @options.collectionClass(@view.full_collection())        
        @view.set_current_collection(old)
        @view.open_list()

    close_tags: ->
      @ui.tags_holder.slideUp("slow")

    apply_tag: (event) ->
      btn = $(event.target)
      tag_name = btn.data('button')
      @view.set_current_tag(tag_name)
      that = @
      @ui.tags_holder.slideUp("slow", ->
        that.$el.trigger("searching")
      )
