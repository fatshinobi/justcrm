require 'test_helper'
include Devise::TestHelpers

class MobileControllerTest < ActionController::TestCase
  tests WorkspacesController

  setup do
    sign_in users(:one)    
  end

  test "should mobile action" do
    get 'mobile'
    assert_template 'mobile'
    assert_template layout: 'layouts/mobile'
  end
end