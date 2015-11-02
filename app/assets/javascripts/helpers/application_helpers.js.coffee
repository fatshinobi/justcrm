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

    Handlebars.registerHelper('AppointmentIco', (type, options) -> 
      app = new Justcrm.Models.Appointment(@)
      ret = "<span class='glyphicon icon-large float_pic "
      switch
        when app.is_message()
          ret += 'glyphicon-envelope'
        when app.is_call()
          ret += 'glyphicon-phone-alt'
        when app.is_meet()
          ret += 'glyphicon-comment'
        when app.is_task()
          ret += 'glyphicon-wrench'
    
      ret += " ', aria-hidden = 'true'> </span>"
      new Handlebars.SafeString(ret)
    )

    #partials
    
    Handlebars.registerPartial(
      "short_appointment_entry", 
      HandlebarsTemplates["appointments/shortAppointmentEntry"]
    )

    Handlebars.registerPartial(
      "short_opportunity_entry", 
      HandlebarsTemplates["opportunities/shortOpportunityEntry"]
    )
