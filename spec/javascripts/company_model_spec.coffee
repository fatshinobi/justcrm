define ['jquery', 'models/company'], ($, Company) ->
  describe "Company model", ->
    beforeEach ->
      @company = new Company(id: 1)

    it "should be defined", ->
      expect(@company).toBeDefined()

    describe "conditions", ->
      it "is active", ->
        company = new Company(condition: 0)
        expect(company.is_active()).toBe(true)

      it "is stoped", ->
        company = new Company(condition: 1)
        expect(company.is_stoped()).toBe(true)

      it "is removed", ->
        company = new Company(condition: 2)
        expect(company.is_removed()).toBe(true)

    describe "activate function", ->
      it "should be defined", ->
        expect(@company.activate).toBeDefined()

      it "call ajax", ->
        spyOn($, "ajax")
        @company.activate()
        expect($.ajax).toHaveBeenCalledWith(
          {
            url: "#{@company.url()}/activate", 
            type: 'POST',
            dataType: 'json',
            success: jasmine.any(Function)
          }
        )

    describe "stop function", ->
      it "should be defined", ->
        expect(@company.stop).toBeDefined()

      it "call ajax", ->
        spyOn($, "ajax")
        @company.stop()
        expect($.ajax).toHaveBeenCalledWith(
          {
            url: "#{@company.url()}/stop", 
            type: 'POST',
            dataType: 'json',          
            success: jasmine.any(Function)
          }
        )
