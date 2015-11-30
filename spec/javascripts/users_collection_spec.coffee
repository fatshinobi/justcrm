define ['collections/users'], (Users) ->
  describe "Users collection", ->
    beforeEach ->
      @users = new Users()

    it "should be defined", ->
      expect(@users).toBeDefined

    it "can add models", ->
      expect(@users.length).toBe(0)
      @users.add({name: 'Den Pett'})
      expect(@users.length).toBe(1)
      @users.add([
        {name: 'Luci Vasale'},
        {name: 'Ger Iffy'}
      ])
      expect(@users.length).toBe(3)

    it "have right url", ->
      expect(@users.url).toBe('/users')
