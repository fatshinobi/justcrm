define ['collections/opportunities'], (Opportunities) ->
  describe "Opportunities collection", ->
    beforeEach ->
      @opportunities = new Opportunities()

    it "should be defined", ->
      expect(@opportunities).toBeDefined()

    it "can add models", ->
      expect(@opportunities.length).toBe(0)
      @opportunities.add({title: 'Prototype Den Pett'})
      expect(@opportunities.length).toBe(1)
      @opportunities.add([
        {title: 'Prototype to Luci Vasale'},
        {title: 'Estimate to Ger Iffy'}
      ])
      expect(@opportunities.length).toBe(3)
