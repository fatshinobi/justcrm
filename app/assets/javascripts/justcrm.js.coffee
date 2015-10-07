window.Justcrm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Controllers: {}
  #initialize: ->

$(document).ready ->
  m_app = new Backbone.Marionette.Application()

  m_app.addInitializer( ->
    controller = new Justcrm.Controllers.JustcrmController()
    router = new Justcrm.Routers.JustcrmRouter(controller: controller)
  )

  m_app.on('start', ->
    if (Backbone.history)
      Backbone.history.start()
  )

  m_app.start()


