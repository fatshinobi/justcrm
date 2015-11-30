define [
    'handlebars',
    'templates/appointments/shortAppointmentEntry',
    'templates/opportunities/shortOpportunityEntry', 
    'templates/shared/statusButton',
    'models/opportunity',
    'models/appointment',
    'moment'

  ],(
    Handlebars,
    shortAppointmentEntryTemplate,
    shortOpportunityEntryTemplate,
    statusButtonTemplate,
    Opportunity,
    Appointment,
    moment
  ) ->
  
  class ApplicationHelpers
    register: ->
      Handlebars.registerHelper('dateFormat', (dt) -> 
        moment(dt).format("MMM Do YYYY HH:mm")
      )

      Handlebars.registerHelper('OpportunityIco', (type, options) -> 
        opp = new Opportunity(@)
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
        app = new Appointment(@)
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
        shortAppointmentEntryTemplate
      )

      Handlebars.registerPartial(
        "short_opportunity_entry", 
        shortOpportunityEntryTemplate
      )

      Handlebars.registerPartial(
        "status_button", 
        statusButtonTemplate
      )
