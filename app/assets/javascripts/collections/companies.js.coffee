define ['backbone', 'models/company',
    'backbone.paginator'
  ], (Backbone, Company, pages) ->
  class Companies extends Backbone.PageableCollection
    model: Company
    url: '/companies'

    mode: "client"

    state:
      pageSize: 10