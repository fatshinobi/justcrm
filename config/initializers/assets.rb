# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += 
  [
    'mobile.css',
    'main.css',
  	'look_up_view.js', 
  	'semaphore.js', 
  	'underscore.js', 
    'moment.js',    
  	'backbone.js',
    'backbone.marionette.js',
    'backbone.paginator.js',
    'libs/backbone.syphon.js',
    'libs/jquery.tagcloud.js',
  	'justcrm.js',
  	'handlebars.runtime.js',
    'justcrm_controller.js',
    'justcrm_router.js',
    'templates/people/peopleListTemplate.js',    
    'templates/people/personTemplate.js',
    'templates/people/personDetailsTemplate.js',
    'templates/people/personEditTemplate.js',    
    'templates/appointments/shortAppointmentEntry.js',
    'templates/opportunities/shortOpportunityEntry.js',
    'templates/shared/statusButton.js',    
    'models/opportunity.js',
    'collections/opportunities.js',    
    'models/appointment.js',
    'collections/appointments.js',    
  	'models/person.js',
    'collections/people.js',
    'models/user.js',
    'collections/users.js',
    'views/person.js',    
    'views/people.js',
    'views/person_details.js',
    'views/person_edit.js',
    'views/menu.js',
    'helpers/application_helpers.js'
  ]