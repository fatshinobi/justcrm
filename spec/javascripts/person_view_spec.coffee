describe "Person View", ->
  beforeEach ->
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
    it "define", ->
      expect(@personView.ui.name_link).toBeDefined()
    
    it "have right href", ->
      @personView.render()
      expect(@personView.ui.name_link.attr('href')).toBe('/mobile#people#1')
