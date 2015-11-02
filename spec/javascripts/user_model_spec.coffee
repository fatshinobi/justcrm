describe "User model", ->
  beforeEach ->
    @user = new Justcrm.Models.User()

  it "should be defined", ->
    expect(@user).toBeDefined()

