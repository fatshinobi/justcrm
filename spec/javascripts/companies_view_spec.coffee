define ['jquery', 'backbone', 
    'views/companies', 'collections/companies'
  ], (
    $, Backbone,
    CompaniesView, Companies
  ) ->

  describe "Companies View", ->
    beforeEach ->
      @app = {}

      Companies.prototype.state.pageSize = 3

      spyOn(Companies.prototype, 'getNextPage')
      spyOn(Companies.prototype, 'getPreviousPage')

      @companiesCollection = new Companies()
      @companiesCollection.reset([
        {name: 'Mycrosoft'},
        {name: 'Goggle'}
      ])

      @companiesView = new CompaniesView(collection: @companiesCollection, app: @app)
  
    afterEach ->
      @companiesView.remove()

    it "have right dom element", ->
      expect(@companiesView.el.tagName.toLowerCase()).toBe('div')

    it "render a companies collection", ->
      @companiesView.render()
      expect(@companiesView.children.length).toBe(2)
      expect(@companiesView.el.innerHTML).toContain('Mycrosoft')
      expect(@companiesView.el.innerHTML).toContain('Goggle')

    it "have right filter message", ->
      @app.search_companies_filter_message = 'test'
      @companiesView.render()
      expect(@companiesView.$('#filter_message').text()).toBe("Name contents 'test'")

    describe "pager", ->
      beforeEach ->
        @companiesView.render()

      it "after click go to next", ->
        @companiesView.$('#next_page').click()
        expect(@companiesCollection.getNextPage).toHaveBeenCalled()

      it "after click go to prev", ->
        @companiesView.$('#prev_page').click()
        expect(@companiesCollection.getPreviousPage).toHaveBeenCalled()

    describe "searching", ->
      beforeEach ->
        spyOn(Backbone, "trigger")
        @companiesCollection = new Companies([
          {name: 'company1', group_list: ['tag1']},
          {name: 'company2', group_list: ['tag1']},
          {name: 'company3b', group_list: ['tag2']},
          {name: 'companyZ1', group_list: ['tag1', 'tag2']},
          {name: 'companyZ2b', group_list: ['tag1']}
        ])

        @companiesCollection.setPageSize(2)

        @app = {}

        @companiesView = new CompaniesView(collection: @companiesCollection, app: @app)
        @companiesView.render()

      it "have rigt page size", ->
        @companiesView.$('#search_text').val('Z')
        @companiesView.$el.trigger("searching")
        expect(@app.companies_collection.length).toBe(2)
        expect(Backbone.trigger).toHaveBeenCalledWith('companies:open')

      it "search in other register", ->
        @companiesView.$('#search_text').val('z')
        @companiesView.$el.trigger("searching")
        expect(@app.companies_collection.length).toBe(2)

      it "have search message", ->
        @companiesView.$('#search_text').val('src msg')
        @companiesView.$el.trigger("searching")
        expect(@app.search_companies_filter_message).toBe('src msg')

      it "correct crlear", ->
        @app.companies_tag = 'tag1'
        @app.search_companies_filter_message = 'src msg'
        @companiesView.$el.trigger("clear_filters")
        expect(@app.companies_collection.length).toBe(3)
        expect(@app.companies_collection.fullCollection.length).toBe(5)
        expect(Backbone.trigger).toHaveBeenCalledWith('companies:open')
        expect(@app.search_companies_filter_message).toBeNull()
        expect(@app.companies_tag).toBeNull()

      it "do with tags", ->
        @app.companies_tag = 'tag2'
        @companiesView.$el.trigger("searching")
        expect(@app.companies_collection.length).toBe(2)
        expect(@app.companies_collection.fullCollection.length).toBe(2)

        @app.companies_tag = 'tag1'
        @companiesView.$el.trigger("searching")
        expect(@app.companies_collection.length).toBe(3)
        expect(@app.companies_collection.fullCollection.length).toBe(4)

      it "do with search and tags", ->
        @companiesView.$('#search_text').val('b')
        @app.companies_tag = 'tag1'
        @companiesView.$el.trigger("searching")
        expect(@app.companies_collection.length).toBe(1)
        expect(@app.companies_collection.fullCollection.length).toBe(1)

      it "do with tag after search", ->
        @companiesView.$('#search_text').val('b')
        @companiesView.$el.trigger("searching")
        expect(@app.companies_collection.fullCollection.length).toBe(2)

        @app.companies_tag = 'tag1'
        @companiesView.$el.trigger("searching")
        expect(@app.companies_collection.length).toBe(1)
        expect(@app.companies_collection.fullCollection.length).toBe(1)

    describe "tagging", ->
      beforeEach ->
        spyOn($, "getJSON")      
        spyOn(CompaniesView.prototype.behaviors.ElemListView.behaviorClass.prototype, 'searching')
        @companiesView = new CompaniesView(collection: @companiesCollection, app: @app)
        @companiesView.render()

      it "get tags", ->
        expect($.getJSON).toHaveBeenCalledWith(
          "/companies/tags", 
          jasmine.any(Function)
        )

      it "apply tag set tag filter value", ->
        @companiesView.$('#tags_holder').append("<a rel='1' title='1' class='tag' data-button='test_tag1'>test_tag1</a> ")
      
        @companiesView.$('#tags_holder a.tag').first().click()
        expect(@app.companies_tag).toBe('test_tag1')
