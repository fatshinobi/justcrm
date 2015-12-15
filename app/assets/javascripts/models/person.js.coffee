define ['backbone', 'backbone.cocktail',
    'collections/appointments',
    'collections/opportunities',
    'models/conditionable',
    'models/data_form_enable',
  ], (Backbone, Cocktail,
    Appointments, Opportunities,
    Conditionable, DataFormEnable
    ) ->


  class Person extends Backbone.Model
    urlRoot: '/people'

    initialize: ->
      @.on('change:companies', @parse_companies)
      @.on('change:appointments', @parse_appointments)
      @parse_companies()
      @parse_appointments()
      @parse_opportunities()

    sync: ->

    @mixin Conditionable, DataFormEnable

    parse_companies: ->
      @companies = @get('companies')

    parse_appointments: ->
      @appointments = new Appointments(@get('appointments'))

    parse_opportunities: ->
      @opportunities = new Opportunities(@get('opportunities'))
