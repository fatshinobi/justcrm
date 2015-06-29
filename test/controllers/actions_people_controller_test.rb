require 'test_helper'
include Devise::TestHelpers

class ActionsPeopleControllerTest < ActionController::TestCase
  tests PeopleController

  setup do
    @person = people(:one)
    sign_in users(:one)    
  end

  test "should get index with pagination" do
    15.times do |i|
      pers = Person.create(name: "test" + i.to_s, user: users(:one))
    end
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 10, assigns(:people).size

    get :index, page: 2
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 7, assigns(:people).size
  end

  test "should get index with tagging" do
    person = Person.new(name: 'Test 1', user: users(:one))
    person.group_list.add('MyTag 1')
    person.save

    person = Person.new(name: 'Test 2', user: users(:one))
    person.group_list.add('MyTag 2')
    person.save

    get :index, tag: 'MyTag 1'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 1, assigns(:people).size
    assert_select 'h4', "By tag: MyTag 1"

    get :index, tag: 'MyTag 2'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 1, assigns(:people).size
    assert_select 'h4', "By tag: MyTag 2"

    get :index, tag: 'WrongTag'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 0, assigns(:people).size
    assert_select 'h4', "By tag: WrongTag"
  end

  test "should get index with tagging and pagination matches" do
    15.times do |i|
      person = Person.new(name: "test" + i.to_s, user: users(:one))
      person.group_list.add('Tag 1')
      person.save
    end

    5.times do |i|
      person = Person.create(name: "non tagged test" + i.to_s, user: users(:one))
    end

    get :index, tag: 'Tag 1'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 10, assigns(:people).size

    get :index, page: 2, tag: 'Tag 1'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 5, assigns(:people).size
  end

  test "should get index with tag cloud" do
    person = Person.new(name: 'Test 1', user: users(:one))
    person.group_list.add('MyTag 1')
    person.save

    person = Person.new(name: 'Test 2', user: users(:one))
    person.group_list.add('MyTag 2, MyTag 1', parse: true)
    person.save

    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:tags)
    assert_equal 2, assigns(:tags).size
    assert_equal 2, assigns(:tags).find_by_name('MyTag 1').taggings_count
    assert_equal 1, assigns(:tags).find_by_name('MyTag 2').taggings_count    

    assert_select 'p#show_tags_field' do
      assigns(:tags).each do |tag|
        assert_select 'a[href=?]', person_tag_path(tag.name)
      end
    end
  end

  test "should get index with searching" do
    get :index, contains: 'av'
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:people)
    assert_equal 1, assigns(:people).size
  end

end