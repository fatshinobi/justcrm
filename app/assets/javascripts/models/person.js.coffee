class Justcrm.Models.Person extends Backbone.Model
  urlRoot: '/people'

  initialize: ->
    @CONDITIONS_LIST = ["active", "stoped", "removed"]

    @.on('change:companies', @parse_companies)
    @.on('change:appointments', @parse_appointments)
    @parse_companies()
    @parse_appointments()
    @parse_opportunities()

  parse_companies: ->
    @companies = @get('companies')

  parse_appointments: ->
    @appointments = new Justcrm.Collections.Appointments(@get('appointments'))

  parse_opportunities: ->
    @opportunities = new Justcrm.Collections.Opportunities(@get('opportunities'))

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

  get_condition: ->
    @CONDITIONS_LIST[@get('condition')]  

  is_active: ->
    @get_condition() == "active"
    
  is_stoped: ->
    @get_condition() == "stoped"

  is_removed: ->
    @get_condition() == "removed"

  sync: (method, model, options) ->
    if (method == 'update') || (method == 'create')
      _.defaults(options || (options = {}), {
        data: model.get('person'),
        processData: false,
        contentType: false,
        cache: false
      })
    
    Backbone.sync.call(@, method, model, options)