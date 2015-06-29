require 'test_helper'

class UserAccessStoriesTest < ActionDispatch::IntegrationTest
  test "removed and stoped users cant have any access" do
  	admin = users(:one)
  	stay_admin admin
  	user_sign_in admin

	user = users(:two)
	post_via_redirect 'users/' << user.id.to_s << '/stop'
	assert_response :success
	assert_template "users/index"
	
	user_sign_out

	user_sign_in user
	have_not_access_to_br_resources
	user_sign_out

	user_sign_in admin

	user = users(:two)
	delete_via_redirect 'users/' << user.id.to_s
	assert_response :success
	assert_template "users/index"
	
	user_sign_out

	user_sign_in user
	have_not_access_to_br_resources
	#and
	have_not_access_to_sys_resources
	user_sign_out

  end

  test "active users must have access to br objects" do
  	admin = users(:one)
  	stay_admin admin
	user_sign_in admin

	user = users(:two)
	post_via_redirect 'users/' << user.id.to_s << '/activate'
	assert_response :success
	assert_template "users/index"
	
	user_sign_out

	user_sign_in user
	have_access_to_br_resources
	#but
	have_not_access_to_sys_resources
	user_sign_out

  end


  private

  def stay_admin(user)
	user.add_role 'super_admin'
	user.save
  end

  def user_sign_out
	delete_via_redirect 'users/sign_out'
	assert_response :success
	assert_template "users/sessions/new"
  end

  def user_sign_in(user)
	post_via_redirect 'users/sign_in', 'user[email]' => user.email, 'user[password]' => 'password'
	assert_response :success
	assert_template "workspaces/index"
  end

  def have_not_access_to_br_resources
	get 'companies'
	assert_response :success
	assert_template "shared/access_denied"	

	get 'people'
	assert_response :success
	assert_template "shared/access_denied"

	get 'companies/' << companies(:goggle).id.to_s
	assert_response :success
	assert_template "shared/access_denied"	

	get 'people/' << people(:one).id.to_s
	assert_response :success
	assert_template "shared/access_denied"	

	get 'companies/' << companies(:goggle).id.to_s << '/edit'
	assert_response :success
	assert_template "shared/access_denied"	

	get 'people/' << people(:one).id.to_s << '/edit'
	assert_response :success
	assert_template "shared/access_denied"	
  end

  def have_access_to_br_resources
	get 'companies'
	assert_response :success
	assert_template "companies/index"	

	get 'people'
	assert_response :success
	assert_template "people/index"

	get 'companies/' << companies(:goggle).id.to_s
	assert_response :success
	assert_template "companies/show"

	get 'people/' << people(:one).id.to_s
	assert_response :success
	assert_template "people/show"	

	get 'companies/' << companies(:goggle).id.to_s << '/edit'
	assert_response :success
	assert_template "companies/edit"	

	get 'people/' << people(:one).id.to_s << '/edit'
	assert_response :success
	assert_template "people/edit"	
  end

  def have_not_access_to_sys_resources
	get 'users'
	assert_response :success
	assert_template "shared/access_denied"

	get 'users/' << users(:one).id.to_s << '/edit'
	assert_response :success
	assert_template "shared/access_denied"	
  end

end
