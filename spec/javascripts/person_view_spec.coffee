describe "Person View", ->
  beforeEach ->
    @personView = new Justcrm.Views.PersonView({model: new Justcrm.Models.Person( name: 'test name')})

  it "have model", ->
    expect(@personView.model).toBeDefined()
    expect(@personView.model.get('name')).toBe('test name')
  
  describe "rendering", ->
    it "return itself", ->
      expect(@personView.render()).toEqual(@personView)
      
    it "produce the correct output", ->
      @personView.render()
      expect(@personView.el.innerHTML).toContain('test name')
      expect(@personView.el.innerHTML).toContain('<div class="person-entry">')      