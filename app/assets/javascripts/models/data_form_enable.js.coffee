define ['jquery', 'backbone'], ($, Backbone) ->
  DataFormEnable =     
  	sync: (method, model, options) ->
      if (method == 'update') || (method == 'create')
        _.defaults(options || (options = {}), {
          data: model.get(model.constructor.name.toLowerCase()),
          #data: model.get('person'),
          processData: false,
          contentType: false,
          cache: false
        })
    
      Backbone.sync.call(@, method, model, options)

