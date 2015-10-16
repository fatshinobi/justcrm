class Justcrm.Controllers.JustcrmController extends Backbone.Marionette.Controller
  initialize: (options) ->
    _.bindAll(@, "load_people")

    @app = options.app

  load_people: (collection, response, options) ->
    @set_people(collection)

  set_people: (collection) ->
    @app.mainRegion.show(new Justcrm.Views.PeopleView(collection: collection))

  people: ->
    if !@people_collection
      @people_collection = new Justcrm.Collections.People()
      @people_collection.fetch(success: @load_people, reset: true)
    else
      @set_people(@people_collection)

  person: (id) ->
    @app.mainRegion.show(new Justcrm.Views.PersonDetailsView(id: id))
