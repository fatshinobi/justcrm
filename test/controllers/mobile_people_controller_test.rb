require 'test_helper'
include Devise::TestHelpers

class MobilePeopleControllerTest < ActionController::TestCase
  tests PeopleController

  setup do
    @person = people(:one)
    sign_in users(:one)    
  end

  test "should mobile action" do
    get 'mobile'
    assert_template 'mobile'
    assert_template layout: 'layouts/mobile'
  end
end