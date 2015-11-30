define ['jquery', 'models/person'], ($, Person) ->
  describe "Person model", ->
    beforeEach ->
      @person = new Person(id: 1)

    it "should be defined", ->
      expect(@person).toBeDefined()

    describe "conditions", ->
      it "is active", ->
        person = new Person(condition: 0)
        expect(person.is_active()).toBe(true)

      it "is stoped", ->
        person = new Person(condition: 1)
        expect(person.is_stoped()).toBe(true)

      it "is removed", ->
        person = new Person(condition: 2)
        expect(person.is_removed()).toBe(true)

    describe "activate function", ->
      it "should be defined", ->
        expect(@person.activate).toBeDefined()

      it "call ajax", ->
        spyOn($, "ajax")
        @person.activate()
        expect($.ajax).toHaveBeenCalledWith(
          {
            url: "#{@person.url()}/activate", 
            type: 'POST',
            dataType: 'json',
            success: jasmine.any(Function)
          }
        )

    describe "stop function", ->
      it "should be defined", ->
        expect(@person.stop).toBeDefined()

      it "call ajax", ->
        spyOn($, "ajax")
        @person.stop()
        expect($.ajax).toHaveBeenCalledWith(
          {
            url: "#{@person.url()}/stop", 
            type: 'POST',
            dataType: 'json',          
            success: jasmine.any(Function)
          }
        )
