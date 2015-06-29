require 'test_helper'
include Devise::TestHelpers

class CompaniesControllerTest < ActionController::TestCase
  setup do
    @company = companies(:mycrosoft)
    sign_in users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:companies)
    assert_equal 2, assigns(:companies).size
    assert_select '.entry', 2
    assert_select "a[class='index_show_button']", 2
    assert_select '.ava_pic', 2

    assigns(:companies).each do |company|
      assert_select 'h2', company.name
      assert_select '.about_text', company.about
      assert_select "a[class='index_show_button']", company.name do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal company_path(company), anchor.attributes["href"]
      end

      assert_select "a[title=?]", company.name do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal company_path(company), anchor.attributes["href"]
      end      
    end
  end

  test "new company button on index" do
    get :index
    assert_select "a", 'New Company' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal new_company_path, anchor.attributes["href"]
    end
  end

  test "index company count" do
    get :index
    assert_equal(assigns(:companies).count, 2)    
  end

  test "index default logo instead of empty" do
    new_company = Company.create(name: 'Test 1', user: users(:one), ava: nil)
    get :index
    assert_response :success
    assert_template :index
    assert_equal 3, assigns(:companies).size
    assigns(:companies).each do |company|
      if company.id == new_company.id then
        assert_select 'img.ava_pic[src=?]', '/assets/thumb_anonym_company.png'        
      else
        assert_select 'img.ava_pic[src=?]', company.ava.thumb.url
      end
    end
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_template :new
    assert_select 'h1', 'New company'
    assert_select 'form' do
      assert_select '.form_field' do
        assert_select '.control-label', 'Avatar'
      end
      assert_select '.ava_loader'
      assert_select '.form_field', 'Name'
      assert_select '.form_field', 'About'
      assert_select '.form_field', 'Phone'
      assert_select '.form_field', 'Web'
      assert_select '.control-label', 'Curator'
      assert_select '.form_field', 'List All Tags, separate each tag by a comma'      
      assert_select ".form_accept_button" do
        assert_select "[value=?]", 'Save'
      end
    end
    assert_select "a", 'Back' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal companies_path, anchor.attributes["href"]
    end
  end

  test "should create company" do
    assert_difference('Company.count') do
      post :create, company: { about: @company.about, name: "FBI", phone: @company.phone, web: @company.web, user_id: users(:one).id }
    end
    
    assert_redirected_to company_path(assigns(:company))
  end

  test "can't create company whith empty name" do
    assert_no_difference('Company.count') do
      post :create, company: { about: @company.about, name: "", phone: @company.phone, web: @company.web }
    end
    assert_select 'form' do
      assert_select '.has-error' do 
        assert_select '.control-label', 'Name'
      end
    end    
    assert_select "li", 'Name can\'t be blank'
  end

  test "can't create company whith too short name" do
    assert_no_difference('Company.count') do
      post :create, company: { about: @company.about, name: "12", phone: @company.phone, web: @company.web }
    end
    assert_select 'form' do
      assert_select '.has-error' do 
        assert_select '.control-label', 'Name'
      end
    end    
    assert_select 'li', 'Name is too short (minimum is 3 characters)'
  end

  test "can't create company whith non unique name" do
    assert_no_difference('Company.count') do
      post :create, company: { about: @company.about, name: @company.name, phone: @company.phone, web: @company.web }
    end
    assert_select 'form' do
      assert_select '.has-error' do 
        assert_select '.control-label', 'Name'
      end
    end    
    assert_select 'li', 'Name has already been taken'
  end

  test "should show company" do
    @company.group_list.add 'tag 1, tag 2', parse: true
    @company.save
    get :show, id: @company
    assert_response :success
    assert_template :show
    assert_equal @company.name, assigns(:company).name
    assert_equal @company.phone, assigns(:company).phone
    assert_equal @company.web, assigns(:company).web
    
    assert_select 'h1', assigns(:company).name
    assert_select '.show_field', "Phone:\n" + assigns(:company).phone
    assert_select '.show_field', "Web:\n" + assigns(:company).web    
    assert_select '.show_field', "About:\n" + assigns(:company).about
    assert_select '.show_field', "Curator:\n" + assigns(:company).user.name
    assert_select '.ava_big_pic'

    assert_select "a", 'Edit' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal edit_company_path(@company), anchor.attributes["href"]
    end
    assert_select "a", 'Back' do |anchors|
      assert_equal 1, anchors.count
      anchor = anchors[0]
      assert_equal companies_path, anchor.attributes["href"]
    end
    assert_select 'p#show_tags_field' do
      @company.tags.each do |tag|
        assert_select 'a[href=?]', company_tag_path(tag.name)
      end
    end
  end

  test "show people of company" do
    get :show, id: @company
    assert_response :success
    assert_template :show
    assert_equal 2, assigns(:company).company_people.size
    assert_select 'h2', 'People:'
    assert_select '.company_person_entry', 2
    assert_select '.person_ava_pic', 2
    @company.company_people.each do |company_person|
      assert_select 'h3', company_person.person.name
      assert_select 'p', company_person.role
      assert_select "a", company_person.person.name do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal person_path(company_person.person), anchor.attributes["href"]
      end
      assert_select 'a[title=?]', company_person.person.name do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal person_path(company_person.person), anchor.attributes["href"]
      end
    end
  end

  test "show default logo instead of empty" do
    company = Company.create(name: 'Test 1', user: users(:one))
    get :show, id: company
    assert_response :success
    assert_template :show

    assert_select 'img.ava_big_pic[src=?]', '/assets/anonym_company.png'

    get :show, id: @company
    assert_response :success
    assert_template :show

    assert_select 'img.ava_big_pic[src=?]', @company.ava.normal.url
  end

  test "show people of company default logo instead of empty" do
    new_person = Person.create(name: "Test 1", ava: nil, user: users(:one))
    person_link = CompanyPerson.new(person: new_person, role: 'test')
    new_company = Company.create(name: 'Test 1', user: users(:one), company_people: [person_link])
    get :show, id: new_company
    assert_response :success
    assert_template :show

    assert_select 'img.person_ava_pic[src=?]', '/assets/thumb_anonymous.png'    

    person_link = CompanyPerson.new(person: people(:one), role: 'test')
    new_company = Company.create(name: 'Test 2', user: users(:one), company_people: [person_link])

    get :show, id: new_company
    assert_response :success
    assert_template :show

    assert_select 'img.person_ava_pic[src=?]', person_link.person.ava.thumb.url
  end

  test "should get edit" do
    @company.group_list.add 'tag 1, tag 2', parse: true
    @company.save
    get :edit, id: @company
    assert_response :success
    assert_template :edit
    assert_equal 2, assigns(:company).company_people.size
    assert_select '.fields', 2
    assert_select '.fields' do
      @company.company_people.each do |person_link|
        assert_select 'input.role_field[value=?]', person_link.role
        #assert_select 'select.form-control' do
        #  assert_select 'option[selected="selected"]', :text => person_link.person.name
        #end
      end
    end
    assert_select 'form' do
      assert_select '.form_field' do
        assert_select '.control-label', 'Avatar'
      end
      assert_select 'input#company_name[value=?]', @company.name
      assert_select 'textarea#company_about', @company.about
      assert_select 'input#company_phone[value=?]', @company.phone
      assert_select 'input#company_web[value=?]', @company.web
      assert_select 'input#company_tags[value=?]', @company.group_list
      assert_select 'select#company_user_id' do
        assert_select 'option[selected="selected"]', :text => @company.user.name
      end
    end    
  end

  test "should update company" do
    patch :update, id: @company, company: { about: @company.about, name: "Adam", phone: @company.phone, web: @company.web }

    assert_redirected_to company_path(assigns(:company))
    assert_equal 'Adam', Company.find(@company).name
  end

  test "get show with appointments" do
    company = companies(:goggle)
    person = Person.create(name: "John Underwood")
    link = CompanyPerson.create(company: company, person: person)
    person_appointment = Appointment.first
    person_appointment.person = person
    person_appointment.save

    get :show, id: company
    assert_response :success
    assert_template :show

    appointments = assigns(:company).appointments

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
        assert_equal edit_appointments_from_company_path(appointment, assigns(:company)), anchor.attributes["href"]        
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

  test "user by default must be current" do
    get :new
    assert_response :success
    assert_template :new
    assert_select 'form' do
      assert_select 'select#company_user_id' do
        assert_select 'option[selected="selected"]', :text => users(:one).name
      end
    end
    assert_equal assigns(:company).user.id, users(:one).id    
    sign_out users(:one)

    sign_in users(:two)
    get :new
    assert_response :success
    assert_template :new
    assert_select 'form' do
      assert_select 'select#company_user_id' do
        assert_select 'option[selected="selected"]', :text => users(:two).name
      end
    end
    assert_equal assigns(:company).user.id, users(:two).id
  end

  test "get show with opportunities" do
    company = companies(:goggle)
    opportunity = opportunities(:two)
    opportunity.company = company
    opportunity.save

    get :show, id: company
    assert_response :success
    assert_template :show

    opportunities = assigns(:company).opportunities

    assert_equal 2, opportunities.size

    assert_select 'h2', 'Opportunities:'
    assert_select '#opportunity_entries>.entry', 2

    opportunities.each do |opportunity|
      assert_select 'h2', opportunity.title
      assert_select '.about_text', opportunity.description
      assert_select "a[class='index_show_button']", opportunity.title do |anchors|
        assert_equal 1, anchors.count
        anchor = anchors[0]
        assert_equal opportunity_path(opportunity), anchor.attributes["href"]
      end
    end
  end


end
