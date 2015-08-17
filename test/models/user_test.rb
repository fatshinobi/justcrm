require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "add and remove roles" do
    user = users(:one)
    assert_not user.has_role?(:tester), 'cant be tester'
    user.add_role :tester
    assert user.has_role?(:tester), 'must be tester'
    user.remove_role :tester
    assert_not user.has_role?(:tester), 'cant be tester after remove'		
  end

  test "check abilities" do
    user = users(:one)
    ability = Ability.new(user)
    assert_not ability.can?(:manage, :all), 'cant manage all'
    assert ability.can?(:manage, Company), 'must manage Company'
    assert ability.can?(:manage, Person), 'must manage Person'
    assert ability.can?(:manage, CompanyPerson), 'must manage CompanyPerson'

    assert ability.can?(:read, Company), 'must read Company'
    assert ability.can?(:read, Person), 'must read Person'
    assert ability.can?(:read, CompanyPerson), 'must read CompanyPerson'

    assert_not ability.can?(:read, User), 'cant read User'
    assert_not ability.can?(:manage, User), 'cant manage User'

    user.add_role :super_admin
    ability = Ability.new(user)		
    assert ability.can?(:manage, :all), 'sadmin must manage all'		
    assert ability.can?(:read, User), 'sadmin must read User'
    assert ability.can?(:manage, User), 'sadmin must manage User'
  end

  test "set condition" do
    user = users(:one)
    assert_equal 0, user.condition
    assert_equal :active, user.get_condition

    user.set_condition :removed
    assert_equal 2, user.condition
    assert_equal :removed, user.get_condition

    user.set_condition :stoped
    assert_equal 1, user.condition
    assert_equal :stoped, user.get_condition

    user.set_condition :active
    assert_equal 0, user.condition
    assert_equal :active, user.get_condition
  end
end
