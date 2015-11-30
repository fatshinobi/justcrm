requirejs.config({
  paths: {
    lookUpView: 'look_up_view'
    #personTemplate: 'templates/people/personTemplate',
    #peopleListTemplate: 'templates/people/peopleListTemplate'
  },
  shim: {
    lookUpView: {
      exports: 'LookUpView'
    }

    'bootstrap-sprockets' : { 'deps' :['jquery'] }
  }
})

require ['jquery', 'backbone',
    'backbone.marionette',
    'bootstrap-sprockets',
    'views/menu',
    'collections/users',
    'collections/people',
    'views/people',
    'helpers/application_helpers',
    'views/person_details',
    'models/person',
    'views/person_edit'
  ], (
    $, Backbone, Marionette, bs,
    MenuView, Users, People,
    PeopleView, ApplicationHelpers, 
    PersonDetailsView, Person,
    PersonEditView
  ) ->

  main_loading = ->
    helpers = new ApplicationHelpers()
    helpers.register()

    m_app = new Backbone.Marionette.Application()
    m_app.addRegions(
      mainRegion: '#main'
    )

    m_app.addInitializer( ->
      menu_view = new MenuView(app: @)
      app = @

      Backbone.on('people:open', () ->
        if !app.people_collection
          app.people_collection = new People()
          app.people_collection.fetch(success: (collection, response, options) ->
            app.set_people(collection)
          , reset: true)
        else
          app.set_people(app.people_collection)
      )

      Backbone.on('person_details:open', (id) ->
        app.set_person(id)
      )

      Backbone.on('actions:show_tags', () ->
        $('#tags_holder').show("slow")
      )

      Backbone.on('person_edit:open', (id) ->
        if !app.users_collection
          app.users_collection = new Users()
          app.users_collection.fetch(
            success: ->
              app.set_edit_person(id)
            reset: true
          )
        else
          app.set_edit_person(id)
      )

      Backbone.on('person_edit:new', (id) ->
        new_person = new Person()
        if !app.users_collection
          app.users_collection = new Users()
          app.users_collection.fetch(
            success: ->
              app.show_edit_person(new_person)
            reset: true
          )
        else
          app.show_edit_person(new_person)
      )

    )

    m_app.set_people = (collection) ->
      $('#main').addClass('list_content')
      @.mainRegion.show(new PeopleView(collection: collection, app: @))


    m_app.set_person = (id) ->
      $('#main').removeClass('list_content')
      @.mainRegion.show(new PersonDetailsView(id: id, app: @))

    m_app.set_edit_person = (id) ->
      app = @
      model = new Person(id: id)
      model.fetch(success: (model, response, options) ->
        #app.mainRegion.show(new Justcrm.Views.PersonEditView(model: model, app: app))
        app.show_edit_person(model)
      , reset: true)

    m_app.show_edit_person = (model) ->
      $('#main').removeClass('list_content')    
      @.mainRegion.show(new PersonEditView(model: model, app: @))

    m_app.on('start', ->
      #if (Backbone.history)
      #  Backbone.history.start()
      Backbone.trigger('people:open')
    )

    m_app.start()

  $(document).ready ->
    main_loading()
    $(".navbar-nav a.collapsed").click((event) ->
      $(".navbar-collapse").collapse('hide')
    )

    $.ajaxSetup(
      beforeSend: (xhr, options) ->
        if (options.type == 'PUT') || (options.type == 'POST')
          xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
    )

