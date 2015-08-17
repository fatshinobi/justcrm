require 'test_helper'
include Devise::TestHelpers

class ConditionsPeopleControllerTest < ActionController::TestCase
  tests PeopleController

  setup do
    @person = people(:one)
    sign_in users(:one)    
  end

  test "delete action" do
    @person.set_condition :active
    @person.save
    @person.reload

    delete :destroy, id: @person
    @person.reload      
    assert_equal :removed, @person.get_condition

    assert_redirected_to people_path
  end

  test "activate action" do
    @person.set_condition :removed
    @person.save
    @person.reload

    post :activate, id: @person
    @person.reload
    assert_equal :active, @person.get_condition

    assert_redirected_to people_path
  end

  test "stop action" do
    @person.set_condition :action
    @person.save
    @person.reload

    post :stop, id: @person
    @person.reload
    assert_equal :stoped, @person.get_condition

    assert_redirected_to people_path
  end

  test "get index with unremoved" do
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 2, assigns(:people).size

    @person.set_condition :stoped
    @person.save

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 2, assigns(:people).size

    @person.set_condition :removed
    @person.save

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 1, assigns(:people).size
  end

  test "show unremoved companies of person" do
    company = companies(:goggle)
    company_link = CompanyPerson.new(company: company, role: 'test')
    @person.company_people << company_link
    @person.save

    get :show, id: @person
    assert_response :success
    assert_template :show
    assert_equal 2, assigns(:companies).size

    company = assigns(:companies).first.company
    company.set_condition :removed
    company.save

    get :show, id: @person
    assert_response :success
    assert_template :show
    assert_equal 1, assigns(:companies).size

  end

  test "edit whith unremoved companies of person" do
    company = companies(:goggle)
    company_link = CompanyPerson.new(company: company, role: 'test')
    @person.company_people << company_link
    @person.save

    get :edit, id: @person
    assert_response :success
    assert_template :edit
    assert_equal 2, assigns(:person).company_people.unremoved.size

    company.set_condition :removed
    company.save

    get :edit, id: @person
    assert_response :success
    assert_template :edit
    assert_equal 1, assigns(:person).company_people.unremoved.size
  
    assert_select '.fields', 2  #in nested fields has removed persons too

  end

  test "index whith removed companies" do
    person = Person.create(name: "Test")
    person.save

    @person.set_condition :removed
    @person.save

    get :index, removed: 'true'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 1, assigns(:people).size
  end

end