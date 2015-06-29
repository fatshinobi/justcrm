require 'test_helper'

class AppointmentStatusControllerTest < ActionController::TestCase
  setup do
    @appointment = appointments(:one)
    @appointment.user = users(:one)
    @appointment.save

    sign_in users(:one)    
  end

  test "set status" do
    @appointment.set_status :open
    @appointment.save

    post :set_status, format: :js, id: @appointment, status_name: 'done'
    assert_response :success    
    @appointment.reload
    assert_equal :done, @appointment.get_status
  end

  test "set open status without parent js return size" do
    Appointment.all.each do |appointment|
      appointment.when = DateTime.now
      appointment.user = users(:one)
      appointment.save
    end

    post :set_status, format: :js, id: @appointment, status_name: 'open'
    assert_response :success

    assert_equal 2, assigns(:appointments).size
  end

  test "set status from company js" do
    company = companies(:mycrosoft)
    @appointment.company = company
    @appointment.save
   
    post :set_status, format: :js, status_name: 'open', id: @appointment, company_parent_id: company
    assert_response :success    

    assert_equal 1, assigns(:appointments).size
    assert_equal company, assigns(:appointments).first.company
  end

  test "set status from person js" do
    company = companies(:mycrosoft)
    person = company.company_people.first.person
    @appointment.company = company
    @appointment.person = person
    @appointment.save
   
    post :set_status, format: :js, status_name: 'open', id: @appointment, person_parent_id: person
    assert_response :success    

    assert_equal 1, assigns(:appointments).size
    assert_equal person, assigns(:appointments).first.person
  end

  test "set status from opportunity js" do
    company = companies(:mycrosoft)
    person = company.company_people.first.person
    opportunity = opportunities(:one)

    @appointment.company = company
    @appointment.person = person
    @appointment.opportunity = opportunity
    @appointment.save
   
    post :set_status, format: :js, status_name: 'open', id: @appointment, opportunity_parent_id: opportunity
    assert_response :success    

    assert_equal 1, assigns(:appointments).size
    assert_equal opportunity, assigns(:appointments).first.opportunity
  end

end
