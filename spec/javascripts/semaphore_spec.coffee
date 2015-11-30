requirejs.config({
  paths: {
    lookUpView: 'look_up_view',
    semaphore: 'semaphore'
  },
  shim: {
    lookUpView: {
      exports: 'LookUpView'
    }

    semaphore: {
      exports: 'Semaphore'
    }

  }
})

define ['semaphore'], (Semaphore) ->
  describe "Semaphore", ->
    beforeEach ->
      fixture.load('look_up_view.erb', append = false);  	
      @semaphore = new Semaphore()
      @lookup_view = new LookUpView('#look-up-view', 'people')
      @semaphore.add(@lookup_view)
      @lookup_view2 = new LookUpView('#look-up-view-2', 'companies')
      @semaphore.add(@lookup_view2)
      @semaphore.init()

    it "get lookup list", ->
      expect(@semaphore.view_list.length).toEqual 2

    describe "for results", ->
  	  beforeEach ->
        @lookup_view.result_div.html('test')
        @lookup_view2.result_div.html('test2')

      it "clear prevent result div", ->
        @semaphore.clear_prevent_results(@lookup_view2)
        expect(@lookup_view.result_div.html()).toEqual ''

        @semaphore.clear_prevent_results(@lookup_view)
        expect(@lookup_view2.result_div.html()).toEqual ''

      it "but dont clear curent result div", ->
        @semaphore.clear_prevent_results(@lookup_view2)
        expect(@lookup_view2.result_div.html()).toEqual 'test2'

        @lookup_view.result_div.html('test')
        @semaphore.clear_prevent_results(@lookup_view)
        expect(@lookup_view.result_div.html()).toEqual 'test'

      it "make result div empty if other view has choice", ->
        @semaphore.clear_prevent_results = jasmine.createSpy('clear_prevent_results').and.callThrough()

        @lookup_view2.text_field.keyup()
        expect(@semaphore.clear_prevent_results).toHaveBeenCalled()
        expect(@semaphore.clear_prevent_results).toHaveBeenCalledWith(@lookup_view2)

        @lookup_view.text_field.keyup()
        expect(@semaphore.clear_prevent_results).toHaveBeenCalled()
        expect(@semaphore.clear_prevent_results).toHaveBeenCalledWith(@lookup_view)
