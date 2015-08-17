require 'test_helper'
include Devise::TestHelpers

class ConditionsCompaniesControllerTest < ActionController::TestCase
  tests CompaniesController	

  setup do
    @company = companies(:mycrosoft)
    sign_in users(:one)
  end

  test "delete action" do
    @company.set_condition :active
    @company.save
    @company.reload

    delete :destroy, id: @company
    @company.reload      
    assert_equal :removed, @company.get_condition

    assert_redirected_to companies_path
  end

  test "activate action" do
    @company.set_condition :removed
    @company.save
    @company.reload

    post :activate, id: @company
    @company.reload
    assert_equal :active, @company.get_condition

    assert_redirected_to companies_path
  end

  test "stop action" do
    @company.set_condition :action
    @company.save
    @company.reload

    post :stop, id: @company
    @company.reload
    assert_equal :stoped, @company.get_condition

    assert_redirected_to companies_path
  end

  test "get index with unremoved" do
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 2, assigns(:companies).size

    @company.set_condition :stoped
    @company.save

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 2, assigns(:companies).size

    @company.set_condition :removed
    @company.save

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 1, assigns(:companies).size
  end

  test "show unremoved people of company" do
    get :show, id: @company
    assert_response :success
    assert_template :show
    assert_equal 2, assigns(:people).size

    person = assigns(:people).first.person
    person.set_condition :removed
    person.save

    get :show, id: @company
    assert_response :success
    assert_template :show
    assert_equal 1, assigns(:people).size

  end

  test "edit whith unremoved people of company" do
    get :edit, id: @company
    assert_response :success
    assert_template :edit
    assert_equal 2, assigns(:company).company_people.unremoved.size

    person = assigns(:company).company_people.unremoved.first.person
    person.set_condition :removed
    person.save

    get :edit, id: @company
    assert_response :success
    assert_template :edit
    assert_equal 1, assigns(:company).company_people.unremoved.size

  end

  test "index whith removed companies" do
      @company.set_condition :removed
      @company.save

      get :index, removed: 'true'
      assert_response :success
      assert_template :index
      assert_not_nil assigns(:companies)
      assert_equal 1, assigns(:companies).size
  end

end