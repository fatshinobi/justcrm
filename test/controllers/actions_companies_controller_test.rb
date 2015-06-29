require 'test_helper'

class ActionsCompaniesControllerTest < ActionController::TestCase
  tests CompaniesController	

  setup do
    @company = companies(:mycrosoft)
    sign_in users(:one)
  end

  test "should get index with pagination" do
    15.times do |i|
      comp = Company.create(name: "test" + i.to_s, user: users(:one))
    end
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 10, assigns(:companies).size

    get :index, page: 2
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 7, assigns(:companies).size
  end

  test "should get index with tagging" do
    company = Company.new(name: 'Test 1', user: users(:one))
    company.group_list.add('MyTag 1')
    company.save

    company = Company.new(name: 'Test 2', user: users(:one))
    company.group_list.add('MyTag 2')
    company.save

    get :index, tag: 'MyTag 1'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 1, assigns(:companies).size
    assert_select 'h4', "By tag: MyTag 1"

    get :index, tag: 'MyTag 2'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 1, assigns(:companies).size
    assert_select 'h4', "By tag: MyTag 2"

    get :index, tag: 'WrongTag'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 0, assigns(:companies).size
    assert_select 'h4', "By tag: WrongTag"
  end

  test "should get index with tagging and pagination matches" do
    15.times do |i|
      comp = Company.new(name: "test" + i.to_s, user: users(:one))
      comp.group_list.add('Tag 1')
      comp.save
    end

    5.times do |i|
      comp = Company.new(name: "non tagget test" + i.to_s, user: users(:one))
      comp.save
    end

    get :index, tag: 'Tag 1'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 10, assigns(:companies).size

    get :index, page: 2, tag: 'Tag 1'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 5, assigns(:companies).size
  end

  test "should get index with tag cloud" do
    company = Company.new(name: 'Test 1', user: users(:one))
    company.group_list.add('MyTag 1')
    company.save

    company = Company.new(name: 'Test 2', user: users(:one))
    company.group_list.add('MyTag 2, MyTag 1', parse: true)
    company.save

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:tags)
    assert_equal 2, assigns(:tags).size
    assert_equal 2, assigns(:tags).find_by_name('MyTag 1').taggings_count
    assert_equal 1, assigns(:tags).find_by_name('MyTag 2').taggings_count    

    assert_select 'p#show_tags_field' do
      assigns(:tags).each do |tag|
        assert_select 'a[href=?]', company_tag_path(tag.name)
      end
    end
  end

  test "should get index with searching" do
    get :index, contains: 'gg'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 1, assigns(:companies).size
  end

end