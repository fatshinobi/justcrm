class Justcrm.Controllers.JustcrmController extends Backbone.Marionette.Controller
  people: ->
    new Justcrm.Views.PeopleView()