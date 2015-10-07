describe "JustcrmRouter", ->
  beforeEach ->
    @router = new Justcrm.Routers.JustcrmRouter(
      controller: new Justcrm.Controllers.JustcrmController()
    )

  it "is defined", ->
    expect(@router).toBeDefined()

  it "define controller", ->
    expect(@router.controller).toBeDefined()

  it "route to people", ->
  	expect(@router.appRoutes[""]).toEqual('people')
