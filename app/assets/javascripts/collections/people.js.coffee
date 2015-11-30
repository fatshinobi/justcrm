define ['backbone', 'models/person',
    'backbone.paginator'
  ], (Backbone, Person, pages) ->
  class People extends Backbone.PageableCollection
    model: Person
    url: '/people'

    mode: "client"

    state:
      pageSize: 10
