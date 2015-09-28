window.Justcrm =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: -> alert 'Hello from Backbone!'

$(document).ready ->
  #Justcrm.initialize()
  new Justcrm.Views.PeopleView()

