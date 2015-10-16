class Justcrm.Models.Appointment extends Backbone.Model
  is_message: ->
    @get('communication_type') == 0

  is_call: ->
    @get('communication_type') == 1

  is_task: ->
    @get('communication_type') == 2

  is_meet: ->
    @get('communication_type') == 3