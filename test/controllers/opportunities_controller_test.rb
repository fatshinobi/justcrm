require 'test_helper'
include Devise::TestHelpers

class OpportunitiesControllerTest < ActionController::TestCase
  setup do
    @opportunity = opportunities(:one)
    @opportunity.user = users(:one)
    @opportunity.company = companies(:mycrosoft)
    @opportunity.person = people(:one)
    @opportunity.save
    @opportunity.reload

    sign_in users(:one)    
  end

  test "should get index" do
    opportunity = opportunities(:two)
    opportunity.user = users(:one)
    opportunity.save
    
    get :index
    assert_response :success
    assert_not_nil assigns(:opportunities)
    assert_equal 2, assigns(:opportunities).size

    assert_select '.entry', 2
    assert_select '.ava_pic', 2
    
    assigns(:opportunities).each do |opportunity|
      assert_select 'h2', opportunity.title
      assert_select '.about_text', opportunity.description
      assert_select "a[class='index_show_button']", opportunity.title do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal opportunity_path(opportunity), anchor.attributes["href"]
      end
    end
  end

  test "get index js" do
    opportunity = opportunities(:two)
    opportunity.user = users(:one)
    opportunity.save

    get :index, format: :js, stage: "awareness"
    assert_response :success
    assert_template :index
    assert_equal 2, assigns(:opportunities).size

    @opportunity.set_stage :interest
    @opportunity.save
    
    get :index, format: :js, stage: "awareness"
    assert_response :success
    assert_template :index
    assert_equal 1, assigns(:opportunities).size

    get :index, format: :js, stage: "interest"
    assert_response :success
    assert_template :index
    assert_equal 1, assigns(:opportunities).size

  end

  test "should get new" do
    get :new
    assert_response :success

    assert_select 'form' do
      assert_select '.control-label', 'Title'
      assert_select '.control-label', 'Description'
      assert_select '.control-label', 'Company'
      assert_select '.control-label', 'Curator'
      assert_select '.control-label', 'Person'
      assert_select '.control-label', 'Start'
      assert_select '.control-label', 'Finish'
      assert_select '.control-label', 'Amount'

      assert_select ".form_accept_button" do
        assert_select "[value=?]", 'Save'
      end
    end

  end

  test "should create opportunity" do
    assert_difference('Opportunity.count') do
      post :create, opportunity: { company_id: @opportunity.company_id, description: @opportunity.description, finish: @opportunity.finish, person_id: @opportunity.person_id, stage: @opportunity.stage, start: @opportunity.start, status: @opportunity.status, title: @opportunity.title, user_id: users(:one).id }
      #p assigns(:opportunity).errors
    end

    assert_redirected_to opportunity_path(assigns(:opportunity))
  end

  test "should show opportunity" do
    get :show, id: @opportunity
    assert_response :success
    assert_template :show    

    assert_select 'h1', @opportunity.title
    assert_select '.well', "Description:\n" + @opportunity.description

    assert_select 'h3', @opportunity.company.name
    assert_select 'a[title=?]', @opportunity.company.name do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal company_path(@opportunity.company), anchor.attributes["href"]
    end

  end

  test "should get edit" do
    get :edit, id: @opportunity
    assert_response :success
    assert_template :edit
    assert_select 'form' do
      assert_select 'input#opportunity_title[value=?]', @opportunity.title
      assert_select 'textarea#opportunity_description', @opportunity.description
      assert_select 'input#opportunity_company_id[value=?]', @opportunity.company.id
      assert_select 'input#opportunity_person_id[value=?]', @opportunity.person.id
      assert_select 'select#opportunity_user_id' do
        assert_select 'option[selected="selected"]', :text => @opportunity.user.name
      end
    end    
  end

  test "should update opportunity" do
    patch :update, id: @opportunity, opportunity: { company_id: @opportunity.company_id, description: @opportunity.description, finish: @opportunity.finish, person_id: @opportunity.person_id, stage: @opportunity.stage, start: @opportunity.start, status: @opportunity.status, title: @opportunity.title, user_id: users(:one).id }
    assert_redirected_to opportunity_path(assigns(:opportunity))
  end

  test "set next_stage" do
    @opportunity.set_stage :interest
    @opportunity.save
    post :next_stage, id: @opportunity

    assert_redirected_to opportunity_path(@opportunity)
    @opportunity.reload
    assert_equal :decision, @opportunity.get_stage

    post :prev_stage, id: @opportunity
    assert_redirected_to opportunity_path(@opportunity)    

    @opportunity.reload
    assert_equal :interest, @opportunity.get_stage
  end

  test "get funnel data" do
    opportunity = opportunities(:two)
    opportunity.user = users(:one)
    opportunity.save

    get :funnel_data, :format => "json"
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal 'awareness', body[0]["label"]
    assert_equal 2, body[0]["data"]
    assert_equal 'interest', body[1]["label"]
    assert_equal 0, body[1]["data"]
    assert_equal 'decision', body[2]["label"]
    assert_equal 0, body[2]["data"]
    assert_equal 'buy', body[3]["label"]
    assert_equal 0, body[3]["data"]

    @opportunity.set_stage :interest
    @opportunity.save

    get :funnel_data, :format => "json"
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal 'awareness', body[0]["label"]
    assert_equal 1, body[0]["data"]
    assert_equal 'interest', body[1]["label"]
    assert_equal 1, body[1]["data"]
    assert_equal 'decision', body[2]["label"]
    assert_equal 0, body[2]["data"]
    assert_equal 'buy', body[3]["label"]
    assert_equal 0, body[3]["data"]

  end

  test "get show with appointments" do
    appointment = Appointment.first
    appointment.opportunity = @opportunity
    appointment.save

    appointment = Appointment.last
    appointment.opportunity = @opportunity
    appointment.save

    get :show, id: @opportunity
    assert_response :success
    assert_template :show

    appointments = assigns(:opportunity).appointments

    assert_equal 2, appointments.size

    assert_select 'h2', 'Appointments:'
    assert_select '.appointments_entry', 2

    appointments.each do |appointment|
      assert_select 'h3', appointment.when.to_formatted_s(:long)
      assert_select '.appointment_body_field', appointment.body
      assert_select '.appointment_curator_field', "Curator: " + appointment.user.name

      assert_select "a[class='appointment_show_button']", appointment.when.to_formatted_s(:long) do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal edit_appointments_from_opportunity_path(appointment, @opportunity), anchor.attributes["href"]        
      end

      if appointment.person then
        assert_select '.appointments_entry>a[title=?]', appointment.person.name do |anchors|
          assert_equal 1, anchors.count
          anchor = anchors[0]
          assert_equal person_path(appointment.person), anchor.attributes["href"]
        end
      end
    end
  end

end
