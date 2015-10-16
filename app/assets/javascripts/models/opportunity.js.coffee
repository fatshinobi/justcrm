class Justcrm.Models.Opportunity extends Backbone.Model
  initialize: ->
    @STAGES_LIST = ["awareness", "interest", "decision", "buy"]

  get_stage: ->
    @STAGES_LIST[@get('stage')]