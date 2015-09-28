describe "People collection", ->
  beforeEach ->
    @people = new Justcrm.Collections.People()

  it "should be defined", ->
    expect(@people).toBeDefined

  it "can add models", ->
    expect(@people.length).toBe(0)
    @people.add({name: 'Den Pett'})
    expect(@people.length).toBe(1)
    @people.add([
      {name: 'Luci Vasale'},
      {name: 'Ger Iffy'}
    ])
    expect(@people.length).toBe(3)

  it "have right url", ->
    expect(@people.url).toBe('/people')
