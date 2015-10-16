class Justcrm.Views.PeopleView extends Backbone.Marionette.CollectionView
  childView: Justcrm.Views.PersonView,

  initialize: (options) ->
    @listenTo(@collection, 'reset', this.render)    
