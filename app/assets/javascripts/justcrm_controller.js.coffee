###
class JustcrmController extends Backbone.Marionette.Controller
  initialize: (options) ->
    _.bindAll(@, "load_people")

    @app = options.app

  people: ->

  person: (id) ->
###
