class Justcrm.Views.PersonView extends Backbone.Marionette.ItemView
  template: HandlebarsTemplates["people/personTemplate"],
  events:
    'click a.name_link': 'to_details'

  to_details: ->
    Backbone.trigger('person_details:open', @model.get('id'))
