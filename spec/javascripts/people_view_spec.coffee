define ['jquery', 'backbone', 
    'views/people', 'collections/people'
  ], (
    $, Backbone,
    PeopleView, People
  ) ->

  describe "People View", ->
    beforeEach ->
      @app = {}
    
      People.prototype.state.pageSize = 3    
    
      spyOn(People.prototype, 'getNextPage')
      spyOn(People.prototype, 'getPreviousPage')

      @peopleCollection = new People()
      @peopleCollection.reset([
        {name: 'Vob Gucelli'},
        {name: 'Cubbi Dolphin'}
      ])

      @peopleView = new PeopleView(collection: @peopleCollection, app: @app)
  
    afterEach ->
      @peopleView.remove()

    it "have right dom element", ->
      expect(@peopleView.el.tagName.toLowerCase()).toBe('div')

    it "render a people collection", ->
      @peopleView.render()
      expect(@peopleView.children.length).toBe(2)
      expect(@peopleView.el.innerHTML).toContain('Vob Gucelli')
      expect(@peopleView.el.innerHTML).toContain('Cubbi Dolphin')

    it "have right filter message", ->
      @app.search_filter_message = 'test'
      @peopleView.render()
      expect(@peopleView.$('#filter_message').text()).toBe("Name contents 'test'")

    it "have right filter message for tag", ->
      @app.people_tag = 'tag1'
      @peopleView.render()
      expect(@peopleView.$('#filter_message').text()).toBe("Tag: 'tag1'")

    it "have right filter message for search and tag", ->
      @app.search_filter_message = 'test'    
      @app.people_tag = 'tag1'
      @peopleView.render()
      expect(@peopleView.$('#filter_message').text()).toBe("Name contents 'test' and Tag: 'tag1'")

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
        @peopleCollection = new People([
          {name: 'Den Pett', group_list: ['tag1']},
          {name: 'Den Pett1', group_list: ['tag1']},
          {name: 'Robb Guffet', group_list: ['tag2']},
          {name: 'Zod McAlister', group_list: ['tag1', 'tag2']},
          {name: 'Zet Brainus', group_list: ['tag1']}
        ])

        @peopleCollection.setPageSize(2)

        @app = {}

        @peopleView = new PeopleView(collection: @peopleCollection, app: @app)
        @peopleView.render()

      it "have rigt page size", ->
        @peopleView.$('#search_text').val('Z')
        @peopleView.$el.trigger("searching")
        expect(@app.people_collection.length).toBe(2)
        expect(Backbone.trigger).toHaveBeenCalledWith('people:open')

      it "search in other register", ->
        @peopleView.$('#search_text').val('z')
        @peopleView.$el.trigger("searching")
        expect(@app.people_collection.length).toBe(2)

      it "have search message", ->
        @peopleView.$('#search_text').val('src msg')
        @peopleView.$el.trigger("searching")
        expect(@app.search_filter_message).toBe('src msg')

      it "correct crlear", ->
        @app.people_tag = 'tag1'
        @app.search_filter_message = 'src msg'
        @peopleView.$el.trigger("clear_filters")
        expect(@app.people_collection.length).toBe(3)
        expect(@app.people_collection.fullCollection.length).toBe(5)
        expect(Backbone.trigger).toHaveBeenCalledWith('people:open')
        expect(@app.search_filter_message).toBeNull()
        expect(@app.people_tag).toBeNull()

      it "do with tags", ->
        @app.people_tag = 'tag2'
        @peopleView.$el.trigger("searching")
        expect(@app.people_collection.length).toBe(2)
        expect(@app.people_collection.fullCollection.length).toBe(2)

        @app.people_tag = 'tag1'
        @peopleView.$el.trigger("searching")
        expect(@app.people_collection.length).toBe(3)
        expect(@app.people_collection.fullCollection.length).toBe(4)

      it "do with search and tags", ->
        @peopleView.$('#search_text').val('b')
        @app.people_tag = 'tag1'
        @peopleView.$el.trigger("searching")
        expect(@app.people_collection.length).toBe(1)
        expect(@app.people_collection.fullCollection.length).toBe(1)

      it "do with tag after search", ->
        @peopleView.$('#search_text').val('b')
        @peopleView.$el.trigger("searching")
        expect(@app.people_collection.fullCollection.length).toBe(2)

        @app.people_tag = 'tag1'
        @peopleView.$el.trigger("searching")
        expect(@app.people_collection.length).toBe(1)
        expect(@app.people_collection.fullCollection.length).toBe(1)


    describe "tagging", ->
      beforeEach ->
        spyOn($, "getJSON")      
        spyOn(PeopleView.prototype.behaviors.ElemListView.behaviorClass.prototype, 'searching')
        
        @peopleView = new PeopleView(collection: @peopleCollection, app: @app)
        @peopleView.render()

      it "get tags", ->
        expect($.getJSON).toHaveBeenCalledWith(
          "/people/tags", 
          jasmine.any(Function)
        )

      it "apply tag set tag filter value", ->
        @peopleView.$('#tags_holder').append("<a rel='1' title='1' class='tag' data-button='test_tag1'>test_tag1</a> ")
      
        @peopleView.$('#tags_holder a.tag').first().click()
        expect(@app.people_tag).toBe('test_tag1')
