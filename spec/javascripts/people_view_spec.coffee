describe "People View", ->
  beforeEach ->
    #$('body').append('<div id="people"></div>')
    @peopleView = new Justcrm.Views.PeopleView()
  
  afterEach ->
    @peopleView.remove()
    #$('#people').remove

  it "have right dom element", ->
    expect(@peopleView.el.tagName.toLowerCase()).toBe('div')

  it "render a people collection", ->
    peopleCollection = new Justcrm.Collections.People()
    peopleCollection.reset([
      {name: 'Vob Gucelli'},
      {name: 'Cubbi Dolphin'}
    ])

    @peopleView.collection = peopleCollection
    @peopleView.render()
    expect(@peopleView.children.length).toBe(2)
    expect(@peopleView.el.innerHTML).toContain('Vob Gucelli')
    expect(@peopleView.el.innerHTML).toContain('Cubbi Dolphin')