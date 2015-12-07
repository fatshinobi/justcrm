define ['collections/companies'], (Companies) ->
  describe "Companies collection", ->
    beforeEach ->
      Companies.prototype.state.pageSize = 3
      @companies = new Companies()

    it "should be defined", ->
      expect(@companies).toBeDefined

    it "can add models", ->
      expect(@companies.length).toBe(0)
      @companies.add({name: 'FBI'})
      expect(@companies.length).toBe(1)
      @companies.add([
        {name: 'Mycrosoft'},
        {name: 'Goggle'}
      ])
      expect(@companies.length).toBe(3)

    it "have right url", ->
      expect(@companies.url).toBe('/companies')

    it "have right pagging", ->
      @companies = new Companies([
        {name: 'company1'},
        {name: 'company2'},
        {name: 'company3'},
        {name: 'company4'},
        {name: 'company5'}
      ])

      @companies.setPageSize(3)
      expect(@companies.length).toBe(3)

      @companies.getNextPage()
      expect(@companies.length).toBe(2)

      