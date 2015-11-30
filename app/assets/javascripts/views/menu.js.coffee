define ['jquery', 'backbone',
 'backbone.marionette'], 
 ($, Backbone, Marionette) ->
  class MenuView extends Backbone.Marionette.ItemView
    el: "#main_menu"
    template: false

    events: 
      'click #add_person': 'add_person'
      'click #to_people': 'to_people'
      'click .show_tags': 'show_tags'

    initialize: (options) ->
      @app = options.app

    add_person: ->
      Backbone.trigger('person_edit:new')

    to_people: ->
      Backbone.trigger('people:open')

    show_tags: ->
      Backbone.trigger('actions:show_tags')