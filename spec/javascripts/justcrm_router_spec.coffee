describe "JustcrmRouter", ->
  beforeEach ->
    #spyOn(Justcrm.Controllers.JustcrmController.prototype, 'person')
    @controller = new Justcrm.Controllers.JustcrmController()

    @router = new Justcrm.Routers.JustcrmRouter(
      controller: @controller
    )

  it "is defined", ->
    expect(@router).toBeDefined()

  it "define controller", ->
    expect(@router.controller).toBeDefined()

  it "route to people", ->
    expect(@router.appRoutes[""]).toEqual('people')

  it "route to people", ->
    expect(@router.appRoutes["people"]).toEqual('people')

  it "route to person", ->
    expect(@router.appRoutes["people#:id"]).toEqual('person')
