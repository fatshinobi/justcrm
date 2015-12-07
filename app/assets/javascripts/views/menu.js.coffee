define ['jquery', 'backbone',
 'backbone.marionette'], 
 ($, Backbone, Marionette) ->
  class MenuView extends Backbone.Marionette.ItemView
    el: "#main_menu"
    template: false

    events: 
      'click #add_person': 'add_person'
      'click #add_company': 'add_company'      
      'click #to_people': 'to_people'
      'click #to_companies': 'to_companies'
      'click .show_tags': 'show_tags'

    initialize: (options) ->
      @app = options.app

    add_company: ->
      Backbone.trigger('company_edit:new')

    add_person: ->
      Backbone.trigger('person_edit:new')

    to_people: ->
      Backbone.trigger('people:open')

    to_companies: ->
      Backbone.trigger('companies:open')

    show_tags: ->
      Backbone.trigger('actions:show_tags')