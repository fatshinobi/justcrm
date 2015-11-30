define ['backbone', 'models/user'], (Backbone, User) ->
  class Users extends Backbone.Collection
    model: User
    url: '/users'