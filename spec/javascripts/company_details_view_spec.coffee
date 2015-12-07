define ['jquery', 'backbone', 
    'views/company_details', 'models/company'
  ], (
    $, Backbone,
    CompanyDetailsView, Company
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


  describe "Company Details View", ->
    beforeEach ->
      @companyDetailsView = new CompanyDetailsView(
        model: new Company( 
          id: 1, 
          name: 'test name', 
          about: 'test about',
          phone: 'test phone',
          web: 'test web',
          people: [{person:{id:1, name:'test person name'}, role: 'test role'}],
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
      @companyDetailsView.remove()

    it "have defined", ->
      expect(@companyDetailsView).toBeDefined()

    it "have model", ->
      expect(@companyDetailsView.model).toBeDefined()
      expect(@companyDetailsView.model.get('name')).toBe('test name')

    it "have people", ->
      expect(@companyDetailsView.model.people).toBeDefined()
      expect(@companyDetailsView.model.people.length).toBe(1)

    it "have appointments", ->
      expect(@companyDetailsView.model.appointments).toBeDefined()
      expect(@companyDetailsView.model.appointments.length).toBe(1)
      expect(@companyDetailsView.model.appointments.constructor.name).toBe('Appointments')

    it "have opportunities", ->
      expect(@companyDetailsView.model.opportunities).toBeDefined()
      expect(@companyDetailsView.model.opportunities.length).toBe(1)
      expect(@companyDetailsView.model.opportunities.constructor.name).toBe('Opportunities')

    describe "rendering", ->
      it "return itself", ->
        expect(@companyDetailsView.render()).toEqual(@companyDetailsView)

      it "produce the correct output", ->
        @companyDetailsView.render()
        expect(@companyDetailsView.el.innerHTML).toContain('test name')
        expect(@companyDetailsView.el.innerHTML).toContain('test about')
        expect(@companyDetailsView.el.innerHTML).toContain('test phone')
        expect(@companyDetailsView.el.innerHTML).toContain('test web')

        expect(@companyDetailsView.el.innerHTML).toContain('test person name')
        expect(@companyDetailsView.el.innerHTML).toContain('test role')

        expect(@companyDetailsView.el.innerHTML).toContain('test appointment')
        expect(@companyDetailsView.el.innerHTML).toContain('test appointment user')
        expect(@companyDetailsView.el.innerHTML).toContain('Feb 21st 2015 16:45')  #02/21/2015 16:45:00

        expect(@companyDetailsView.el.innerHTML).toContain('test opportunity')
        expect(@companyDetailsView.el.innerHTML).toContain('test opportunity descr')

    describe "Tabs", ->
      beforeEach ->
        @companyDetailsView.render()
        @tabs = ['#details_tab', '#people_tab', '#tasks_tab', '#opportunities_tab']
        @divs = ['#details_div', '#people_div', '#tasks_div', '#opportunities_div']      

        for tab in @tabs
          @companyDetailsView.$(tab).removeClass('active')
    
      describe "click to people tab", ->
        beforeEach ->
          @companyDetailsView.$('#people_div').addClass('hiden_form_page')

        it "make people div active", ->
          @companyDetailsView.show_people()

          check_active_div(@divs, '#people_div', @companyDetailsView)
          check_active_page(@tabs, '#people_tab', @companyDetailsView)

        it "click event works", ->
          @companyDetailsView.$('#people_link').click()
          expect(@companyDetailsView.$('#people_div')).not.toHaveClass("hiden_form_page")

      describe "click to details tab", ->
        beforeEach ->
          @companyDetailsView.$('#details_div').addClass('hiden_form_page')
          @companyDetailsView.$('#people_tab').addClass('active')

        it "make details div active", ->
          @companyDetailsView.show_details()

          check_active_div(@divs, '#details_div', @companyDetailsView)
          check_active_page(@tabs, '#details_tab', @companyDetailsView)

        it "click event works", ->
          @companyDetailsView.$('#details_link').click()
          expect(@companyDetailsView.$('#details_div')).not.toHaveClass("hiden_form_page")

      describe "click to tasks tab", ->
        beforeEach ->
          @companyDetailsView.$('#tasks_div').addClass('hiden_form_page')

        it "make tasks div active", ->
          @companyDetailsView.show_tasks()        
          check_active_div(@divs, '#tasks_div', @companyDetailsView)
          check_active_page(@tabs, '#tasks_tab', @companyDetailsView)

        it "click event works", ->
          @companyDetailsView.$('#tasks_link').click()
          expect(@companyDetailsView.$('#tasks_div')).not.toHaveClass("hiden_form_page")

      describe "click to opportunities tab", ->
        beforeEach ->
          @companyDetailsView.$('#opportunities_div').addClass('hiden_form_page')

        it "make opportunities div active", ->
          @companyDetailsView.show_opportunities()
          check_active_div(@divs, '#opportunities_div', @companyDetailsView)
          check_active_page(@tabs, '#opportunities_tab', @companyDetailsView)

    describe "List of people", ->
      beforeEach ->
        @companyDetailsView.render()

      it "have links", ->
        expect(@companyDetailsView.$('.person_link').length).toBe(1)
      
      it "links has a right data", ->
        link = @companyDetailsView.$('.person_link').first()
        expect(link.get(0).dataset.button).toBe('1')

      it "after click open person detail", ->
        spyOn(Backbone, "trigger")        
        @companyDetailsView.$('.person_link').first().click()
        expect(Backbone.trigger).toHaveBeenCalledWith('person_details:open', '1')
