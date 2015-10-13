class Justcrm.Views.PersonView extends Backbone.Marionette.ItemView
  template: HandlebarsTemplates["people/personTemplate"],
  ui:
    name_link: 'a.name_link'

  onRender: ->
    @ui.name_link.attr('href', "/mobile#people#" + @model.get('id'))    

