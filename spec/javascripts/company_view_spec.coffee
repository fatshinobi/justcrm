define ['jquery', 'backbone', 
    'views/company', 'models/company',
    'support/jasmine-jquery-2.1.0'
  ], (
    $, Backbone,
    CompanyView, Company, jasmine_jquery
  ) ->

  describe "Company View", ->
    beforeEach ->
      spyOn(Company.prototype, 'activate')
      spyOn(Company.prototype, 'stop')
      spyOn(Company.prototype, 'destroy')    

      spyOn(CompanyView.prototype, 'to_details')    	
      @companyView = new CompanyView(
        model: new Company( id: 1, name: 'test name', about: 'test about', phone: '333', web: 'test_web')
      )

    afterEach ->
      @companyView.remove()

    it "have model", ->
      expect(@companyView.model).toBeDefined()
      expect(@companyView.model.get('name')).toBe('test name')

    describe "rendering", ->
      it "return itself", ->
        expect(@companyView.render()).toEqual(@companyView)

      it "produce the correct output", ->
        @companyView.render()
        expect(@companyView.el.innerHTML).toContain('test name')
        expect(@companyView.el.innerHTML).toContain('test about')
        expect(@companyView.el.innerHTML).toContain('333')
        expect(@companyView.el.innerHTML).toContain('test_web')                
        expect(@companyView.el.innerHTML).toContain('<div class="company-entry entry thumbnail">')

    describe "name link", ->
      it "click go to details", ->
        @companyView.render()
        @companyView.$('.name_link').click()

        expect(@companyView.to_details).toHaveBeenCalled()

    describe "more info", ->
      beforeEach ->
        @companyView.render()

      it "have short about text", ->
        expect(@companyView.$('.about_text')).toHaveClass("short_text")

      it "have more div hidden", ->
        expect(@companyView.$('.more_place')).toHaveClass("hiden_elem")

      describe "click to more button", ->
        beforeEach ->
          @companyView.$('.more_btn').click()

        it "open about text", ->
          expect(@companyView.$('.about_text')).not.toHaveClass("short_text")

        it "show more div", ->
          expect(@companyView.$('.more_place')).not.toHaveClass("hiden_elem")

        it "hide more button", ->
          expect(@companyView.$('.more_btn')).toHaveClass("hiden_elem")

    describe "statuses", ->
      beforeEach ->
        spyOn(window, 'confirm').and.returnValue(true)
        @companyView.render()

      describe "conditional caption", ->
        it "stoped have right class", ->
          @companyView.model.set('condition', 1)
          @companyView.render()
          expect(@companyView.$('.name_link')).toHaveClass("stoped_caption")

        it "removed have right class", ->
          @companyView.model.set('condition', 2)
          @companyView.render()
          expect(@companyView.$('.name_link')).toHaveClass("removed_caption")

        it "active have right class", ->
          @companyView.model.set('condition', 0)
          @companyView.render()
          expect(@companyView.$('.name_link')).not.toHaveClass('removed_caption')
          expect(@companyView.$('.name_link')).not.toHaveClass('stoped_caption')

      it "click activate button activate model", ->
        @companyView.$('.name_link').addClass('stoped_caption')
        @companyView.$('.activate_status_btn').click()
        expect(@companyView.model.activate).toHaveBeenCalled()
        expect(@companyView.$('.name_link')).not.toHaveClass('stoped_caption')

      it "click stop button stop model", ->
        @companyView.$('.stop_status_btn').click()
        expect(@companyView.model.stop).toHaveBeenCalled()
        expect(@companyView.$('.name_link')).toHaveClass("stoped_caption")

      it "click remove button destroy model", ->
        @companyView.$('.remove_status_btn').click()
        expect(@companyView.model.destroy).toHaveBeenCalled()
