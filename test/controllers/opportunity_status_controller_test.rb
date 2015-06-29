require 'test_helper'

class OpportunityStatusControllerTest < ActionController::TestCase
  setup do
    @opportunity = opportunities(:one)
    @opportunity.user = users(:one)
    #@opportunity.company = companies(:mycrosoft)
    #@opportunity.person = people(:one)
    @opportunity.save
    @opportunity.reload

    sign_in users(:one)    
  end

  test "set status" do
    @opportunity.set_status :open
    @opportunity.save

    post :set_status, format: :js, id: @opportunity, status_name: 'finished' #, stage: 'buy'
    assert_response :success    
    @opportunity.reload
    assert_equal :finished, @opportunity.get_status
  end

  test "set status return size" do
    opportunity = opportunities(:two)
    opportunity.user = users(:one)
    opportunity.save

    post :set_status, format: :js, id: @opportunity, status_name: 'open' #, stage: 'buy'
    assert_response :success

    assert_equal 2, assigns(:opportunities).size
  end

  test "set status from stage" do
    opportunity = opportunities(:two)
    opportunity.user = users(:one)
    opportunity.set_stage :buy
    opportunity.save

    post :set_status, format: :js, id: @opportunity, status_name: 'open', stage: 'buy'
    assert_response :success

    assert_equal 1, assigns(:opportunities).size
  end


  test "set status from company" do
    opportunity = opportunities(:two)
    opportunity.user = users(:one)
    opportunity.save

    company = companies(:mycrosoft)

    post :set_status, format: :js, id: @opportunity, company_parent_id: company, status_name: 'open'
    assert_response :success    

    assert_equal 1, assigns(:opportunities).size
    assert_equal company, assigns(:opportunities).first.company
  end

  test "set status from person" do
    person = people(:one)

    opportunity = opportunities(:two)
    opportunity.user = users(:one)
    opportunity.person = person
    opportunity.save

    post :set_status, format: :js, id: @opportunity, person_parent_id: person, status_name: 'open'
    assert_response :success    

    assert_equal 1, assigns(:opportunities).size
    assert_equal person, assigns(:opportunities).first.person
  end

end
