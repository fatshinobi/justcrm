define ['helpers/application_helpers'], (ApplicationHelpers) ->
  describe "Application Helpers", ->
    beforeEach ->
      @applicationHelpers = new ApplicationHelpers()

    it "have defined", ->
      expect(@applicationHelpers).toBeDefined()

    it "have register func", ->
      expect(@applicationHelpers.register).toBeDefined()
      expect(@applicationHelpers.register.constructor.name).toBe('Function')