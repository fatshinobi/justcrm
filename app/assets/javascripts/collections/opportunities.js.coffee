define ['backbone', 'models/opportunity'], (Backbone, Opportunity) ->
  class Opportunities extends Backbone.Collection
    model: Opportunity

    initialize: (options) ->
      if (!options)
        return 0

      for app in options
        app.start = new Date(Date.parse(app.start))
        app.finish = new Date(Date.parse(app.finish))
