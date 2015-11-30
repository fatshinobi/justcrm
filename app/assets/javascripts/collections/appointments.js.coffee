define ['backbone', 'models/appointment'], (Backbone, Appointment) ->
  class Appointments extends Backbone.Collection
    model: Appointment

    initialize: (options) ->
      if (!options)
        return 0

      for app in options
        app.when = new Date(Date.parse(app.when))
