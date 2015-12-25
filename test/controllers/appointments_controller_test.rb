require 'test_helper'

class AppointmentsControllerTest < ActionController::TestCase
  setup do
    @appointment = appointments(:one)
    sign_in users(:one)
  end

  test "should get new" do
    company = companies(:goggle)    
    get :new, company_parent_id: company
    assert_response :success
    assert_template :new
    assert_select 'h1', 'New appointment'
    assert_select 'form' do
      assert_select '.control-label', 'When'
      assert_select '.control-label', 'Company'
      assert_select '.control-label', 'Person'
      assert_select '.control-label', 'Opportunity'      
      assert_select '.control-label', 'About'
      assert_select '.control-label', 'Type'
      assert_select '.control-label', 'Curator'

      assert_select ".form_accept_button" do
        assert_select "[value=?]", 'Save'
      end
    end
    assert_select "a", 'Back' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal company_path(company), anchor.attributes["href"].value
    end

  end

  test "should get edit" do
    @appointment.opportunity = opportunities(:one)
    @appointment.save

    company = companies(:goggle)
    get :edit, id: @appointment, company_parent_id: company
    assert_response :success
    assert_template :edit
    assert_select 'form' do
      assert_select 'textarea#appointment_body', @appointment.body    	
      assert_select 'input#appointment_company_id[value=?]', @appointment.company.id.to_s
      assert_select 'input#appointment_person_id', 1

      assert_select 'select#appointment_opportunity_id' do
        assert_select 'option[selected="selected"]', :text => @appointment.opportunity.title if @appointment.opportunity
      end

      assert_select 'select#appointment_communication_type' do
        assert_select 'option[selected="selected"]', :text => @appointment.get_communication_type.to_s
      end
      assert_select 'select#appointment_user_id' do
        assert_select 'option[selected="selected"]', :text => @appointment.user.name
      end

    end
    assert_select "a", 'Back' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal company_path(company), anchor.attributes["href"].value
    end
    
  end

  test "should create appointment with company parent" do
    company = companies(:goggle)    
    assert_difference('Appointment.count') do
      post :create, appointment: { body: 'test', company_id: company.id, when: DateTime.now, user_id: users(:one).id }, company_parent_id: company.id
    end
    assert_redirected_to company_path(company)
  end

  test "should create appointment with person parent" do
    company = companies(:goggle)
    person = people(:one)

    assert_difference('Appointment.count') do
      post :create, appointment: { body: 'test', company_id: company.id, when: DateTime.now, user_id: users(:one).id }, person_parent_id: person.id
    end
    assert_redirected_to person_path(person)
  end

  test "should create appointment with opportunity parent" do
    company = companies(:goggle)
    opportunity = opportunities(:one)

    assert_difference('Appointment.count') do
      post :create, appointment: { body: 'test', company_id: company.id, when: DateTime.now, user_id: users(:one).id }, opportunity_parent_id: opportunity.id
    end
    assert_redirected_to opportunity_path(opportunity)
  end

  test "should create appointment without parent" do
    company = companies(:goggle)
    person = people(:one)

    assert_difference('Appointment.count') do
      post :create, appointment: { body: 'test', company_id: company.id, when: DateTime.now, user_id: users(:one).id }, person_parent_id: nil
    end
    assert_redirected_to root_path
  end

  test "should update appointment without parent" do
    company = @appointment.company
    patch :update, id: @appointment, appointment: { body: 'test', company_id: company.id, when: DateTime.now }, company_parent_id: nil

    assert_redirected_to root_path
  end

  test "should update appointment with company parent" do
    company = @appointment.company
    patch :update, id: @appointment, appointment: { body: 'test', company_id: company.id, when: DateTime.now }, company_parent_id: company.id

    assert_redirected_to company_path(company)
  end

  test "should update appointment with person parent" do
    company = @appointment.company
    person = people(:one)
    patch :update, id: @appointment, appointment: { body: 'test', company_id: company.id, when: DateTime.now }, person_parent_id: person.id

    assert_redirected_to person_path(person)
  end

  test "should update appointment with opportunity parent" do
    company = @appointment.company
    opportunity = opportunities(:one)

    patch :update, id: @appointment, appointment: { body: 'test', company_id: company.id, when: DateTime.now }, opportunity_parent_id: opportunity.id

    assert_redirected_to opportunity_path(opportunity)
  end

  test "user by default must be current" do
    get :new
    assert_response :success
    assert_template :new
    assert_select 'form' do
      assert_select 'select#appointment_user_id' do
        assert_select 'option[selected="selected"]', :text => users(:one).name
      end
    end

    assert_equal assigns(:appointment).user.id, users(:one).id    
    sign_out users(:one)

    sign_in users(:two)
    get :new
    assert_response :success
    assert_template :new
    assert_select 'form' do
      assert_select 'select#appointment_user_id' do
        assert_select 'option[selected="selected"]', :text => users(:two).name
      end
    end
    assert_equal assigns(:appointment).user.id, users(:two).id

  end

  test "should edit have data_controller attr" do
    get :edit, id: @appointment
    assert_response :success
    assert_template :edit
    assert_template layout: 'layouts/edit'

    assert_select 'body[data_controller=?]', 'appointments'
  end

  test "should new have data_controller attr" do
    get :new
    assert_response :success
    assert_template :new
    assert_template layout: 'layouts/edit'

    assert_select 'body[data_controller=?]', 'appointments'
  end

end
