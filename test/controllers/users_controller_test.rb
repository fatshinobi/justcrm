require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:two) 

    user = users(:one)
    user.add_role 'super_admin'
    user.save
    sign_in user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:users)
    assert_equal 2, assigns(:users).size
    assert_select '.user_entry', 2	    
    assigns(:users).each do |user|
      assert_select 'h2', user.name
      assert_select 'h4', user.email
      #assert_select "#?", user.id.to_s do
      assert_select "##{user.id.to_s}" do
      	assert_select ".dropdown" do
      	  assert_select "ul.dropdown-menu" do
	        assert_select "li>a", "Activate" do |anchors|
              anchor = anchors[0]
              assert_equal activate_user_path(user), anchor.attributes["href"].value
              assert_equal "post", anchor.attributes["data-method"].value
            end
            assert_select "li>a", "Stop" do |anchors|
              anchor = anchors[0]
              assert_equal stop_user_path(user), anchor.attributes["href"].value
              assert_equal "post", anchor.attributes["data-method"].value  				
            end
            assert_select "li>a", "Remove" do |anchors|
              anchor = anchors[0]
              assert_equal user_path(user), anchor.attributes["href"].value
              assert_equal "delete", anchor.attributes["data-method"].value
            end
          end
        end
      end
    end
    assert_select "a", 'New User' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal new_user_registration_path, anchor.attributes["href"].value
    end
  end

  test "non superadmins cant see users" do
    sign_in users(:two)		
    get :index
    assert_response :success
    assert_template "shared/access_denied"		
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
    assert_template :edit

    assert_select 'form' do
      assert_select 'input#user_name[value=?]', @user.name
      assert_select 'input#user_email[value=?]', @user.email
    end    
  end

  test "delete action" do
    @user.set_condition :active
    @user.save
    @user.reload

    delete :destroy, id: @user
    @user.reload  		
    assert_equal :removed, @user.get_condition

    assert_redirected_to users_path
    ability = Ability.new(@user)
    assert_not ability.can?(:access, Person), 'removed user havent access to Person'
    assert_not ability.can?(:access, Company), 'removed user havent access to Company'
    assert_not ability.can?(:access, CompanyPerson), 'removed user havent access to CompanyPerson'
  end

  test "activate action" do
    @user.set_condition :removed
    @user.save
    @user.reload

    post :activate, id: @user
    @user.reload
    assert_equal :active, @user.get_condition

    assert_redirected_to users_path
    ability = Ability.new(@user)
    assert ability.can?(:access, Person), 'active user must have access to Person'
    assert ability.can?(:access, Company), 'active user must have access to Company'
    assert ability.can?(:access, CompanyPerson), 'active user must have access to CompanyPerson'
  end

  test "stop action" do
    @user.set_condition :action
    @user.save
    @user.reload

    post :stop, id: @user
    @user.reload
    assert_equal :stoped, @user.get_condition

    assert_redirected_to users_path
    ability = Ability.new(@user)
    assert_not ability.can?(:access, Person), 'stoped user havent access to Person'
    assert_not ability.can?(:access, Company), 'stoped user havent access to Company'
    assert_not ability.can?(:access, CompanyPerson), 'stoped user havent access to CompanyPerson'
  end

  test "should get right json api index" do
    get :index, format: :json

    json = JSON.parse(response.body)

    assert_equal 2, json.length
    assert_equal 1, json.select {|user| user['name'].include?('User1')}.length, 'User must be in json'
    assert_equal 1, json.select {|user| user['name'].include?('User2')}.length, 'User2 must be in json'

    result = json.select {|user| user['id'] == @user.id}[0]

    assert_equal @user.name, result['name']
    assert_equal nil, result['email']
    assert_equal nil, result['password']
  end

end
