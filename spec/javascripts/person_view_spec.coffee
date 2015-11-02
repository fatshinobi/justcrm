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
   
