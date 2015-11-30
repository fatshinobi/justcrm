define ['jquery', 'backbone', 
    'views/person', 'models/person',
    'support/jasmine-jquery-2.1.0'
  ], (
    $, Backbone,
    PersonView, Person, jasmine_jquery
  ) ->

  describe "Person View", ->
    beforeEach ->
      spyOn(Person.prototype, 'activate')
      spyOn(Person.prototype, 'stop')
      spyOn(Person.prototype, 'destroy')    
      spyOn(PersonView.prototype, 'to_details')
      @personView = new PersonView(
        model: new Person( id: 1, name: 'test name', about: 'test about')
      )

    afterEach ->
      @personView.remove()

    it "have model", ->
      expect(@personView.model).toBeDefined()
      expect(@personView.model.get('name')).toBe('test name')
  
    describe "rendering", ->
      it "return itself", ->
        expect(@personView.render()).toEqual(@personView)
      
      it "produce the correct output", ->
        @personView.render()
        expect(@personView.el.innerHTML).toContain('test name')
        expect(@personView.el.innerHTML).toContain('test about')      
        expect(@personView.el.innerHTML).toContain('<div class="person-entry entry thumbnail">')
  
    describe "name link", ->
      it "click go to details", ->
        @personView.render()
        @personView.$('.name_link').click()

        expect(@personView.to_details).toHaveBeenCalled()
   
    describe "more info", ->
      beforeEach ->
        @personView.render()

      it "have short about text", ->
        expect(@personView.$('.about_text')).toHaveClass("short_text")

      it "have more div hidden", ->
        expect(@personView.$('.more_place')).toHaveClass("hiden_elem")

      describe "click to more button", ->
        beforeEach ->
          @personView.$('.more_btn').click()

        it "open about text", ->
          expect(@personView.$('.about_text')).not.toHaveClass("short_text")
      
        it "show more div", ->
          expect(@personView.$('.more_place')).not.toHaveClass("hiden_elem")

        it "hide more button", ->
          expect(@personView.$('.more_btn')).toHaveClass("hiden_elem")        

    describe "statuses", ->
      beforeEach ->
        spyOn(window, 'confirm').and.returnValue(true)
        @personView.render()

      describe "conditional caption", ->
        it "stoped have right class", ->
          @personView.model.set('condition', 1)
          @personView.render()
          expect(@personView.$('.name_link')).toHaveClass("stoped_caption")

        it "removed have right class", ->
          @personView.model.set('condition', 2)
          @personView.render()
          expect(@personView.$('.name_link')).toHaveClass("removed_caption")

        it "active have right class", ->
          @personView.model.set('condition', 0)
          @personView.render()
          expect(@personView.$('.name_link')).not.toHaveClass('removed_caption')
          expect(@personView.$('.name_link')).not.toHaveClass('stoped_caption')

      it "click activate button activate model", ->
        @personView.$('.name_link').addClass('stoped_caption')
        @personView.$('.activate_status_btn').click()
        expect(@personView.model.activate).toHaveBeenCalled()
        expect(@personView.$('.name_link')).not.toHaveClass('stoped_caption')

      it "click stop button stop model", ->
        @personView.$('.stop_status_btn').click()
        expect(@personView.model.stop).toHaveBeenCalled()
        expect(@personView.$('.name_link')).toHaveClass("stoped_caption")

      it "click remove button destroy model", ->
        @personView.$('.remove_status_btn').click()
        expect(@personView.model.destroy).toHaveBeenCalled()
      