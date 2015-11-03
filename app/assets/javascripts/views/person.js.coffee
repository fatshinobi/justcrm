class Justcrm.Views.PersonView extends Backbone.Marionette.ItemView
  template: HandlebarsTemplates["people/personTemplate"],
  ui:
    about_text: '.about_text'
    more_place: '.more_place'
    more_btn: '.more_btn'

  events:
    'click a.name_link': 'to_details'
    'click .more_btn': 'open_more_info'
    'click .to_details_more_btn': 'to_details'
    'click .activate_status_btn': 'set_active'

  to_details: ->
    Backbone.trigger('person_details:open', @model.get('id'))

  open_more_info: ->
    @ui.about_text.removeClass('short_text')
    @ui.more_place.removeClass('hiden_elem')
    @ui.more_btn.addClass('hiden_elem')

  set_active: ->
    