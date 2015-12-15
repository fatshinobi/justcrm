define ['jquery', 'backbone', 
    'views/person_details', 'models/person'
  ], (
    $, Backbone,
    PersonDetailsView, Person
  ) ->

  check_active_page = (tabs, active, view) ->
    for tab in tabs
      if tab == active
        expect(view.$(tab)).toHaveClass("active")
      else
        expect(view.$(tab)).not.toHaveClass("active")

  check_active_div = (divs, active, view) ->
    for div in divs
      if div == active
        expect(view.$(div)).not.toHaveClass("hiden_form_page")
      else
        expect(view.$(div)).toHaveClass("hiden_form_page")

  describe "Person Details View", ->
    beforeEach ->
      @personDetailsView = new PersonDetailsView(
        model: new Person( 
          id: 1, 
          name: 'test name', 
          about: 'test about',
          phone: 'test phone',
          email: 'test email',
          facebook: 'test facebook',
          twitter: 'test twitter',
          companies: [{company:{id:1, name:'test company name'}, role: 'test role'}],
          appointments: [{
            id: 1, 
            body: 'test appointment', 
            when: '02/21/2015 16:45:00', 
            communication_type: 1, 
            status: 0,
            user: {id: 1, name: 'test appointment user'}
          }],
          opportunities: [{
            id: 1, 
            title: 'test opportunity', 
            description: 'test opportunity descr',
            start: '02/21/2015', 
            finish: '05/21/2015', 
            stage: 1, 
            status: 0,
            amount: 20.5,
            user: {id: 1, name: 'test opportunity user'},
            company: {id: 1, name: 'test opportunity company'}
          }]
        )
      )

    afterEach ->
      @personDetailsView.remove()

    it "have defined", ->
      expect(@personDetailsView).toBeDefined()

    it "have model", ->
      expect(@personDetailsView.model).toBeDefined()
      expect(@personDetailsView.model.get('name')).toBe('test name')

    it "have companies", ->
      expect(@personDetailsView.model.companies).toBeDefined()
      expect(@personDetailsView.model.companies.length).toBe(1)

    it "have appointments", ->
      expect(@personDetailsView.model.appointments).toBeDefined()
      expect(@personDetailsView.model.appointments.length).toBe(1)
      expect(@personDetailsView.model.appointments.constructor.name).toBe('Appointments')

    it "have opportunities", ->
      expect(@personDetailsView.model.opportunities).toBeDefined()
      expect(@personDetailsView.model.opportunities.length).toBe(1)
      expect(@personDetailsView.model.opportunities.constructor.name).toBe('Opportunities')

    describe "rendering", ->
      it "return itself", ->
        expect(@personDetailsView.render()).toEqual(@personDetailsView)

      it "produce the correct output", ->
        @personDetailsView.render()
        expect(@personDetailsView.el.innerHTML).toContain('test name')
        expect(@personDetailsView.el.innerHTML).toContain('test about')
        expect(@personDetailsView.el.innerHTML).toContain('test phone')
        expect(@personDetailsView.el.innerHTML).toContain('test email')
        expect(@personDetailsView.el.innerHTML).toContain('test facebook')
        expect(@personDetailsView.el.innerHTML).toContain('test twitter')
      
        expect(@personDetailsView.el.innerHTML).toContain('test company name')
        expect(@personDetailsView.el.innerHTML).toContain('test role')

        expect(@personDetailsView.el.innerHTML).toContain('test appointment')
        expect(@personDetailsView.el.innerHTML).toContain('test appointment user')
        expect(@personDetailsView.el.innerHTML).toContain('Feb 21st 2015 16:45')  #02/21/2015 16:45:00
     
        expect(@personDetailsView.el.innerHTML).toContain('test opportunity')
        expect(@personDetailsView.el.innerHTML).toContain('test opportunity descr')


    describe "Tabs", ->
      beforeEach ->
        @personDetailsView.render()
        @tabs = ['#details_tab', '#companies_tab', '#tasks_tab', '#opportunities_tab']
        @divs = ['#details_div', '#companies_div', '#tasks_div', '#opportunities_div']      

        for tab in @tabs
          @personDetailsView.$(tab).removeClass('active')      
    
      describe "click to companies tab", ->
        beforeEach ->
          @personDetailsView.$('#companies_div').addClass('hiden_form_page')

        it "make companies div active", ->
          @personDetailsView.$el.trigger('show_companies')

          check_active_div(@divs, '#companies_div', @personDetailsView)
          check_active_page(@tabs, '#companies_tab', @personDetailsView)

        it "click event works", ->
          @personDetailsView.$('#companies_link').click()
          expect(@personDetailsView.$('#companies_div')).not.toHaveClass("hiden_form_page")

      describe "click to details tab", ->
        beforeEach ->
          @personDetailsView.$('#details_div').addClass('hiden_form_page')
          @personDetailsView.$('#companies_tab').addClass('active')

        it "make details div active", ->
          @personDetailsView.$el.trigger('show_details')
          check_active_div(@divs, '#details_div', @personDetailsView)
          check_active_page(@tabs, '#details_tab', @personDetailsView)

        it "click event works", ->
          @personDetailsView.$('#details_link').click()
          expect(@personDetailsView.$('#details_div')).not.toHaveClass("hiden_form_page")

      describe "click to tasks tab", ->
        beforeEach ->
          @personDetailsView.$('#tasks_div').addClass('hiden_form_page')        

        it "make tasks div active", ->
          @personDetailsView.$el.trigger('show_tasks')
          check_active_div(@divs, '#tasks_div', @personDetailsView)
          check_active_page(@tabs, '#tasks_tab', @personDetailsView)

        it "click event works", ->
          @personDetailsView.$('#tasks_link').click()
          expect(@personDetailsView.$('#tasks_div')).not.toHaveClass("hiden_form_page")

      describe "click to opportunities tab", ->
        beforeEach ->
          @personDetailsView.$('#opportunities_div').addClass('hiden_form_page')

        it "make opportunities div active", ->
          @personDetailsView.$el.trigger('show_opportunities')          
          check_active_div(@divs, '#opportunities_div', @personDetailsView)
          check_active_page(@tabs, '#opportunities_tab', @personDetailsView)

        it "click event works", ->
          @personDetailsView.$('#opportunities_link').click()
          expect(@personDetailsView.$('#opportunities_div')).not.toHaveClass("hiden_form_page")

    describe "List companies", ->
      beforeEach ->
        @personDetailsView.render()

      it "have links", ->
        expect(@personDetailsView.$('.company_link').length).toBe(2)
      
      it "links has a right data", ->
        link = @personDetailsView.$('.company_link').first()
        expect(link.get(0).dataset.button).toBe('1')

      it "after click open company detail", ->
        spyOn(Backbone, "trigger")        
        @personDetailsView.$('.company_link').first().click()
        expect(Backbone.trigger).toHaveBeenCalledWith('company_details:open', '1')
    
