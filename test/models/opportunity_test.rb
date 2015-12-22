require 'test_helper'

class OpportunityTest < ActiveSupport::TestCase
  test "opportunity title must not be empty" do
    opportunity = opportunities(:one)
    opportunity.title = nil
    assert opportunity.invalid?, 'title cant be empty'
    assert opportunity.errors[:title].any?
  end

  test "opportunity title is not too small" do
    opportunity = Opportunity.new(title: "123", user: users(:one), company: companies(:goggle))
    assert opportunity.invalid?, 'title is too short'
    assert opportunity.errors[:title].any?
  end
 
  test "user cant be empty" do
    opportunity = Opportunity.new(title: 'Test', company: companies(:goggle))
    assert opportunity.invalid?, 'User cant be empty'
    assert opportunity.errors[:user_id].any?    	
  end

  test "company cant be empty" do
    opportunity = Opportunity.new(title: 'Test', user: users(:one))
    assert opportunity.invalid?, 'Company cant be empty'
    assert opportunity.errors[:company].any?    	
  end

  test "company and person must match" do
    company = companies(:goggle)
    person = people(:one)
    opportunity = Opportunity.new(title: 'test', company: company, person: person, user: users(:one))

    assert opportunity.invalid?, 'Person dont matches to company'	

    company = companies(:mycrosoft)
    person = people(:one)
    opportunity = Opportunity.new(title: 'test', company: company, person: person, user: users(:one))

    assert opportunity.valid?, 'Person matches to company'	
  end

  test "set stage" do
    opportunity = opportunities(:one)
    assert_equal 0, opportunity.stage
    assert_equal :awareness, opportunity.get_stage

    opportunity.set_stage :interest
    assert_equal 1, opportunity.stage
    assert_equal :interest, opportunity.get_stage

    opportunity.set_stage :decision
    assert_equal 2, opportunity.stage
    assert_equal :decision, opportunity.get_stage

    opportunity.set_stage :buy
    assert_equal 3, opportunity.stage
    assert_equal :buy, opportunity.get_stage

  end

  test "stage next previous" do
    opportunity = opportunities(:one)
    opportunity.set_stage :awareness
    opportunity.next_stage
    assert_equal :interest, opportunity.get_stage

    opportunity.next_stage
    assert_equal :decision, opportunity.get_stage

    opportunity.next_stage
    assert_equal :buy, opportunity.get_stage

    opportunity.next_stage
    assert_equal :buy, opportunity.get_stage
    assert opportunity.is_last_stage?, 'must be last'

    opportunity.set_stage :buy
    opportunity.prev_stage
    assert_equal :decision, opportunity.get_stage

    opportunity.prev_stage
    assert_equal :interest, opportunity.get_stage

    opportunity.prev_stage
    assert_equal :awareness, opportunity.get_stage

    opportunity.prev_stage
    assert_equal :awareness, opportunity.get_stage
    assert opportunity.is_first_stage?, 'must be first'
  end

  test "get by stage" do
    opportunity = opportunities(:two)
    opportunity.user = users(:one)
    opportunity.save

    opportunities = Opportunity.by_stage :awareness, users(:one)
    assert_equal 2, opportunities.size

    opportunity = opportunities(:one)
    opportunity.set_stage :decision
    opportunity.save

    opportunities = Opportunity.by_stage :awareness, users(:one)
    assert_equal 1, opportunities.size

    opportunities = Opportunity.by_stage :decision, users(:one)
    assert_equal 1, opportunities.size

    opportunities = Opportunity.by_stage :buy, users(:one)
    assert_equal 0, opportunities.size

    opportunity = opportunities(:one)
    opportunity.set_stage :awareness
    opportunity.user = users(:two)
    opportunity.save

    opportunities = Opportunity.by_stage :awareness, users(:one)
    assert_equal 1, opportunities.size
  end

  test "get by user" do
    opportunities = Opportunity.by_user users(:one)
    assert_equal 1, opportunities.size

    opportunities = Opportunity.by_user users(:two)
    assert_equal 1, opportunities.size
  end

  test "set status" do
    opportunity = opportunities(:one)
    assert_equal 0, opportunity.status
    assert_equal :open, opportunity.get_status

    opportunity.set_status :finished
    assert_equal 1, opportunity.status
    assert_equal :finished, opportunity.get_status

    opportunity.set_status :canceled
    assert_equal 2, opportunity.status
    assert_equal :canceled, opportunity.get_status
  end

  test "by user and by stage only with open status" do
    opportunity = opportunities(:two)
    opportunity.user = users(:one)
    opportunity.save

    opportunities = Opportunity.by_user users(:one)
    assert_equal 2, opportunities.size

    opportunities = Opportunity.by_stage :awareness, users(:one)
    assert_equal 2, opportunities.size

    opportunity.set_status :finished
    opportunity.save

    opportunities = Opportunity.by_user users(:one)
    assert_equal 1, opportunities.size

    opportunities = Opportunity.by_stage :awareness, users(:one)
    assert_equal 1, opportunities.size

    opportunity.set_status :canceled
    opportunity.save

    opportunities = Opportunity.by_user users(:one)
    assert_equal 1, opportunities.size

    opportunities = Opportunity.by_stage :awareness, users(:one)
    assert_equal 1, opportunities.size
  end

  test "get overdue" do
    opportunity = opportunities(:two)
    opportunity.user=  users(:one)
    opportunity.save

    opportunities = Opportunity.overdue users(:one)
    assert_equal 2, opportunities.size

    opportunity.finish = Date.current
    opportunity.save

    opportunities = Opportunity.overdue users(:one)
    assert_equal 1, opportunities.size
    assert opportunities.first.finish < Date.current
  end

  test "should have user name" do
    opportunity = opportunities(:one)
    assert_equal users(:one).name, opportunity.user_name
  end

end
