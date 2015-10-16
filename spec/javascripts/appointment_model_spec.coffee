describe "Appointment model", ->
  beforeEach ->
    @appointment = new Justcrm.Models.Appointment()

  it "should be defined", ->
    expect(@appointment).toBeDefined

  describe "have communication_types definer", ->
    it "of message", ->
      @appointment.communication_type = 0
      expect(@appointment.is_message())

    it "of call", ->
      @appointment.communication_type = 1
      expect(@appointment.is_call())

    it "of task", ->
      @appointment.communication_type = 2
      expect(@appointment.is_task())

    it "of meet", ->
      @appointment.communication_type = 3
      expect(@appointment.is_meet())
