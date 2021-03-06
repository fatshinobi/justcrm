describe "LookUpView", ->
  beforeEach ->
    fixture.load('look_up_view.erb', append = false);
    @look_up = new LookUpView('#look-up-view', 'people')

  it "get view element", ->
    expect(@look_up.element.attr("id")).toEqual $('#look-up-view').attr("id")

  it "get path value", ->
    expect(@look_up.path).toEqual 'people'

  it "have input text elem", ->
    expect(@look_up.text_field.attr('type')).toEqual 'text'

  it "have result div", ->
    expect(@look_up.result_div.attr('class')).toEqual 'look-up-result'

  it "have result id input text", ->
    expect(@look_up.result_id.attr('type')).toEqual 'text'

  it "have result name input text", ->
    expect(@look_up.result_name.attr('type')).toEqual 'text'

  it "have enable buton", ->
    expect(@look_up.enable_button.attr('class')).toEqual 'look-up-button'

  it "text elem id disabled", ->
    expect(@look_up.text_field).toBeDisabled()

  describe "after buton click", ->
    beforeEach ->
      @look_up.init()
      @look_up.text_field.val('Test')
      @look_up.enable_button.click()

    it "text field stay enabled", ->
      expect(@look_up.text_field).not.toBeDisabled()

    it "text field is empty", ->
      expect(@look_up.text_field.val()).toEqual ''

    it "text field has focus", ->
      expect(@look_up.text_field).toBeFocused()

    describe "after focus losing", ->
      beforeEach ->
        @look_up.text_field.val('')
        @look_up.result_id.val('3')
        @look_up.text_field.focusout()

      it "text field is disabled", ->
        expect(@look_up.text_field).toBeDisabled()

      it "result id is empty if text is empty", ->
        expect(@look_up.result_id.val()).toEqual ''

  describe "when get data from server", ->
    beforeEach ->
      jasmine.Ajax.install()
      @look_up.text_field.val('123')

    beforeEach ->
      @look_up.set_result = jasmine.createSpy('set_result').and.callThrough()
      @look_up.set_search_data()

      jasmine.Ajax.requests.mostRecent().respondWith({
        'status': 200
        'contentType': 'application/html'
        'responseText': 'test'
      })

    afterEach ->
      jasmine.Ajax.uninstall()

    it "set search data to result", ->
      expect(@look_up.result_div.text()).toEqual 'test'

    it "bind set_result function", ->
      expect(@look_up.set_result).toHaveBeenCalled()

  describe "after keyup in text field", ->
    beforeEach ->
      jasmine.Ajax.install()
      @look_up.text_field.val('123')      

    beforeEach ->
      @look_up.init()
      @look_up.text_field.keyup()

      jasmine.Ajax.requests.mostRecent().respondWith({
        'status': 200
        'contentType': 'application/html'
        'responseText': 'test'
      })

    afterEach ->
      jasmine.Ajax.uninstall()      

    it "result div have values", ->
      expect(@look_up.result_div.text()).toEqual 'test'

    it "result name have right value", ->
      expect(@look_up.result_name.val()).toEqual '123'

  describe "text field too short", ->
    beforeEach ->
      @look_up.text_field.val('12')
      @look_up.get_ajax = jasmine.createSpy('get_ajax').and.callThrough()

    beforeEach ->
      @look_up.init()
      @look_up.text_field.keyup()

    it "result div isnt visible", ->
      expect(@look_up.result_div.html()).toEqual ''

    it "data dont get from server", ->
      expect(@look_up.get_ajax).not.toHaveBeenCalled()

  describe "set_result function", ->
    beforeEach ->
      $('.look-up-result').html('<a id="fffffffffff_1" class="live-choice" href="#">Test</a><a id="fffffffffff_2" class="live-choice" href="#">Test2</a>')
      @look_up.set_result()

    describe "after click at first choice", ->
      beforeEach ->
        elem = $('.live-choice:first')
        elem.click()

      it "set right result id for first elem", ->
        expect(@look_up.result_id.val()).toEqual '1'

      it "set right result name for first elem", ->
        expect(@look_up.text_field.val()).toEqual 'Test'

      it "clear result div", ->
        expect(@look_up.result_div.html()).toEqual ''

      it "set text_field disabled", ->
        expect(@look_up.text_field).toBeDisabled()

    describe "after click at second choice", ->
      beforeEach ->
        elem = $('.live-choice').eq(1)
        elem.click()

      it "set right result id for second elem", ->
        expect(@look_up.result_id.val()).toEqual '2'

      it "set right result name for second elem", ->
        expect(@look_up.text_field.val()).toEqual 'Test2'
    
  describe "if have parent id", ->
    beforeEach ->
      parent_input = $('#parent_id')
      @look_up = new LookUpView('#look-up-view', 'people', parent_input)

    it "should get parent_id", ->
      expect(@look_up.parent.attr("id")).toEqual 'parent_id'