class Justcrm.Views.PeopleView extends Backbone.Marionette.CollectionView
  el: '#people',
  childView: Justcrm.Views.PersonView,

  initialize: ->
    @collection = new Justcrm.Collections.People()
    @collection.fetch({reset: true})
    
    @render()

    @listenTo(@collection, 'reset', this.render)    
