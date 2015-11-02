describe "People View", ->
  beforeEach ->
    spyOn(Justcrm.Collections.People.prototype, 'getNextPage')
    spyOn(Justcrm.Collections.People.prototype, 'getPreviousPage')    
    @peopleCollection = new Justcrm.Collections.People()
    @peopleCollection.reset([
      {name: 'Vob Gucelli'},
      {name: 'Cubbi Dolphin'}
    ])

    @peopleView = new Justcrm.Views.PeopleView(collection: @peopleCollection, app: {})
  
  afterEach ->
    @peopleView.remove()
    #$('#people').remove

  it "have right dom element", ->
    expect(@peopleView.el.tagName.toLowerCase()).toBe('div')

  it "render a people collection", ->
    @peopleView.render()
    expect(@peopleView.children.length).toBe(2)
    expect(@peopleView.el.innerHTML).toContain('Vob Gucelli')
    expect(@peopleView.el.innerHTML).toContain('Cubbi Dolphin')

  describe "pager", ->
    beforeEach ->
      @peopleView.render()

    it "after click go to next", ->
      @peopleView.$('#next_page').click()
      expect(@peopleCollection.getNextPage).toHaveBeenCalled()

    it "after click go to prev", ->
      @peopleView.$('#prev_page').click()
      expect(@peopleCollection.getPreviousPage).toHaveBeenCalled()

  describe "searching", ->
    beforeEach ->
      spyOn(Backbone, "trigger")
      @peopleCollection = new Justcrm.Collections.People([
        {name: 'Den Pett'},
        {name: 'Den Pett1'},
        {name: 'Robb Guffet'},
        {name: 'Zod McAlister'},
        {name: 'Zet Brainus'}
      ])

      @peopleCollection.setPageSize(2)

      @app = {}

      @peopleView = new Justcrm.Views.PeopleView(collection: @peopleCollection, app: @app)
      @peopleView.render()

    it "have rigt page size", ->
      @peopleView.$('#search_text').val('Z')
      @peopleView.searching()
      expect(@app.people_collection.length).toBe(2)
      expect(Backbone.trigger).toHaveBeenCalledWith('people:open')
      

    it "search in other register", ->
      @peopleView.$('#search_text').val('z')
      @peopleView.searching()
      expect(@app.people_collection.length).toBe(2)

    it "have search message", ->
      @peopleView.$('#search_text').val('src msg')
      @peopleView.searching()
      expect(@app.search_filter_message).toBe('src msg')

    it "correct crlear", ->
      @app.search_filter_message = 'src msg'
      @peopleView.clear_filters()
      expect(@app.people_collection.length).toBe(3)
      expect(@app.people_collection.fullCollection.length).toBe(5)
      expect(Backbone.trigger).toHaveBeenCalledWith('people:open')
      expect(@app.search_filter_message).toBeNull()