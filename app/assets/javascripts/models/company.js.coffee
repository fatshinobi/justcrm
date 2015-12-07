define ['backbone', 'collections/appointments',
    'collections/opportunities'
  ], (Backbone, Appointments, Opportunities) ->
  
  class Company extends Backbone.Model
    urlRoot: '/companies'

    initialize: ->
      @CONDITIONS_LIST = ["active", "stoped", "removed"]
      
      @.on('change:people', @parse_people)
      @.on('change:appointments', @parse_appointments)      
      @parse_people()
      @parse_appointments()
      @parse_opportunities()

    parse_people: ->
      @people = @get('people')

    parse_appointments: ->
      @appointments = new Appointments(@get('appointments'))

    parse_opportunities: ->
      @opportunities = new Opportunities(@get('opportunities'))

    is_active: ->
      @get_condition() == "active"
    
    is_stoped: ->
      @get_condition() == "stoped"

    is_removed: ->
      @get_condition() == "removed"

    get_condition: ->
      @CONDITIONS_LIST[@get('condition')]  

    post_status: (action) ->
      $.ajax
        url: "#{@url()}/#{action}"
        type: 'POST'
        dataType: 'json'
        success: ->
          console.log('sync success')

    activate: ->
      @post_status('activate')

    stop: ->
      @post_status('stop')

    sync: (method, model, options) ->
      if (method == 'update') || (method == 'create')
        _.defaults(options || (options = {}), {
          data: model.get('company'),
          processData: false,
          contentType: false,
          cache: false
        })
    
      Backbone.sync.call(@, method, model, options)
