describe "Appointment model", ->
  beforeEach ->
    @appointment = new Justcrm.Models.Appointment()

  it "should be defined", ->
    expect(@appointment).toBeDefined
