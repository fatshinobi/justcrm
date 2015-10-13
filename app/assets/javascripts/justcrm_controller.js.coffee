class Justcrm.Controllers.JustcrmController extends Backbone.Marionette.Controller
  initialize: (options) ->
    @app = options.app

  people: ->
    @app.mainRegion.show(new Justcrm.Views.PeopleView())

  person: (id) ->
    @app.mainRegion.show(new Justcrm.Views.PersonDetailsView(id: id))
