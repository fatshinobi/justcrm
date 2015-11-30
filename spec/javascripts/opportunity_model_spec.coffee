define ['models/opportunity'], (Opportunity) ->
  describe "Opportunity model", ->
    beforeEach ->
      @opportunity = new Opportunity()

    it "should be defined", ->
      expect(@opportunity).toBeDefined

    it "have get_stage func", ->
      expect(@opportunity.get_stage()).toBeDefined
      @opportunity.set('stage', 0)
      expect(@opportunity.get_stage()).toBe('awareness')
      @opportunity.set('stage', 2)
      expect(@opportunity.get_stage()).toBe('decision')