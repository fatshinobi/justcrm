describe "Person model", ->
  beforeEach ->
    @person = new Justcrm.Models.Person()

  it "should be defined", ->
    expect(@person).toBeDefined