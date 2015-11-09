class Justcrm.Collections.People extends Backbone.PageableCollection
  model: Justcrm.Models.Person
  url: '/people'

  mode: "client"

  state:
    pageSize: 3
