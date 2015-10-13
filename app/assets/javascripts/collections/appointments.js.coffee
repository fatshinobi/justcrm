class Justcrm.Collections.Appointments extends Backbone.Collection
  model: Justcrm.Models.Appointment

  initialize: (options) ->
    if (!options)
      return 0

    for app in options
      app.when = new Date(Date.parse(app.when))
