require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
	include Devise::TestHelpers
	tests Users::RegistrationsController

	setup do
		request.env["devise.mapping"] = Devise.mappings[:user]  	
	end

	test "cant signup without login" do
		assert @controller.respond_to? :new
		get :new
		assert_redirected_to new_user_session_path
	end  

	test "users cant signup" do
		sign_in users(:one)
		get :new
		assert_response :success
		assert_template "shared/access_denied"
	end  

	test "superadmin can add user" do
		user = users(:one)
		user.add_role 'super_admin'
		user.save
		sign_in user
		get :new
		assert_response :success
	    post :create, :user => {:name => "John Doe", :email => "jdoe@example.com", :password => "testtest", :password_confirmation => "testtest"}		
		assert_response :success
	end  

end