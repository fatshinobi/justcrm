describe "Appointments collection", ->
  beforeEach ->
    @appointments = new Justcrm.Collections.Appointments()

  it "should be defined", ->
    expect(@appointments).toBeDefined()

  it "can add models", ->
    expect(@appointments.length).toBe(0)
    @appointments.add({body: 'call to Den Pett'})
    expect(@appointments.length).toBe(1)
    @appointments.add([
      {body: 'call to Luci Vasale'},
      {body: 'email to Ger Iffy'}
    ])
    expect(@appointments.length).toBe(3)
