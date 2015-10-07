class Justcrm.Views.PersonView extends Backbone.Marionette.ItemView
  template: HandlebarsTemplates["people/personTemplate"],
  events: 
    'click .name_link': 'show_details'
  ,
  show_details: (event) ->
    alert('show_details')