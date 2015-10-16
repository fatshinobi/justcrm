class Justcrm.Helpers.ApplicationHelpers
  register: ->
    Handlebars.registerHelper('dateFormat', (dt) -> 
      moment(dt).format("MMM Do YYYY HH:mm")
    )

    Handlebars.registerHelper('OpportunityIco', (type, options) -> 
      opp = new Justcrm.Models.Opportunity(@)
      ret = "<span class='glyphicon icon-large float_pic "
      switch opp.get_stage() 
        when 'awareness'
          ret += 'glyphicon-eye-open'
        when 'interest'
          ret += 'glyphicon-search'
        when 'decision'
          ret += 'glyphicon-fire'
        when 'buy'
          ret += 'glyphicon-usd'
    
      ret += " ', aria-hidden = 'true'> </span>"
      new Handlebars.SafeString(ret)
    )

    Handlebars.registerHelper('ifAppointmentIs', (type, options) -> 
      app = new Justcrm.Models.Appointment(@)
      ret = false
      if type == "message"
        ret = app.is_message()
      else if type == "call"
        ret = app.is_call()
      else if type == "meet"
        ret = app.is_meet()
      else if type == "task"
        ret = app.is_task()
      if ret
        options.fn(@)
      else
        options.inverse(@)
    )

