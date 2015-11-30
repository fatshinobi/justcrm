define ['jquery', 'backbone', 
    'views/person_edit', 'models/person'
  ], (
    $, Backbone,
    PersonEditView, Person
  ) ->

  describe "Person Edit View", ->
    beforeEach ->
      @model_stab = {set: ->}
      @app_stab =
      {
        mainRegion: {show: 'stub'}
        users_collection: {models: [{id: 1, name: 'user1', get: -> 1}]}
        people_collection: 
          get: ->
          fullCollection:
            add: ->
          
      }

      spyOn(Backbone, "trigger")
      spyOn(PersonEditView.prototype, 'go_to_details')
      spyOn(Person.prototype, 'save')

      @personEditView = new PersonEditView(
        app: @app_stab,
        model: new Person( 
          id: 1, 
          name: 'test name', 
          about: 'test about',
          phone: 'test phone',
          email: 'test email',
          user_id: 1,
          facebook: 'test facebook',
          twitter: 'test twitter',
          group_list: 'test_tag1, test_tag2',
          companies: [{id: 1, company:{id:1, name:'test company name'}, role: 'test role', new_company_name: ''}],
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
      @personEditView.remove()

    it "have defined", ->
      expect(@personEditView).toBeDefined()

    it "have model", ->
      expect(@personEditView.model).toBeDefined()
      expect(@personEditView.model.get('name')).toBe('test name')

    describe "rendering", ->
      it "return itself", ->
        expect(@personEditView.render()).toEqual(@personEditView)

      it "produce the correct output", ->
        @personEditView.render()
        expect(@personEditView.el.innerHTML).toContain('test name')
        expect(@personEditView.el.innerHTML).toContain('test about')
        expect(@personEditView.el.innerHTML).toContain('test phone')
        expect(@personEditView.el.innerHTML).toContain('test email')
        expect(@personEditView.el.innerHTML).toContain('test facebook')
        expect(@personEditView.el.innerHTML).toContain('test twitter')
        expect(@personEditView.el.innerHTML).toContain('test_tag1, test_tag2')

        expect(@personEditView.el.innerHTML).toContain('test company name')
        expect(@personEditView.el.innerHTML).toContain('test role')

    it "return to details", ->
      @personEditView.render()
      @personEditView.$('#details_btn').click()
      expect(@personEditView.go_to_details).toHaveBeenCalled()

    it "return to list", ->
      @personEditView.render()
      @personEditView.$('#to_list_btn').click()
      expect(Backbone.trigger).toHaveBeenCalledWith('people:open')

    describe "submiting", ->
      beforeEach ->
        @personEditView.render()
        @personEditView.$('#name').attr('value', 'name after submit')
        @personEditView.$('#phone').attr('value', 'phone after submit')
        @personEditView.$('#facebook').attr('value', 'facebook after submit')
        @personEditView.$('#email').attr('value', 'email after submit')
        @personEditView.$('#twitter').attr('value', 'twitter after submit')
        @personEditView.$('#about').text('about after submit')

        @personEditView.$('#submit').click()

      it "make right model changes", ->
        expect(@personEditView.model.save).toHaveBeenCalledWith(
        #  {person: {
        #    name: 'name after submit', 
        #    about: 'about after submit', 
        #    phone: 'phone after submit', 
        #    facebook: 'facebook after submit', 
        #    twitter: 'twitter after submit', 
        #    email: 'email after submit',
        #    user_id: '1',
        #    group_list: 'test_tag1, test_tag2'
        #    company_people_attributes: [{ id: 1, role: 'test role', company_id: 1, new_company_name: '',  _destroy: 'false' }] 
        #  }},
          {person: jasmine.any(FormData)},
          jasmine.any(Object),
          jasmine.any(Object)
        )

      it "refresh people collection", ->
        spyOn(@app_stab.people_collection, 'get').and.returnValue(@model_stab)
        spyOn(@model_stab, 'set')

        @personEditView.data = {name: 'test name 23'}      
        @personEditView.on_save(@personEditView.model)

        expect(@app_stab.people_collection.get).toHaveBeenCalledWith(@personEditView.model.id)
        expect(@model_stab.set).toHaveBeenCalledWith({name: 'test name 23'})

      it "after update refresh ava in collection", ->
        spyOn(@app_stab.people_collection, 'get').and.returnValue(@model_stab)

        @personEditView.model.new_file = {name: 'ava_test'}
        @personEditView.on_save(@personEditView.model)
        expect(@personEditView.data.ava.ava.thumb.url).toBe('/uploads/test/person/ava/1/thumb_ava_test')

      it "after create refresh ava in collection", ->
        spyOn(@app_stab.people_collection, 'get').and.returnValue(null)
        spyOn(@app_stab.people_collection.fullCollection, 'add')

        @personEditView.model.new_file = {name: 'ava_test'}
        @personEditView.on_save(@personEditView.model)
        expect(@personEditView.model.get('ava').ava.thumb.url).toBe('/uploads/test/person/ava/1/thumb_ava_test')


    describe "add new company", ->
      beforeEach ->
        @personEditView.render()
        @personEditView.$('#new_company_name').attr('value', 'new company name')
        @personEditView.$('#add_role').attr('value', 'New role')
        @personEditView.$('#new_company_id').attr('value', '8')
        @personEditView.$('#add_company_btn').click()
        @companies = @personEditView.model.get('companies')

      it "have new company in collecion", ->
        expect(@companies.length).toEqual(2)

      it "new company have right params", ->
        new_company = @companies[1]
        expect(new_company.company.name).toEqual('new company name')
        expect(new_company.company.id).toEqual('8')
        expect(new_company.role).toEqual('New role')

      it "add company to list", ->
        expect(@personEditView.$('#list_of_companies').html()).toContain('new company name')
        expect(@personEditView.$('#list_of_companies').html()).toContain('New role')

      it "new company have green color", ->
        expect(@personEditView.$('#list_of_companies .edit_company_entry')[1]).toHaveClass('new_edit_entry')
      

      it "clear view after imsert", ->
        expect(@personEditView.$('#new_company_name').val()).toEqual('')
        expect(@personEditView.$('#add_role').val()).toEqual('')
        expect(@personEditView.$('#new_company_id').val()).toEqual('')
  
    describe "add absolutely new company", ->
      beforeEach ->
        @personEditView.render()
        @personEditView.$('#new_company_name').attr('value', 'new company name')
        @personEditView.$('#add_role').attr('value', 'New role')
        @personEditView.$('#new_company_id').attr('value', '')
        @personEditView.$('#add_company_btn').click()
        @companies = @personEditView.model.get('companies')

      it "company should added", ->
        expect(@companies.length).toEqual(2)

      it "company have right params", ->
        new_company = @companies[1]
        expect(new_company.company.name).toEqual('new company name')
        expect(new_company.company.id).toEqual('')
        expect(new_company.role).toEqual('New role')
        expect(new_company.new_company_name).toEqual('new company name')

    describe "delete company", ->
      beforeEach ->
        @personEditView.render()
        @personEditView.$('.delete_company_entry').click()

      it "company element have red color", ->
        expect(@personEditView.$('#list_of_companies .edit_company_entry').first()).toHaveClass('deleted_edit_entry')

      it "company object have delete flag", ->
        expect(@personEditView.model.get('companies')[0].is_delete).toEqual(true)

    describe "add new person", ->
      beforeEach ->
        @personEditView = new PersonEditView(
          app: @app_stab,
          model: new Person()
        )
        @personEditView.render()      

      it "add new company", ->
        @personEditView.$('#new_company_name').attr('value', 'new company name')
        @personEditView.$('#add_role').attr('value', 'New role')
        @personEditView.$('#new_company_id').attr('value', '8')
        @personEditView.$('#add_company_btn').click()
        @companies = @personEditView.model.get('companies')
        expect(@companies.length).toEqual(1)

        new_company = @companies[0]
        expect(new_company.company.name).toEqual('new company name')
        expect(new_company.company.id).toEqual('8')
        expect(new_company.role).toEqual('New role')
