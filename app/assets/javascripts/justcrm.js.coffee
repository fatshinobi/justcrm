$(document).on('page:load', -> 
  #main_loading()
)

window.Justcrm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Controllers: {}
  Helpers: {}
  initialize: ->
    #main_loading()

$(document).ready ->
  main_loading()
  $(".navbar-nav a.collapsed").click((event) ->
    $(".navbar-collapse").collapse('hide')
  )

main_loading = ->
  helpers = new Justcrm.Helpers.ApplicationHelpers()
  helpers.register()

  m_app = new Backbone.Marionette.Application()
  m_app.addRegions(
    mainRegion: '#main'
    )

  m_app.addInitializer( ->
    #controller = new Justcrm.Controllers.JustcrmController(app: @)
    #router = new Justcrm.Routers.JustcrmRouter(controller: controller)
    menu_view = new Justcrm.Views.MenuView(app: @)
    
    app = @

    Backbone.on('people:open', () ->
      if !app.people_collection
        app.people_collection = new Justcrm.Collections.People()
        app.people_collection.fetch(success: (collection, response, options) ->
          app.set_people(collection)
        , reset: true)
      else
        app.set_people(app.people_collection)
    )

    Backbone.on('person_details:open', (id) ->
      app.set_person(id)
    )

    Backbone.on('person_edit:open', (id) ->
      if !app.users_collection
        app.users_collection = new Justcrm.Collections.Users()
        app.users_collection.fetch(
          success: ->
            app.set_edit_person(id)
          reset: true
        )
      else
        app.set_edit_person(id)
    )

    Backbone.on('person_edit:new', (id) ->
      new_person = new Justcrm.Models.Person()
      if !app.users_collection
        app.users_collection = new Justcrm.Collections.Users()
        app.users_collection.fetch(
          success: ->
            app.show_edit_person(new_person)
          reset: true
        )
      else
        app.show_edit_person(new_person)
    )

    Backbone.on('actions:show_tags', () ->
      $('#tags_holder').show("slow")
    )
  )

  m_app.set_edit_person = (id) ->
    app = @
    model = new Justcrm.Models.Person(id: id)
    model.fetch(success: (model, response, options) ->
      #app.mainRegion.show(new Justcrm.Views.PersonEditView(model: model, app: app))
      app.show_edit_person(model)
    , reset: true)

  m_app.show_edit_person = (model) ->
    $('#main').removeClass('list_content')    
    @.mainRegion.show(new Justcrm.Views.PersonEditView(model: model, app: @))

  m_app.set_person = (id) ->
    $('#main').removeClass('list_content')
    @.mainRegion.show(new Justcrm.Views.PersonDetailsView(id: id, app: @))

  m_app.set_people = (collection) ->
    $('#main').addClass('list_content')
    @.mainRegion.show(new Justcrm.Views.PeopleView(collection: collection, app: @))
  

  m_app.on('start', ->
    #if (Backbone.history)
    #  Backbone.history.start()
    Backbone.trigger('people:open')
  )

  m_app.start()


