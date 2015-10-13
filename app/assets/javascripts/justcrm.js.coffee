window.Justcrm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  Controllers: {}
  #initialize: ->

$(document).ready ->
  Handlebars.registerHelper('dateFormat', (dt)-> 
    moment(dt).format("MMMM Do YYYY")
  )

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


