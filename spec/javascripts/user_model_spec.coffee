define ['models/user'], (User) ->
  describe "User model", ->
    beforeEach ->
      @user = new User()

    it "should be defined", ->
      expect(@user).toBeDefined()

