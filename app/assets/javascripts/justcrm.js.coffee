window.Justcrm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Controllers: {}
  Helpers: {}
  #initialize: ->

$(document).ready ->
  helpers = new Justcrm.Helpers.ApplicationHelpers()
  helpers.register()

  m_app = new Backbone.Marionette.Application()
  m_app.addRegions(
    mainRegion: '#main'
    )

  m_app.addInitializer( ->
    controller = new Justcrm.Controllers.JustcrmController(app: @)
    router = new Justcrm.Routers.JustcrmRouter(controller: controller)
  )

  m_app.on('start', ->
    if (Backbone.history)
      Backbone.history.start()
  )

  m_app.start()


