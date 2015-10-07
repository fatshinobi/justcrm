describe "Person View", ->
  beforeEach ->
  beforeEach ->
    spyOn(Justcrm.Views.PersonView.prototype, 'show_details')
    @personView = new Justcrm.Views.PersonView({model: new Justcrm.Models.Person( name: 'test name', about: 'test about')})

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

  describe "have dom event", ->
    it "for name link that call Show details", ->
      expect(@personView.show_details).toBeDefined()
      @personView.render()
      @personView.$('.name_link').click()

      expect(@personView.show_details).toHaveBeenCalled()
