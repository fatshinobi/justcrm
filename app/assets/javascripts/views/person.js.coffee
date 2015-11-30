define ['backbone', 'backbone.marionette',
    'templates/people/personTemplate'
  ], (Backbone, Marionette, 
    personTemplate) ->
  class PersonView extends Backbone.Marionette.ItemView
    template: personTemplate,
    ui:
      about_text: '.about_text'
      more_place: '.more_place'
      more_btn: '.more_btn'
      name_link: '.name_link'

    events:
      'click a.name_link': 'to_details'
      'click .more_btn': 'open_more_info'
      'click .to_details_more_btn': 'to_details'
      'click .activate_status_btn': 'set_active'
      'click .stop_status_btn': 'set_stop'
      'click .remove_status_btn': 'set_remove'

    onRender: ->
      if (@model.is_stoped())
        @ui.name_link.addClass('stoped_caption')
      else if (@model.is_removed())
        @ui.name_link.addClass('removed_caption')

    to_details: ->
      Backbone.trigger('person_details:open', @model.get('id'))

    open_more_info: ->
      @ui.about_text.removeClass('short_text')
      @ui.more_place.removeClass('hiden_elem')
      @ui.more_btn.addClass('hiden_elem')

    set_active: ->
      if(confirm('Are you sure?'))
        @model.activate()
        @ui.name_link.removeClass('stoped_caption')      
      else
        false

    set_stop: ->
      if(confirm('Are you sure?'))
        @model.stop()
        @ui.name_link.addClass('stoped_caption')
      else
        false

    set_remove: ->
      if(confirm('Are you sure?'))
        @model.destroy(
          success: (model, response) ->
            console.log('model destroy success')
        )
      else
        false
        