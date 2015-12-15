define ['backbone', 'backbone.cocktail',
    'collections/appointments',
    'collections/opportunities',
    'models/conditionable',
    'models/data_form_enable',    
  ], (Backbone, Cocktail, 
    Appointments, Opportunities,
    Conditionable, DataFormEnable
    ) ->

  class Company extends Backbone.Model
    urlRoot: '/companies'

    initialize: ->
      #Cocktail.mixin @, Conditionable
      @.on('change:people', @parse_people)
      @.on('change:appointments', @parse_appointments)      
      @parse_people()
      @parse_appointments()
      @parse_opportunities()

    sync: ->

    @mixin Conditionable, DataFormEnable

    parse_people: ->
      @people = @get('people')

    parse_appointments: ->
      @appointments = new Appointments(@get('appointments'))

    parse_opportunities: ->
      @opportunities = new Opportunities(@get('opportunities'))

