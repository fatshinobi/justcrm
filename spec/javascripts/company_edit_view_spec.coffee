define ['jquery', 'backbone', 
    'views/company_edit', 'models/company'
  ], (
    $, Backbone,
    CompanyEditView, Company
  ) ->

  describe "Company Edit View", ->
    beforeEach ->
      @model_stab = {set: ->}
      @app_stab =
      {
        mainRegion: {show: 'stub'}
        users_collection: {models: [{id: 1, name: 'user1', get: -> 1}]}
        companies_collection: 
          get: ->
          fullCollection:
            add: ->
          
      }
      spyOn(Backbone, "trigger")
      spyOn(CompanyEditView.prototype, 'go_to_details')
      spyOn(Company.prototype, 'save')

      @companyEditView = new CompanyEditView(
        app: @app_stab,
        model: new Company( 
          id: 1, 
          name: 'test name', 
          about: 'test about',
          phone: 'test phone',
          web: 'test web',
          user_id: 1,
          group_list: 'test_tag1, test_tag2',
          people: [{id: 1, person:{id:1, name:'test company name'}, role: 'test role', new_company_name: ''}],
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
            person: {id: 1, name: 'test opportunity person'}
          }]
        )
      )

    afterEach ->
      @companyEditView.remove()

    it "have defined", ->
      expect(@companyEditView).toBeDefined()

    it "have model", ->
      expect(@companyEditView.model).toBeDefined()
      expect(@companyEditView.model.get('name')).toBe('test name')

    describe "rendering", ->
      it "return itself", ->
        expect(@companyEditView.render()).toEqual(@companyEditView)

      it "produce the correct output", ->
        @companyEditView.render()
        expect(@companyEditView.el.innerHTML).toContain('test name')
        expect(@companyEditView.el.innerHTML).toContain('test about')
        expect(@companyEditView.el.innerHTML).toContain('test phone')
        expect(@companyEditView.el.innerHTML).toContain('test web')
        expect(@companyEditView.el.innerHTML).toContain('test_tag1, test_tag2')

    it "return to details", ->
      @companyEditView.render()
      @companyEditView.$('#details_btn').click()
      expect(@companyEditView.go_to_details).toHaveBeenCalled()

    it "return to list", ->
      @companyEditView.render()
      @companyEditView.$('#to_list_btn').click()
      expect(Backbone.trigger).toHaveBeenCalledWith('companies:open')

    describe "submiting", ->
      beforeEach ->
        @companyEditView.render()
        @companyEditView.$('#name').attr('value', 'name after submit')
        @companyEditView.$('#phone').attr('value', 'phone after submit')
        @companyEditView.$('#web').attr('value', 'web after submit')
        @companyEditView.$('#about').text('about after submit')

        @companyEditView.$('#submit').click()
        @behavior = $.grep(@companyEditView._behaviors, (elem) -> elem.constructor.name=='EditView')[0]

      it "make right model changes", ->
        expect(@companyEditView.model.save).toHaveBeenCalledWith(
          {company: jasmine.any(FormData)},
          jasmine.any(Object),
          jasmine.any(Object)
        )

      it "refresh companies collection", ->
        spyOn(@app_stab.companies_collection, 'get').and.returnValue(@model_stab)
        spyOn(@model_stab, 'set')

        @behavior.data = {name: 'test name 23'}
        @companyEditView.triggerMethod('_save', @companyEditView.model)

        expect(@app_stab.companies_collection.get).toHaveBeenCalledWith(@companyEditView.model.id)
        expect(@model_stab.set).toHaveBeenCalledWith({name: 'test name 23'})

      it "after update refresh ava in collection", ->
        spyOn(@app_stab.companies_collection, 'get').and.returnValue(@model_stab)

        @companyEditView.model.new_file = {name: 'ava_test'}
        @companyEditView.triggerMethod('_save', @companyEditView.model)        
        expect(@behavior.data.ava.ava.thumb.url).toBe('/uploads/test/company/ava/1/thumb_ava_test')

