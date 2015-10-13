class Justcrm.Routers.JustcrmRouter extends Backbone.Marionette.AppRouter
  controller : Justcrm.Controllers.JustcrmController,
  appRoutes: 
    "": "people",
    "people": "people",
    "people#:id": "person"
