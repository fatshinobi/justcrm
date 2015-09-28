class Justcrm.Views.PersonView extends Backbone.View
  template: HandlebarsTemplates["people/personTemplate"]

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
