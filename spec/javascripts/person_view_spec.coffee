describe "Person View", ->
  beforeEach ->
    spyOn(Justcrm.Views.PersonView.prototype, 'to_details')
    @personView = new Justcrm.Views.PersonView(
      model: new Justcrm.Models.Person( id: 1, name: 'test name', about: 'test about')
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

    it "have hore div hidden", ->
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
      @personView.render()

    it "click active button", ->