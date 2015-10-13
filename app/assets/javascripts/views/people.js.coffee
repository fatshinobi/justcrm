class Justcrm.Views.PeopleView extends Backbone.Marionette.CollectionView
  childView: Justcrm.Views.PersonView,

  initialize: (options) ->
    @collection = new Justcrm.Collections.People()
    @listenTo(@collection, 'reset', this.render)    
    @collection.fetch(reset: true)
