class Justcrm.Views.PeopleView extends Backbone.View
  el: '#people',

  initialize: ->
    @collection = new Justcrm.Collections.People()
    @collection.fetch({reset: true})
    
    @render()

    @listenTo(@collection, 'reset', this.render)    

  render: ->
    for person in @collection.models
      @renderPerson(person)

  renderPerson: (item) ->
    personView = new Justcrm.Views.PersonView(model: item)
    @$el.append(personView.render().el)
