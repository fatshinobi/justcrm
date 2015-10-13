class Justcrm.Models.Person extends Backbone.Model
  urlRoot: '/people'

  initialize: ->
    @.on('change:companies', @parse_companies)
    @.on('change:appointments', @parse_appointments)
    @parse_companies()
    @parse_appointments()

  parse_companies: ->
    @companies = @get('companies')

  parse_appointments: ->
    @appointments = new Justcrm.Collections.Appointments(@get('appointments'))
    