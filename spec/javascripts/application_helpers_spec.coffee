describe "Application Helpers", ->
  beforeEach ->
    @applicationHelpers = new Justcrm.Helpers.ApplicationHelpers()

  it "have defined", ->
    expect(@applicationHelpers).toBeDefined()

  it "have register func", ->
    expect(@applicationHelpers.register).toBeDefined()
    expect(@applicationHelpers.register.constructor.name).toBe('Function')